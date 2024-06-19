//
//  04 - User Account Data.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/19/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

class UserAccountManager {
    func deleteUserAccount(id: String) {
        // Code to delete user account from the database
        print("User account \(id) deleted")
    }
}

// Usage
let accountManager = UserAccountManager()
accountManager.deleteUserAccount(id: "user123")
