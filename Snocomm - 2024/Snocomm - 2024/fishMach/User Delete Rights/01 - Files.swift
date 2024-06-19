//
//  01 - Files.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/19/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation

func deleteFile(at path: String) {
    do {
        try FileManager.default.removeItem(atPath: path)
        print("File deleted: \(path)")
    } catch {
        print("Error deleting file: \(error)")
    }
}

// Usage
deleteFile(at: "/path/to/user/file.txt")
