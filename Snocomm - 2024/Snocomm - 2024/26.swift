//
//  26.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/5/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation
import Network

func main() {
    let portNum: NWEndpoint.Port = 3333
    
    
    let ipAddress = "::"
    
    guard let endpointHost = NWEndpoint.Host(ipAddress) else {
        print("Fallo en la creación de la dirección IP.")
        return
    }
    
    let endpointPort = portNum
    
    let listener = try? NWListener(using: .tcp, on: endpointPort)
    
    listener?.stateUpdateHandler = { newState in
        switch newState {
        case .ready:
            print("Servidor listo en \(endpointHost) en el puerto \(endpointPort)")
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
