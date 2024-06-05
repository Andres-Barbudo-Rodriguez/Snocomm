//
//  02 - requests parte 1.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/4/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation
import Network

let DEFAULT_HOST = "127.0.0.1"
let DEFAULT_PORT: UInt16 = 8800

class RequestHandler: NSObject, URLSessionTaskDelegate {
    func handle(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let responseString = "Este es el servidor"
        let responseData = responseString.data(using: .utf8)
        
        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: 200,
            httpVersion: "HTTP/1.1",
            headerFields: ["Content-Type": "text/html"]
        )
        
        completion(responseData, response, nil)
    }
}

class CustomHTTPServer {
    let host: NWEndpoint.Host
    let port: NWEndpoint.Port
    var listener: NWListener?
    let handler = RequestHandler()
    
    init(host: String, port: UInt16) {
        self.host = NWEndpoint.Host(host)
        self.port = NWEndpoint.Port(rawValue: port)!
    }
    
    func start() {
        do {
            listener = try NWListener(using: .tcp, on: port)
            
            listener?.newConnectionHandler = { [weak self] newConnection in
                self?.handleConnection(newConnection)
            }
            
            listener?.stateUpdateHandler = { newState in
                switch newState {
                case .ready:
                    print("Servidor HTTP Custom inicializado en el puerto: \(self.port.rawValue)")
                case .failed(let error):
                    print("Error: \(error)")
                default:
                    break
                }
            }
            
            listener?.start(queue: .main)
        } catch {
            print("Error: \(error)")
        }
    }
    
    private func handleConnection(_ connection: NWConnection) {
        connection.start(queue: .main)
        
        connection.receiveMessage { [weak self] (data, context, isComplete, error) in
            guard let data = data, error == nil else {
                connection.cancel()
                return
            }
            
            let requestString = String(data: data, encoding: .utf8) ?? ""
            print("Request received: \(requestString)")
            
            if let handler = self?.handler {
                let request = URLRequest(url: URL(string: "http://\(self!.host):\(self!.port.rawValue)")!)
                
                handler.handle(request: request) { responseData, response, error in
                    if let responseData = responseData, let response = response as? HTTPURLResponse {
                        var responseString = "HTTP/1.1 \(response.statusCode) \(HTTPURLResponse.localizedString(forStatusCode: response.statusCode))\r\n"
                        response.allHeaderFields.forEach { key, value in
                            responseString += "\(key): \(value)\r\n"
                        }
                        responseString += "\r\n"
                        responseString += String(data: responseData, encoding: .utf8) ?? ""
                        
                        connection.send(content: responseString.data(using: .utf8), completion: .contentProcessed({ _ in
                            connection.cancel()
                        }))
                    } else {
                        connection.cancel()
                    }
                }
            }
        }
    }
}

func run_server(port: UInt16) {
    let server = CustomHTTPServer(host: DEFAULT_HOST, port: port)
    server.start()
    dispatchMain()
}

func main() {
    let arguments = CommandLine.arguments
    var port: UInt16 = DEFAULT_PORT
    
    if let portIndex = arguments.firstIndex(of: "--port"), portIndex + 1 < arguments.count {
        port = UInt16(arguments[portIndex + 1]) ?? DEFAULT_PORT
    }
    
    run_server(port: port)
}

main()
