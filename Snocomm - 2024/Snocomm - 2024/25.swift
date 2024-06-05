//
//  25.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/5/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation
import Network

func main() {
    let rawIPAddress = "127.0.0.1"
    let portNum: NWEndpoint.Port = 3333
    
    guard let ipAddress = IPv4Address(rawIPAddress) else {
        print("Fallo en el formato de la direccion IP.")
        return
    }
    
    let endpoint = NWEndpoint.Host.ipv4(ipAddress)
    let port = portNum
    
    let connection = NWConnection(host: endpoint, port: port, using: .tcp)
    
    connection.stateUpdateHandler = { newState in
        switch newState {
        case .ready:
            print("Conexión establecida con \(rawIPAddress) en el puerto \(portNum)")
        case .failed(let error):
            print("Fallo en la conexión: \(error)")
        default:
            break
        }
    }
    
    connection.start(queue: .global())
    
    
    dispatchMain()
}

main()
