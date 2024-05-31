//
//  21.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 5/31/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation
import Network

func getCurrentTime() -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .full
    formatter.timeStyle = .full
    return formatter.string(from: Date())
}

func startServer() {
    let port: NWEndpoint.Port = 80
    let listener = try! NWListener(using: .tcp, on: port)
    
    print("Por favor espere, el sistema está configurando la dirección local")
    
    listener.newConnectionHandler = { (newConnection) in
        newConnection.start(queue: .main)
        
        print("El cliente se ha conectado...")
        newConnection.receive(minimumIncompleteLength: 1, maximumLength: 16384) { (data, context, isComplete, error) in
            if let data = data, !data.isEmpty {
                let request = String(decoding: data, as: UTF8.self)
                print("Recibidos \(data.count) bytes")
                print(request)
                
                let response = """
                HTTP/1.1 200 OK\r\n
                Connection: close\r\n
                Content-Type: text/plain\r\n\r\n
                La fecha local es: \(getCurrentTime())
                """
                let responseData = response.data(using: .utf8)!
                newConnection.send(content: responseData, completion: .contentProcessed { sendError in
                    if let sendError = sendError {
                        print("Error sending response: \(sendError)")
                    } else {
                        print("Enviados \(responseData.count) bytes")
                    }
                    newConnection.cancel()
                    })
            }
        }
    }
    
    listener.start(queue: .main)
    print("Escucha activa en el puerto \(port)")
    dispatchMain()
}


