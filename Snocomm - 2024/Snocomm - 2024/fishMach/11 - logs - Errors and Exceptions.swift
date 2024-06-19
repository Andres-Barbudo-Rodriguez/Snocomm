//
//  11 - logs - Errors and Exceptions.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/19/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

class ErrorLogger {
    static let shared = ErrorLogger()
    
    private init() {}
    
    func logError(error: Error) {
        let timestamp = Date()
        let logEntry = "\(timestamp): Error - \(error.localizedDescription)"
        sendLogToAdmin(logEntry)
    }
    
    private func sendLogToAdmin(_ logEntry: String) {
        // sending log to administrator
        print("Admin Log: \(logEntry)")
    }
}

// Usage
enum SampleError: Error {
    case networkError
    case dataProcessingError
}

func performRiskyOperation() throws {
    throw SampleError.networkError
}

do {
    try performRiskyOperation()
} catch {
    ErrorLogger.shared.logError(error: error)
}
