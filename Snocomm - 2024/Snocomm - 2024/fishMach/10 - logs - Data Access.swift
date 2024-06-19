//
//  10 - logs - Data Access.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/19/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

class DataAccessLogger {
    static let shared = DataAccessLogger()
    
    private init() {}
    
    func logDataAccess(user: User, dataDescription: String) {
        let timestamp = Date()
        let logEntry = "\(timestamp): \(user.username) accessed \(dataDescription)"
        sendLogToAdmin(logEntry)
    }
    
    private func sendLogToAdmin(_ logEntry: String) {
        // sending log to administrator
        print("Admin Log: \(logEntry)")
    }
}

// Usage
let dataLogger = DataAccessLogger.shared
dataLogger.logDataAccess(user: user, dataDescription: "financial report")
