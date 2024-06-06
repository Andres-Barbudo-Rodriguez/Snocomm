//
//  29.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/6/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation
import NIO
import NIOConcurrencyHelpers

let SERVER_HOST = "localhost"
let CHAT_SERVER_NAME = "server"


func send(_ channel: Channel, _ args: String) {
    let buffer = ByteBufferAllocator().buffer(string: args)
    let size = Int32(buffer.readableBytes).bigEndian
    var header = ByteBufferAllocator().buffer(capacity: MemoryLayout<Int32>.size)
    header.writeInteger(size)
    channel.writeAndFlush(NIOAny(header)).whenComplete { _ in
        channel.writeAndFlush(NIOAny(buffer))
    }
}

func receive(_ buffer: inout ByteBuffer) -> String? {
    guard let size = buffer.readInteger(as: Int32.self)?.byteSwapped else {
        return nil
    }
    guard buffer.readableBytes >= size else {
        return nil
    }
    return buffer.readString(length: Int(size))
}


class ChatServer {
    private let port: Int
    private var clients: Int
    private var clientMap: [Int: (Channel, String)]
    private var group: MultiThreadedEventLoopGroup
    
    init(port: Int) {
        self.port = port
        self.clients = 0
        self.clientMap = [:]
        self.group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
    }
    
    func run() {
        let bootstrap = ServerBootstrap(group: group)
            .serverChannelOption(ChannelOptions.backlog, value: 256)
            .serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
            .childChannelInitializer { channel in
                channel.pipeline.addHandler(ChatHandler(server: self))
            }
            .childChannelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
            .childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
        
        do {
            let channel = try bootstrap.bind(host: SERVER_HOST, port: port).wait()
            print("Servidor escuchando en el puerto: \(port)")
            try channel.closeFuture.wait()
        } catch {
            fatalError("Error al iniciar el servidor: \(error.localizedDescription)")
        }
    }
    
    func addClient(_ channel: Channel, address: String, name: String) {
        clients += 1
        clientMap[channel.hashValue] = (channel, name)
        send(channel, "CLIENT: \(address)")
        broadcastMessage("\n(Conectado: Nuevo cliente (\(clients)) desde \(name)@\(address))")
    }
    
    func removeClient(_ channel: Channel) {
        if let (_, name) = clientMap.removeValue(forKey: channel.hashValue) {
            clients -= 1
            broadcastMessage("\n(Terminal de control finalizada: Cliente desde \(name))")
        }
    }
    
    func broadcastMessage(_ message: String) {
        for (_, (channel, _)) in clientMap {
            send(channel, message)
        }
    }
}


final class ChatHandler: ChannelInboundHandler {
    typealias InboundIn = ByteBuffer
    private var server: ChatServer
    
    init(server: ChatServer) {
        self.server = server
    }
    
    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        var buffer = self.unwrapInboundIn(data)
        if let message = receive(&buffer) {
            if message.hasPrefix("NAME: ") {
                let name = String(message.dropFirst(6))
                server.addClient(context.channel, address: context.remoteAddress?.description ?? "unknown", name: name)
            } else {
                server.broadcastMessage(message)
            }
        }
    }
    
    func handlerAdded(context: ChannelHandlerContext) {
        context.channel.closeFuture.whenComplete { _ in
            self.server.removeClient(context.channel)
        }
    }
}


class ChatClient {
    private let name: String
    private let host: String
    private let port: Int
    private var channel: Channel?
    private var group: MultiThreadedEventLoopGroup
    
    init(name: String, host: String = SERVER_HOST, port: Int) {
        self.name = name
        self.host = host
        self.port = port
        self.group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    }
    
    func run() {
        let bootstrap = ClientBootstrap(group: group)
            .channelInitializer { channel in
                channel.pipeline.addHandler(ClientHandler(client: self))
            }
            .channelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
            .channelOption(ChannelOptions.connectTimeout, value: TimeAmount.seconds(10))
        
        do {
            channel = try bootstrap.connect(host: host, port: port).wait()
            if let channel = channel {
                send(channel, "NAME: \(name)")
                try channel.closeFuture.wait()
            }
        } catch {
            fatalError("Error al conectar con el servidor: \(error.localizedDescription)")
        }
    }
}


final class ClientHandler: ChannelInboundHandler {
    typealias InboundIn = ByteBuffer
    private var client: ChatClient
    
    init(client: ChatClient) {
        self.client = client
    }
    
    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        var buffer = self.unwrapInboundIn(data)
        if let message = receive(&buffer) {
            print(message)
        }
    }
    
    func channelActive(context: ChannelHandlerContext) {
        context.channel.closeFuture.whenComplete { _ in
            self.client.group.shutdownGracefully { _ in }
        }
    }
}


let arguments = CommandLine.arguments
if arguments.count > 2 {
    let name = arguments[1].split(separator: "=").last!
    let port = Int(arguments[2].split(separator: "=").last!)!
    
    if name == CHAT_SERVER_NAME {
        let server = ChatServer(port: port)
        server.run()
    } else {
        let client = ChatClient(name: String(name), port: port)
        client.run()
    }
} else {
    print("Uso: swift run MultiTerminalChat --name=<nombre> --port=<puerto>")
}
