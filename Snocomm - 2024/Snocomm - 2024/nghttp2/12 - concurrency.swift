//
//  12 - concurrency.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/20/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Vapor
import Foundation

final class AsyncUser {
    func req1() async throws -> Date {
    try await Task.sleep(nanoseconds: 100_000_000)
    return Date()
    }
    
    func req2() async throws -> Date {
    try await Task.sleep(nanoseconds: 200_000_000)
    return Date()
    }
}

func routes(_ app: Application) throws {
    app.get { req async throws -> String in
        let user = AsyncUser()
        async let response1 = user.req1()
        async let response2 = user.req2()
        let (result1, result2) = try await (response1, response2)
        print("response1,2: \(result1) \(result2)")
        return "response1: \(result1), response2: \(result2)"
    }
}

@main
struct MyApp: App {
    var body: some Scene {
    WindowGroup {
    ContentView()
    }
    }
    
    func configure(_ app: Application) {
        
        try! routes(app)
    }
    
    var port: Int {
        get {
            if let portString = CommandLine.arguments.last, let port = Int(portString) {
                return port
            } else {
                return 8080
            }
        }
    }
}
