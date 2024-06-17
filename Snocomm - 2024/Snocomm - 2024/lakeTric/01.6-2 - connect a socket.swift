//
//  01.6-2 - connect a socket.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/7/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation
import NIO

let host = "samplehost.book"
let port: Int = 3333


let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)

defer {
    try? group.syncShutdownGracefully()
}


let resolver = GetaddrinfoResolver(group: group)
let addressFuture = resolver.initiateResolution(host: host, port: String(port))

addressFuture.whenComplete { result in
    switch result {
    case .success(let address):
        guard let socketAddress = address.first else {
            print("No address found")
            return
        }
        

        do {
            let socket = try NIOClientTCPBootstrap(group: group)
                .connectTimeout(.seconds(5))
                .connect(host: host, port: port)
                .wait()
            
            print("Connected to \(socket.localAddress!)")

            
            try socket.close().wait()
        } catch {
            print("Error occurred! Error: \(error)")
        }
        
    case .failure(let error):
        print("Failed to resolve address: \(error)")
    }
}


try! group.next().scheduleTask(in: .seconds(10)) {}.futureResult.wait()
