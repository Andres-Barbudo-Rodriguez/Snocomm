//
//  01.5 - bindsocketudp.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/7/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation
import Network

let port: NWEndpoint.Port = 3333

let parameters = NWParameters.udp

let listener = try! NWListener(using: parameters, on: port)

listener.stateUpdateHandler = { newState in
    switch newState {
    case .ready:
        print("Listener ready on port \(port)")
    case .failed(let error):
        print("Failed to bind the socket. Error: \(error.localizedDescription)")
        exit(EXIT_FAILURE)
    default:
        break
    }
}

listener.newConnectionHandler = { newConnection in
    print("New connection received")
    newConnection.start(queue: .main)
}

listener.start(queue: .main)

dispatchMain()
