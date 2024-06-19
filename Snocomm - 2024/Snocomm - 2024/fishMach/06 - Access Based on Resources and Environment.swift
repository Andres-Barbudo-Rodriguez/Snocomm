//
//  06 - Access Based on Resources and Environment.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/19/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

class Document {
    var classification: String
    var ownerDepartment: String
    
    init(classification: String, ownerDepartment: String) {
        self.classification = classification
        self.ownerDepartment = ownerDepartment
    }
}

class User {
    var department: String
    var clearanceLevel: Int
    
    init(department: String, clearanceLevel: Int) {
        self.department = department
        self.clearanceLevel = clearanceLevel
    }
}

func authorizeDocumentAccess(user: User, document: Document) -> Bool {
    return user.clearanceLevel >= 3 && document.ownerDepartment == user.department
}

// Usage
let topSecretDocument = Document(classification: "TopSecret", ownerDepartment: "Research")
let researchUser = User(department: "Research", clearanceLevel: 4)
let salesUser = User(department: "Sales", clearanceLevel: 3)

if authorizeDocumentAccess(user: researchUser, document: topSecretDocument) {
    print("Research user can access the top-secret document")
}

if !authorizeDocumentAccess(user: salesUser, document: topSecretDocument) {
    print("Sales user cannot access the top-secret document")
}
