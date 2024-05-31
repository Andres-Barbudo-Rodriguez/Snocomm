//
//  23.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 5/31/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation
import Network

func printUsage() {
    print("modo de uso: clienteDeTCP ·host· ·puerto·")
}

func connectToServer(host: String, port: String) {
    print("Configurando dirección remota...")
    let connection = NWConnection(host: NWEndpoint.Host(host), port: NWEndpoint.Port(port)!, using: .tcp)
    
    connection.stateUpdateHandler = { newState in
        switch newState {
        case .ready:
            print("Conectado.")
            print("Para enviar datos, escriba el texto y presione intro")
            readFromServer(connection: connection)
        case .failed(let error):
            print("La conexión falló: \(error)")
        default:
            break
        }
    }
    
    connection.start(queue: .main)
}

func readFromServer(connection: NWConnection) {
    connection.receive(minimumIncompleteLength: 1, maximumLength: 4096) { (data, context, isComplete, error) in
        if let error = error {
            print("Error al recibir datos: \(error)")
            return
        }
        
        if let data = data {
            let response = String(data: data, encoding: .utf8) ?? ""
            print("Recibidos (\(data.count) bytes): \(response)")
        }
        
        readFromServer(connection: connection)
    }
}

func main() {
    let args = CommandLine.arguments
    guard args.count == 3 else {
        printUsage()
        return
    }
    
    let host = args[1]
    let port = args[2]
    
    connectToServer(host: host, port: port)
    
    dispatchMain()
}

main()
