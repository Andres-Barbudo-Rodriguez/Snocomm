//
//  27.swift
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
    
    let endpoint = NWEndpoint.hostPort(host: NWEndpoint.Host.ipv4(ipAddress), port: portNum)
    
    let listener = try? NWListener(using: .udp, on: portNum)
    
    listener?.stateUpdateHandler = { newState in
        switch newState {
        case .ready:
            print("Servidor listo en \(rawIPAddress) en el puerto \(portNum)")
        case .failed(let error):
            print("Fallo en el servidor: \(error)")
        default:
            break
        }
    }
    
    listener?.newConnectionHandler = { newConnection in
        print("Nueva conexión recibida")
        newConnection.start(queue: .global())
    }
    
    listener?.start(queue: .global())
    
    
    dispatchMain()
}

main()
