//
//  01 - Mobile AAA.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/19/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

// Authentication
func authenticateUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
    // Assume we have a User model and AuthService
    AuthService.shared.login(email: email, password: password) { success in
        completion(success)
    }
}

// Authorization
func authorizeUser(user: User, action: String) -> Bool {
    let allowedActions = user.role.allowedActions
    return allowedActions.contains(action)
}

// Combining Authentication and Authorization
authenticateUser(email: "user@example.com", password: "password123") { success in
    if success {
        let user = AuthService.shared.currentUser
        if authorizeUser(user: user, action: "viewAdminDashboard") {
            // Present Admin Dashboard
        } else {
            // Show error or present normal user interface
        }
    } else {
        // Show login error
    }
}
