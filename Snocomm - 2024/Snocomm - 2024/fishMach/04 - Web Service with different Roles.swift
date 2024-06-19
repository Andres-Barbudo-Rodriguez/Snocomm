//
//  04 - Web Service with different Roles.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/19/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

enum Role {
    case admin, editor, viewer
}

class WebServiceUser {
    var role: Role
    
    init(role: Role) {
        self.role = role
    }
}

func authorizeAction(for user: WebServiceUser, action: String) -> Bool {
    switch user.role {
    case .admin:
        return true // Admins can perform any action
    case .editor:
        return action == "editContent" || action == "viewContent"
    case .viewer:
        return action == "viewContent"
    }
}

// Usage
let editorUser = WebServiceUser(role: .editor)
let viewerUser = WebServiceUser(role: .viewer)

if authorizeAction(for: editorUser, action: "editContent") {
    print("Editor can edit content")
}

if !authorizeAction(for: viewerUser, action: "editContent") {
    print("Viewer cannot edit content")
}
