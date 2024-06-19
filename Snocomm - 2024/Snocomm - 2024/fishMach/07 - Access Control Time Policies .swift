//
//  07 - Access Control Time Policies .swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/19/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

class User {
    var userId: String
    
    init(userId: String) {
        self.userId = userId
    }
}

func isWithinBusinessHours() -> Bool {
    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: Date())
    return hour >= 9 && hour <= 17
}

func authorizeAccess(user: User) -> Bool {
    return isWithinBusinessHours()
}

// Usage
let user = User(userId: "12345")

if authorizeAccess(user: user) {
    print("Access granted within business hours")
} else {
    print("Access denied outside business hours")
}
