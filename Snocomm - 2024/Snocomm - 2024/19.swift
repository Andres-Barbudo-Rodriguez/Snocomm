//
//  19.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 5/31/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation

class Github {
    var company: String
    
    init(apple: String) {
        self.company = apple
    }
    
    func boot() {
        print("\(company)")
    }
}

let efi = Github(apple: "/apple")

