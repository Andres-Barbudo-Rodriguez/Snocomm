//
//  08 - Sustracción de valores en Decremento.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 7/22/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import BigInt

enum CLINTError: Error {
    case underflow
    case ok
}

func dec_l(_ a_l: inout BigInt) -> CLINTError {
    let BASE: BigInt = BigInt(1) << 16 // Suponiendo que BASE es 2^16
    let DBASEMINONE: BigInt = BASE - 1
    let BITPERDIGIT = 16
    
    if a_l == 0 {
        a_l = DBASEMINONE
        return .underflow
    }
    
    var aptr_l = a_l
    var carry: BigInt = 1
    let originalDigits = a_l.bitWidth / BITPERDIGIT
    
    while carry != 0 {
        if aptr_l == 0 {
            break
        }
        let sub = aptr_l - carry
        carry = sub < 0 ? 1 : 0
        aptr_l = (sub + BASE) % BASE
        if carry != 0 {
            a_l = (a_l >> BITPERDIGIT) - 1
        } else {
            a_l = (a_l & ~(BASE - 1)) | aptr_l
        }
    }
    
    // Remove leading zeros
    while a_l != 0 && a_l & (BASE - 1) == 0 {
        a_l >>= BITPERDIGIT
    }
    
    return .ok
}

// Ejemplo de uso:
var a_l = BigInt("123456789123456789")
let result = dec_l(&a_l)
switch result {
case .ok:
    print("Resultado: \(a_l), No hay error.")
case .underflow:
    print("Resultado: \(a_l), Subdesbordamiento detectado.")
}
