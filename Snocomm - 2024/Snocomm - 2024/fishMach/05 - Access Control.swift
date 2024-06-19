//
//  05 - Access Control.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/19/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

class User {
    var department: String
    var clearanceLevel: Int
    
    init(department: String, clearanceLevel: Int) {
        self.department = department
        self.clearanceLevel = clearanceLevel
    }
}

func authorizeAccess(user: User, resource: String, requiredClearanceLevel: Int) -> Bool {
    return user.clearanceLevel >= requiredClearanceLevel && user.department == "HR"
}

// Usage
let hrUser = User(department: "HR", clearanceLevel: 5)
let itUser = User(department: "IT", clearanceLevel: 4)

if authorizeAccess(user: hrUser, resource: "employeeRecords", requiredClearanceLevel: 4) {
    print("HR user can access employee records")
}

if !authorizeAccess(user: itUser, resource: "employeeRecords", requiredClearanceLevel: 4) {
    print("IT user cannot access employee records")
}
