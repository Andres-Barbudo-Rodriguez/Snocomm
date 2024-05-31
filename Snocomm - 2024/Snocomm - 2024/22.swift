//
//  22.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 5/31/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation
import Network
import Security

let port: NWEndpoint.Port = 8080

func setupSSLParameters() -> NWProtocolTLS.Options {
    let tlsOptions = NWProtocolTLS.Options()
    
    
    let serverCert = SecCertificateCreateWithData(nil, Data(base64Encoded: "YOUR_BASE64_ENCODED_CERTIFICATE")! as CFData)
    let identity = SecIdentityCreateWithCertificate(nil, serverCert!, nil)
    
    sec_protocol_options_set_min_tls_protocol_version(tlsOptions.securityProtocolOptions, .TLSv12)
    
    sec_protocol_options_set_tls_server_identity(tlsOptions.securityProtocolOptions, identity!)
    
    return tlsOptions
}

let tlsOptions = setupSSLParameters()

let parameters = NWParameters(tls: tlsOptions)

let listener = try! NWListener(using: parameters, on: port)

listener.newConnectionHandler = { (newConnection) in
    newConnection.start(queue: .main)
    
    newConnection.receive(minimumIncompleteLength: 1, maximumLength: 16384) { (data, context, isComplete, error) in
        if let error = error {
            print("Error receiving data: \(error)")
            newConnection.cancel()
            return
        }
        
        let currentTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: currentTime)
        
        let response = "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: \(dateString.count)\r\n\r\n\(dateString)"
        
        newConnection.send(content: response.data(using: .utf8), completion: .contentProcessed { (sendError) in
            if let sendError = sendError {
                print("Error sending response: \(sendError)")
            }
            newConnection.cancel()
            })
    }
}

listener.start(queue: .main)

print("Servidor de fecha local: esperando conexiones...")

dispatchMain()
