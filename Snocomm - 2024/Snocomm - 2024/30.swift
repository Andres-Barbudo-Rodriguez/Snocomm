//
//  30.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/7/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation
import NIO

let SERVER_HOST = "localhost"
let SERVER_PORT: Int = 3333
let SERVER_RESPONSE = """
HTTP/1.1 200 OK\r
Date: Mon, 1 Apr 2013 01:01:01 GMT\r
Content-Type: text/plain\r
Content-Length: 25\r
\r
Hello from NIO Server
"""

final class EchoHandler: ChannelInboundHandler {
    typealias InboundIn = ByteBuffer
    typealias OutboundOut = ByteBuffer
    
    private var receivedData: ByteBuffer = ByteBuffer()
    
    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        var buffer = self.unwrapInboundIn(data)
        self.receivedData.writeBuffer(&buffer)
        
        let eol1 = receivedData.readableBytesView.range(of: "\n\n".utf8)
        let eol2 = receivedData.readableBytesView.range(of: "\n\r\n".utf8)
        
        if eol1 != nil || eol2 != nil {
            var responseBuffer = context.channel.allocator.buffer(capacity: SERVER_RESPONSE.utf8.count)
            responseBuffer.writeString(SERVER_RESPONSE)
            context.writeAndFlush(self.wrapOutboundOut(responseBuffer), promise: nil)
            context.close(promise: nil)
        }
    }
    
    func errorCaught(context: ChannelHandlerContext, error: Error) {
        print("Error: \(error)")
        context.close(promise: nil)
    }
}

let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
defer {
    try? group.syncShutdownGracefully()
}

let bootstrap = ServerBootstrap(group: group)
    .serverChannelOption(ChannelOptions.backlog, value: 256)
    .serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
    .childChannelInitializer { channel in
        channel.pipeline.addHandler(EchoHandler())
    }
    .childChannelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
    .childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)

do {
    let serverChannel = try bootstrap.bind(host: SERVER_HOST, port: SERVER_PORT).wait()
    print("Server running on:", serverChannel.localAddress!)
    try serverChannel.closeFuture.wait()
} catch {
    print("Error: \(error)")
}
