//
//  24.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/5/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation
import Network

let SERVER_HOST = "localhost"
let SERVER_PORT: NWEndpoint.Port = .any
let BUF_SIZE = 1024
let ECHO_MSG = "Echo Server activo"

class ForkedClient {
    var connection: NWConnection
    
    init(ip: String, port: NWEndpoint.Port) {
        self.connection = NWConnection(host: NWEndpoint.Host(ip), port: port, using: .tcp)
    }
    
    func run() {
        connection.stateUpdateHandler = { newState in
            switch newState {
            case .ready:
                print("Client ready")
                self.send(data: ECHO_MSG)
            default:
                break
            }
        }
        
        connection.start(queue: .global())
    }
    
    func send(data: String) {
        let currentProcessId = getpid()
        print("PID \(currentProcessId) Enviando mensaje echo al servidor: \"\(ECHO_MSG)\"")
        
        let dataToSend = data.data(using: .utf8)!
        connection.send(content: dataToSend, completion: .contentProcessed({ error in
            if let error = error {
                print("Error sending data: \(error)")
                return
            }
            print("Enviados: \(dataToSend.count) caracteres...")
            self.receive()
        }))
    }
    
    func receive() {
        connection.receive(minimumIncompleteLength: 1, maximumLength: BUF_SIZE) { data, _, _, error in
            if let data = data, !data.isEmpty {
                let currentProcessId = getpid()
                let response = String(data: data, encoding: .utf8)!
                print("PID \(currentProcessId) recibido: \(response)")
            }
            
            if let error = error {
                print("Error receiving data: \(error)")
            }
        }
    }
    
    func shutdown() {
        connection.cancel()
    }
}

class ForkingServerRequestHandler {
    let connection: NWConnection
    
    init(connection: NWConnection) {
        self.connection = connection
        self.handle()
    }
    
    func handle() {
        connection.receive(minimumIncompleteLength: 1, maximumLength: BUF_SIZE) { data, _, _, error in
            if let data = data, !data.isEmpty {
                let received = String(data: data, encoding: .utf8)!
                let currentProcessId = getpid()
                let response = "\(currentProcessId): \(received)"
                print("El servidor está enviando la respuesta [current_process_id: data] = [\(response)]")
                self.connection.send(content: response.data(using: .utf8), completion: .contentProcessed({ error in
                    if let error = error {
                        print("Error sending data: \(error)")
                    }
                }))
            }
            
            if let error = error {
                print("Error receiving data: \(error)")
            }
        }
    }
}

class ForkingServer {
    let listener: NWListener
    
    init() {
        self.listener = try! NWListener(using: .tcp, on: SERVER_PORT)
        self.start()
    }
    
    func start() {
        listener.stateUpdateHandler = { newState in
            switch newState {
            case .ready:
                print("Server ready on port \(self.listener.port!)")
            default:
                break
            }
        }
        
        listener.newConnectionHandler = { newConnection in
            newConnection.start(queue: .global())
            _ = ForkingServerRequestHandler(connection: newConnection)
        }
        
        listener.start(queue: .global())
    }
    
    func shutdown() {
        listener.cancel()
    }
}

func main() {
    let server = ForkingServer()
    let serverPort = server.listener.port!
    
    let client1 = ForkedClient(ip: SERVER_HOST, port: serverPort)
    client1.run()
    
    print("Primer cliente ejecutandose")
    
    let client2 = ForkedClient(ip: SERVER_HOST, port: serverPort)
    client2.run()
    
    print("segundo cliente ejecutandose")
    
    let client3 = ForkedClient(ip: SERVER_HOST, port: serverPort)
    client3.run()
    
    print("tercer cliente ejecutandose")
    
    Thread.sleep(forTimeInterval: 5.0)
    
    client1.shutdown()
    client2.shutdown()
    client3.shutdown()
    
    server.shutdown()
}

main()
