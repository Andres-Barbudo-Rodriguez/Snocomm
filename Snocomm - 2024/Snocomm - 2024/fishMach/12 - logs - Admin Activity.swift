//
//  12 - logs - Admin Activity.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/19/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

class AdminActionLogger {
    static let shared = AdminActionLogger()
    
    private init() {}
    
    func logAdminAction(admin: User, action: String) {
        let timestamp = Date()
        let logEntry = "\(timestamp): Admin \(admin.username) performed action: \(action)"
        sendLogToAdmin(logEntry)
    }
    
    private func sendLogToAdmin(_ logEntry: String) {
        // sending log to administrator
        print("Admin Log: \(logEntry)")
    }
}

// Usage
let adminUser = User(username: "adminUser")
AdminActionLogger.shared.logAdminAction(admin: adminUser, action: "changed user roles")
