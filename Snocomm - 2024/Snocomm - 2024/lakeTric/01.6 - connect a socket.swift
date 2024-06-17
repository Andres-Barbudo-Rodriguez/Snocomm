//
//  01.6 - connect a socket.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/7/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation
import Network

let rawIPAddress = "127.0.0.1"
let port: NWEndpoint.Port = 3333

guard let host = NWEndpoint.Host(rawIPAddress) else {
    print("Error: Invalid IP address")
    exit(EXIT_FAILURE)
}

let connection = NWConnection(host: host, port: port, using: .tcp)

connection.stateUpdateHandler = { newState in
    switch newState {
    case .ready:
        print("Connected to \(rawIPAddress) on port \(port)")
    case .failed(let error):
        print("Error occurred! Error code = \(error.localizedDescription)")
        exit(EXIT_FAILURE)
    default:
        break
    }
}

connection.start(queue: .main)


dispatchMain()
