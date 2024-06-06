//
//  05 - web requests through a proxy server.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/6/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation

let URL_STRING = "https://www.github.com"
let PROXY_ADDRESS = ""

func fetchURL() {
    guard let url = URL(string: URL_STRING) else {
        print("URL inválida")
        return
    }
    
    
    let config = URLSessionConfiguration.default
    
    
    let proxyDict: [AnyHashable: Any] = [
        kCFNetworkProxiesHTTPEnable: true,
        kCFNetworkProxiesHTTPProxy: "your-proxy-address",
        kCFNetworkProxiesHTTPPort: 8080
    ]
    config.connectionProxyDictionary = proxyDict
    
    let session = URLSession(configuration: config)
    
    
    let task = session.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error en la solicitud: \(error.localizedDescription)")
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            print("El servidor proxy devuelve las cabeceras de respuesta: \(httpResponse.allHeaderFields)")
        }
    }
    
    
    task.resume()
}


fetchURL()


RunLoop.main.run()
