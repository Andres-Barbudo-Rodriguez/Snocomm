//
//  02 - Errores.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/27/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation

enum ClintError: Error {
    case E_CLINT_BOR  // Borrow error
    case E_CLINT_DBZ  // Division by zero error
    case E_CLINT_MAL  // Memory allocation error
    case E_CLINT_MOD  // Modulus error
    case E_CLINT_NOR  // Normalization error
    case E_CLINT_NPT  // Null pointer error
    case E_CLINT_OFL  // Overflow error
    case E_CLINT_UFL  // Underflow error
    
    var localizedDescription: String {
        switch self {
        case .E_CLINT_BOR:
            return "Borrow error occurred."
        case .E_CLINT_DBZ:
            return "Division by zero error occurred."
        case .E_CLINT_MAL:
            return "Memory allocation error occurred."
        case .E_CLINT_MOD:
            return "Modulus error occurred."
        case .E_CLINT_NOR:
            return "Normalization error occurred."
        case .E_CLINT_NPT:
            return "Null pointer error occurred."
        case .E_CLINT_OFL:
            return "Overflow error occurred."
        case .E_CLINT_UFL:
            return "Underflow error occurred."
        }
    }
}

// ejemplo de uso
func performOperationThatMayFail() throws {
    // simulación del error
    throw ClintError.E_CLINT_DBZ
}

do {
    try performOperationThatMayFail()
} catch let error as ClintError {
    print("Error: \(error.localizedDescription)")
} catch {
    print("An unexpected error occurred: \(error)")
}
