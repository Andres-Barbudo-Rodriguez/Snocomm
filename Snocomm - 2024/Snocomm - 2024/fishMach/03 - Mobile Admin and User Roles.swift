//
//  03 - Mobile Admin and User Roles.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/19/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

enum UserRole {
    case admin, user
}

class User {
    var role: UserRole
    
    init(role: UserRole) {
        self.role = role
    }
}

func authorize(user: User, action: String) -> Bool {
    switch user.role {
    case .admin:
        return true // Admins have access to all actions
    case .user:
        return action == "viewProfile" // Users can only view their profile
    }
}

// Usage
let adminUser = User(role: .admin)
let normalUser = User(role: .user)

if authorize(user: adminUser, action: "deleteAccount") {
    print("Admin can delete account")
}

if !authorize(user: normalUser, action: "deleteAccount") {
    print("User cannot delete account")
}
