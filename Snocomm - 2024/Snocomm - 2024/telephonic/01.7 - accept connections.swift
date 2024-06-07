//
//  01.7 - accept connections.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/7/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation
import NIO

let BACKLOG_SIZE = 30
let port: Int = 3333


let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)

defer {
    try? group.syncShutdownGracefully()
}


let bootstrap = ServerBootstrap(group: group)
    .serverChannelOption(ChannelOptions.backlog, value: BACKLOG_SIZE)
    .serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)

    .childChannelInitializer { channel in
        channel.pipeline.addHandler(BackPressureHandler())
    }
    .childChannelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
    .childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)

do {

    let serverChannel = try bootstrap.bind(host: "0.0.0.0", port: port).wait()
    print("Server running on:", serverChannel.localAddress!)
    

    try serverChannel.closeFuture.wait()
} catch {
    print("Error occurred! Error: \(error)")
}
