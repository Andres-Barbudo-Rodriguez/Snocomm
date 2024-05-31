//
//  20.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 5/31/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation

struct DateTimePrinter {
    static func printCurrentDateTime() {
        let timer = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        let dateString = dateFormatter.string(from: timer)
        
        print("La fecha local es: \(dateString)")
    }
}


