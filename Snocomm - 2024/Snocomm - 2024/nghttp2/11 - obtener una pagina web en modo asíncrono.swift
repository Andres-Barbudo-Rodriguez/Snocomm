//
//  11 - obtener una pagina web en modo asíncrono.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/20/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation

class AsyncServer {
    func handleRequest(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            print("Error: \(error)")
        } else if let data = data, let body = String(data: data, encoding: .utf8) {
            print(body)
        }
    }
}

func runServer(url: String) {
    let asyncServer = AsyncServer()
    let session = URLSession.shared
    guard let url = URL(string: url) else {
        print("Invalid URL")
        return
    }
    let task = session.dataTask(with: url) { data, response, error in
        asyncServer.handleRequest(data: data, response: response, error: error)
        DispatchGroup().leave()
    }
    
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    
    task.resume()
    
    dispatchGroup.wait() 
}

let arguments = CommandLine.arguments
if arguments.count != 2 {
    print("Usage: \(arguments[0]) --url <URL>")
    exit(1)
}

let urlArgument = arguments[1]
if urlArgument == "--url", arguments.count == 3 {
    let url = arguments[2]
    runServer(url: url)
} else {
    print("Usage: \(arguments[0]) --url <URL>")
    exit(1)
}
