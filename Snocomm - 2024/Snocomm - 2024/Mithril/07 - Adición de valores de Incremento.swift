//
//  07 - Adición de valores de Incremento.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 7/22/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import BigInt

enum CLINTError: Error {
    case overflow
    case ok
}

func inc_l(_ a_l: inout BigInt) -> CLINTError {
    let BASE: BigInt = BigInt(1) << 16
    var carry: BigInt = 1
    let originalDigits = a_l.bitWidth / 16
    
    var aptr_l = a_l
    while carry != 0 {
        let sum = aptr_l + carry
        carry = sum >> 16
        aptr_l = sum & (BASE - 1)
        if carry != 0 {
            a_l = (a_l << 16) | aptr_l
        } else {
            a_l = (a_l & ~(BASE - 1)) | aptr_l
        }
    }
    
    let newDigits = a_l.bitWidth / 16
    if newDigits > originalDigits {
        
        if newDigits > Int(CLINTMAXDIGIT) {
            a_l = BigInt(0)
            return .overflow
        }
    }
    
    return .ok
}
