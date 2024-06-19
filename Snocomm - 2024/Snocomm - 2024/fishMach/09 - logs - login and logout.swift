//
//  09 - logs - login and logout.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/19/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation

class Logger {
    static let shared = Logger()
    
    private init() {}
    
    func log(activity: String) {
        let timestamp = Date()
        let logEntry = "\(timestamp): \(activity)"
        sendLogToAdmin(logEntry)
    }
    
    private func sendLogToAdmin(_ logEntry: String) {
        // sending log to administrator
        print("Admin Log: \(logEntry)")
    }
}

class User {
    var username: String
    
    init(username: String) {
        self.username = username
    }
    
    func login() {
        Logger.shared.log(activity: "\(username) logged in")
    }
    
    func logout() {
        Logger.shared.log(activity: "\(username) logged out")
    }
}

// Usage
let user = User(username: "johnDoe")
user.login()
user.logout()
