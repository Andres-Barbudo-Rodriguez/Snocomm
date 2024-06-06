//
//  06 - solicitud de cabecera.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/6/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation

let DEFAULT_URL = "http://www.github.com"
let HTTP_GOOD_CODES: [Int] = [200, 302, 301]

func getServerStatusCode(url: String) -> Int? {
    guard let urlComponents = URLComponents(string: url),
        let host = urlComponents.host,
        let path = urlComponents.path.isEmpty ? "/" : urlComponents.path as String? else {
            return nil
    }
    
    var statusCode: Int?
    let semaphore = DispatchSemaphore(value: 0)
    
    var urlRequest = URLRequest(url: urlComponents.url!)
    urlRequest.httpMethod = "HEAD"
    
    let task = URLSession.shared.dataTask(with: urlRequest) { _, response, error in
        if let error = error {
            print("Error en la solicitud: \(error.localizedDescription)")
            semaphore.signal()
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            statusCode = httpResponse.statusCode
        }
        semaphore.signal()
    }
    task.resume()
    semaphore.wait()
    
    return statusCode
}

func main() {
    let arguments = CommandLine.arguments
    var url = DEFAULT_URL
    
    if arguments.count > 1 {
        let urlArgument = arguments[1]
        if urlArgument.starts(with: "--url=") {
            url = String(urlArgument.dropFirst(6))
        }
    }
    
    if let statusCode = getServerStatusCode(url: url) {
        if HTTP_GOOD_CODES.contains(statusCode) {
            print("El estado del Servidor es OK: \(url)")
        } else {
            print("El estado del Servidor es NOT OK: \(url)")
        }
    } else {
        print("No se pudo obtener el estado del servidor para la URL: \(url)")
    }
}

main()
