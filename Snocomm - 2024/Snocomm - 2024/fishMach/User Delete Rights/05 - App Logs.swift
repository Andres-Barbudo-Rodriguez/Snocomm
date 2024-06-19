//
//  05 - App Logs.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/19/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

class LogManager {
    func deleteLogFile(at path: String) {
        do {
            try FileManager.default.removeItem(atPath: path)
            print("Log file deleted: \(path)")
        } catch {
            print("Error deleting log file: \(error)")
        }
    }
}

// Usage
let logManager = LogManager()
logManager.deleteLogFile(at: "/path/to/logfile.log")
