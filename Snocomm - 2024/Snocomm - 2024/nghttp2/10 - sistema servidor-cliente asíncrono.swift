//
//  10 - sistema servidor-cliente asíncrono.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/19/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation
import Network

class PubProtocol {
    var clients: Set<NWConnection> = []
    
    func connectionMade(connection: NWConnection) {
        clients.insert(connection)
    }
    
    func connectionLost(connection: NWConnection) {
        clients.remove(connection)
    }
    
    func lineReceived(line: Data, from connection: NWConnection) {
        let source = "<\(connection.endpoint)>".data(using: .ascii)!
        let message = source + line
        for client in clients {
            client.send(content: message, completion: .contentProcessed({ error in
                if let error = error {
                    print("Error al enviar mensaje: \(error)")
                }
            }))
        }
    }
}

class PubFactory {
    var clients: Set<NWConnection> = []
    var listener: NWListener?
    
    init(port: UInt16) {
        startListening(on: port)
    }
    
    func startListening(on port: UInt16) {
        do {
            listener = try NWListener(using: .tcp, on: NWEndpoint.Port(rawValue: port)!)
        } catch {
            print("Failed to create listener: \(error)")
            return
        }
        
        listener?.stateUpdateHandler = { newState in
            switch newState {
            case .ready:
                print("Listener ready on port \(port)")
            case .failed(let error):
                print("Listener failed with error: \(error)")
                exit(EXIT_FAILURE)
            default:
                break
            }
        }
        
        listener?.newConnectionHandler = { newConnection in
            self.setupNewConnection(newConnection)
        }
        
        listener?.start(queue: .main)
    }
    
    func setupNewConnection(_ connection: NWConnection) {
        connection.stateUpdateHandler = { newState in
            switch newState {
            case .ready:
                print("Client connected: \(connection.endpoint)")
                self.clients.insert(connection)
                self.receive(on: connection)
            case .failed(let error):
                print("Connection failed with error: \(error)")
                self.clients.remove(connection)
            case .cancelled:
                self.clients.remove(connection)
            default:
                break
            }
        }
        
        connection.start(queue: .main)
    }
    
    func receive(on connection: NWConnection) {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { (data, _, isComplete, error) in
            if let data = data, !data.isEmpty {
                self.lineReceived(line: data, from: connection)
            }
            if isComplete {
                self.connectionLost(connection: connection)
            } else if let error = error {
                print("Receive error: \(error)")
                self.connectionLost(connection: connection)
            } else {
                self.receive(on: connection)
            }
        }
    }
    
    func lineReceived(line: Data, from connection: NWConnection) {
        let source = "<\(connection.endpoint)>".data(using: .ascii)!
        let message = source + line
        for client in clients {
            client.send(content: message, completion: .contentProcessed({ error in
                if let error = error {
                    print("Error sending message: \(error)")
                }
            }))
        }
    }
    
    func connectionLost(connection: NWConnection) {
        clients.remove(connection)
    }
}

if CommandLine.arguments.count != 2 {
    print("Usage: \(CommandLine.arguments[0]) --port <port>")
    exit(EXIT_FAILURE)
}

let portString = CommandLine.arguments[1]
let port = UInt16(portString) ?? 0

if port == 0 {
    print("Invalid port number")
    exit(EXIT_FAILURE)
}

let factory = PubFactory(port: port)
dispatchMain()
