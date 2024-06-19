//
//  13 - logs - User Activity.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/19/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

class CriticalSectionLogger {
    static let shared = CriticalSectionLogger()
    
    private init() {}
    
    func logCriticalActivity(user: User, activity: String) {
        let timestamp = Date()
        let logEntry = "\(timestamp): \(user.username) performed critical activity: \(activity)"
        sendLogToAdmin(logEntry)
    }
    
    private func sendLogToAdmin(_ logEntry: String) {
        // sending log to administrator
        print("Admin Log: \(logEntry)")
    }
}

// Usage
let criticalLogger = CriticalSectionLogger.shared
criticalLogger.logCriticalActivity(user: user, activity: "initiated bank transfer of $1000")
