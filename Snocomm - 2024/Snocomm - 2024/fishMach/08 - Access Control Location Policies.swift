//
//  08 - Access Control Location Policies.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/19/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

class User {
    var userId: String
    var location: String
    
    init(userId: String, location: String) {
        self.userId = userId
        self.location = location
    }
}

func authorizeAccess(user: User, allowedLocations: [String]) -> Bool {
    return allowedLocations.contains(user.location)
}

// Usage
let userInOffice = User(userId: "12345", location: "Office")
let userRemote = User(userId: "67890", location: "Home")

let allowedLocations = ["Office", "Branch"]

if authorizeAccess(user: userInOffice, allowedLocations: allowedLocations) {
    print("Access granted in office or branch")
}

if !authorizeAccess(user: userRemote, allowedLocations: allowedLocations) {
    print("Access denied for remote user")
}
