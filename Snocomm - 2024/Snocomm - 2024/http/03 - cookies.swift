//
//  03 - cookies.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/4/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation

let ID_USERNAME = "id_username"
let ID_PASSWORD = "id_password"
let USERNAME = "you@icloud.com"
let PASSWORD = "mypassword"
let LOGIN_URL = URL(string: "https://github.com")!
let NORMAL_URL = URL(string: "https://github.com")!

class CookieHandler {
    var cookies: [HTTPCookie] = []
    
    func extractCookieInfo() {
        let loginData = "\(ID_USERNAME)=\(USERNAME)&\(ID_PASSWORD)=\(PASSWORD)".data(using: .utf8)
        
        var loginRequest = URLRequest(url: LOGIN_URL)
        loginRequest.httpMethod = "POST"
        loginRequest.httpBody = loginData
        
        let session = URLSession.shared
        
        let loginTask = session.dataTask(with: loginRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error en la solicitud de inicio de sesión: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                self.cookies = HTTPCookie.cookies(withResponseHeaderFields: httpResponse.allHeaderFields as! [String: String], for: LOGIN_URL)
                
                for cookie in self.cookies {
                    print("---cookie del primer intento: \(cookie.name) ---> \(cookie.value)")
                }
                
                print("Headers: \(httpResponse.allHeaderFields)")
                
                var normalRequest = URLRequest(url: NORMAL_URL)
                let cookieHeader = HTTPCookie.requestHeaderFields(with: self.cookies)
                normalRequest.allHTTPHeaderFields = cookieHeader
                
                let normalTask = session.dataTask(with: normalRequest) { data, response, error in
                    if let error = error {
                        print("Error en la solicitud normal: \(error)")
                        return
                    }
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        let newCookies = HTTPCookie.cookies(withResponseHeaderFields: httpResponse.allHeaderFields as! [String: String], for: NORMAL_URL)
                        
                        for cookie in newCookies {
                            print("++++cookie del segundo intento: \(cookie.name) ---> \(cookie.value)")
                        }
                        
                        print("Cabecera: \(httpResponse.allHeaderFields)")
                    }
                }
                
                normalTask.resume()
            }
        }
        
        loginTask.resume()
    }
}

let cookieHandler = CookieHandler()
cookieHandler.extractCookieInfo()

RunLoop.main.run()
