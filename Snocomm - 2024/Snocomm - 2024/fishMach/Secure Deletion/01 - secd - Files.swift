//
//  01 - secFiles.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/19/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation

func secureDeleteFile(at path: String) {
    do {
        if FileManager.default.fileExists(atPath: path) {
            let fileData = try Data(contentsOf: URL(fileURLWithPath: path))
            let randomData = Data(count: fileData.count)
            try randomData.write(to: URL(fileURLWithPath: path))
            try FileManager.default.removeItem(atPath: path)
            print("File securely deleted: \(path)")
        }
    } catch {
        print("Error securely deleting file: \(error)")
    }
}

// Usage
secureDeleteFile(at: "/path/to/user/file.txt")
