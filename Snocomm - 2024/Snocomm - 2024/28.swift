//
//  28.swift
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

func client(ip: String, port: NWEndpoint.Port, message: String) {
    let connection = NWConnection(host: NWEndpoint.Host(ip), port: port, using: .tcp)
    
    connection.stateUpdateHandler = { newState in
        switch newState {
        case .ready:
            print("Cliente listo y conectado a \(ip) en el puerto \(port)")
            connection.send(content: message.data(using: .utf8), completion: .contentProcessed({ error in
                if let error = error {
                    print("Error al enviar el mensaje: \(error)")
                    return
                }
                
                connection.receive(minimumIncompleteLength: 1, maximumLength: BUF_SIZE) { data, _, _, error in
                    if let data = data, !data.isEmpty {
                        let response = String(data: data, encoding: .utf8) ?? "Error al decodificar la respuesta"
                        print("El cliente ha recibido la respuesta: \(response)")
                    }
                    if let error = error {
                        print("Error al recibir la respuesta: \(error)")
                    }
                    connection.cancel()
                }
            }))
        case .failed(let error):
            print("Error de conexión: \(error)")
            connection.cancel()
        default:
            break
        }
    }
    
    connection.start(queue: .global())
}

class ThreadedTCPRequestHandler {
    let connection: NWConnection
    
    init(connection: NWConnection) {
        self.connection = connection
        handle()
    }
    
    func handle() {
        connection.receive(minimumIncompleteLength: 1, maximumLength: BUF_SIZE) { data, _, _, error in
            if let data = data, !data.isEmpty {
                let curThread = Thread.current
                let response = "\(curThread.name ?? "Thread"): \(String(data: data, encoding: .utf8) ?? "Error al decodificar")"
                self.connection.send(content: response.data(using: .utf8), completion: .contentProcessed({ error in
                    if let error = error {
                        print("Error al enviar la respuesta: \(error)")
                    }
                    self.connection.cancel()
                }))
            }
            if let error = error {
                print("Error al recibir los datos: \(error)")
                self.connection.cancel()
            }
        }
    }
}

class ThreadedTCPServer {
    let listener: NWListener
    
    init() throws {
        self.listener = try NWListener(using: .tcp, on: SERVER_PORT)
        setup()
    }
    
    private func setup() {
        listener.stateUpdateHandler = { newState in
            switch newState {
            case .ready:
                print("Servidor listo en \(self.listener.port!)")
            case .failed(let error):
                print("Error en el servidor: \(error)")
                self.listener.cancel()
            default:
                break
            }
        }
        
        listener.newConnectionHandler = { newConnection in
            newConnection.start(queue: .global())
            _ = ThreadedTCPRequestHandler(connection: newConnection)
        }
    }
    
    func start() {
        listener.start(queue: .global())
    }
    
    func shutdown() {
        listener.cancel()
    }
}

func main() {
    do {
        let server = try ThreadedTCPServer()
        server.start()
        
        if let port = server.listener.port {
            let serverThread = Thread {
                RunLoop.current.run()
            }
            serverThread.name = "ServerThread"
            serverThread.start()
            
            print("Bucle de servidor ejecutándose en el thread: \(serverThread.name!)")
            
            client(ip: SERVER_HOST, port: port, message: "Hello from client 1")
            client(ip: SERVER_HOST, port: port, message: "Hello from client 2")
            client(ip: SERVER_HOST, port: port, message: "Hello from client 3")
            
            
            sleep(5)
            
            server.shutdown()
        } else {
            print("No se pudo obtener el puerto del servidor")
        }
    } catch {
        print("Error al iniciar el servidor: \(error)")
    }
}

main()
