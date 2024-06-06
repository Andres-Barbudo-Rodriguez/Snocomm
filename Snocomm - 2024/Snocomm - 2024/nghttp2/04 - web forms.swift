//
//  04 - web forms.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/6/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation

let ID_USERNAME = "signup-user-name"
let ID_EMAIL = "signup-user-email"
let ID_PASSWORD = "signup-user-password"
let USERNAME = "username"
let EMAIL = "you@icloud.com"
let PASSWORD = "yourpassword"
let SIGNUP_URL = "https://your-signup-url.com"


func submitForm() {

    let payload: [String: String] = [
        ID_USERNAME: USERNAME,
        ID_EMAIL: EMAIL,
        ID_PASSWORD: PASSWORD
    ]
    

    if let url = URL(string: SIGNUP_URL) {
        let getRequest = URLRequest(url: url)
        let getTask = URLSession.shared.dataTask(with: getRequest) { data, response, error in
            if let error = error {
                print("Error en la solicitud GET: \(error.localizedDescription)")
                return
            }
            if let data = data, let getContent = String(data: data, encoding: .utf8) {
                print("Respuesta a la solicitud GET: \(getContent)")
            }
        }
        getTask.resume()
        

        var postRequest = URLRequest(url: url)
        postRequest.httpMethod = "POST"
        postRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        postRequest.httpBody = payload.percentEncoded()
        
        let postTask = URLSession.shared.dataTask(with: postRequest) { data, response, error in
            if let error = error {
                print("Error en la solicitud POST: \(error.localizedDescription)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("Cabecera de la respuesta a una solicitud POST: \(httpResponse.allHeaderFields)")
            }
        }
        postTask.resume()
    }
}


extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
            .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}


submitForm()
