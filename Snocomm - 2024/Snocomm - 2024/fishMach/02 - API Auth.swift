//
//  02 - API Auth.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/19/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

// Authentication
func authenticateUser(email: String, password: String, completion: @escaping (String?) -> Void) {
    AuthService.shared.login(email: email, password: password) { token in
        completion(token)
    }
}

// Authorization
func authorizeUser(token: String, requiredPermission: String) -> Bool {
    let userPermissions = AuthService.shared.getPermissions(from: token)
    return userPermissions.contains(requiredPermission)
}

// Combining Authentication and Authorization
authenticateUser(email: "user@example.com", password: "password123") { token in
    guard let token = token else {
        // Show login error
        return
    }
    if authorizeUser(token: token, requiredPermission: "accessAPIEndpoint") {
        // Make API request
    } else {
        // Show authorization error
    }
}
