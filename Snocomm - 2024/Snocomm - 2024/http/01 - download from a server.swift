//
//  01 - download from a server.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/4/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation

let REMOTE_SERVER_HOST = ""

class HTTPClient {
    var host: String
    
    init(host: String) {
        self.host = host
    }
    
    func fetch(completion: @escaping (String?) -> Void) {
        guard let url = URL(string: self.host) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            let text = String(data: data, encoding: .utf8)
            completion(text)
        }
        
        task.resume()
    }
}

func main() {
    var host = REMOTE_SERVER_HOST
    
    // Argument parsing
    let arguments = CommandLine.arguments
    if let hostIndex = arguments.firstIndex(of: "--host"), hostIndex + 1 < arguments.count {
        host = arguments[hostIndex + 1]
    }
    
    let client = HTTPClient(host: host)
    client.fetch { responseText in
        if let text = responseText {
            print(text)
        } else {
            print("Failed to fetch data")
        }
        exit(EXIT_SUCCESS)
    }
    
    // Run the run loop to wait for the asynchronous fetch to complete
    RunLoop.main.run()
}

main()
