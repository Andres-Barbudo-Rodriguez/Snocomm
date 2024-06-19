//
//  03 - secd - Cache Data.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/19/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation

func secureClearCache(at path: String) {
    do {
        let cacheFiles = try FileManager.default.contentsOfDirectory(atPath: path)
        for file in cacheFiles {
            let filePath = "\(path)/\(file)"
            secureDeleteFile(at: filePath)
        }
        print("Cache securely cleared: \(path)")
    } catch {
        print("Error securely clearing cache: \(error)")
    }
}

// Usage
secureClearCache(at: "/path/to/cache")
