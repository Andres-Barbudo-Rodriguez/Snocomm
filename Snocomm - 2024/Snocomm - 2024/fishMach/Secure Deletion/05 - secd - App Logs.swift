//
//  05 - secd - App Logs.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/19/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

class SecureLogManager {
    func secureDeleteLogFile(at path: String) {
        secureDeleteFile(at: path)
    }
}

// Usage
let secureLogManager = SecureLogManager()
secureLogManager.secureDeleteLogFile(at: "/path/to/logfile.log")
