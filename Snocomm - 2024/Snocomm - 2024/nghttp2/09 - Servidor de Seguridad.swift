//
//  09 - Servidor de Seguridad.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/19/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation
import Network
import NIOSSL
import NIOHTTP1
import NIO
import NIOHTTPServer

class SecureHTTPServer {
    let host: String
    let port: Int
    let certFilePath: String
    let keyFilePath: String
    
    init(host: String, port: Int, certFilePath: String, keyFilePath: String) {
        self.host = host
        self.port = port
        self.certFilePath = certFilePath
        self.keyFilePath = keyFilePath
    }
    
    func start() throws {
        let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        let tlsConfiguration = try TLSConfiguration.forServer(certificateChain: NIOSSLCertificate.fromPEMFile(certFilePath).map { .certificate($0) },
                                                              privateKey: .file(keyFilePath))
        let sslContext = try NIOSSLContext(configuration: tlsConfiguration)
        
        let bootstrap = ServerBootstrap(group: group)
            .serverChannelOption(ChannelOptions.backlog, value: 256)
            .serverChannelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
            .childChannelInitializer { channel in
                channel.pipeline.addHandler(NIOSSLServerHandler(context: sslContext)).flatMap {
                    channel.pipeline.addHTTPServerHandlers()
                    }.flatMap {
                        channel.pipeline.addHandler(HTTPHandler())
                }
            }
            .childChannelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
            .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 16)
            .childChannelOption(ChannelOptions.recvAllocator, value: AdaptiveRecvByteBufferAllocator())
        
        let channel = try bootstrap.bind(host: host, port: port).wait()
        guard let localAddress = channel.localAddress else {
            fatalError("Error intentando conectarse con: \(host):\(port)")
        }
        print("El servidor seguro se está ejecutando en \(localAddress.description) ...")
        try channel.closeFuture.wait()
    }
}

final class HTTPHandler: ChannelInboundHandler {
    public typealias InboundIn = HTTPServerRequestPart
    public typealias OutboundOut = HTTPServerResponsePart
    
    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let reqPart = self.unwrapInboundIn(data)
        
        switch reqPart {
        case .head(let request):
            print("Recibida solicitud: \(request)")
            let responseHead = HTTPResponseHead(version: request.version, status: .ok)
            context.write(self.wrapOutboundOut(.head(responseHead)), promise: nil)
            var buffer = context.channel.allocator.buffer(capacity: 128)
            buffer.writeString("Servidor seguro en ejecución\n")
            context.write(self.wrapOutboundOut(.body(.byteBuffer(buffer))), promise: nil)
            context.writeAndFlush(self.wrapOutboundOut(.end(nil)), promise: nil)
        case .body:
            break
        case .end:
            break
        }
    }
}

let certFilePath = "server.pem"
let keyFilePath = "server.pem"
let server = SecureHTTPServer(host: "0.0.0.0", port: 4443, certFilePath: certFilePath, keyFilePath: keyFilePath)
do {
    try server.start()
} catch {
    print("Error al iniciar el servidor: \(error)")
}
