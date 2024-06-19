//
//  03 - Cache Data.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/19/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation

func clearCache(at path: String) {
    do {
        try FileManager.default.removeItem(atPath: path)
        print("Cache cleared: \(path)")
    } catch {
        print("Error clearing cache: \(error)")
    }
}

// Usage
clearCache(at: "/path/to/cache")
