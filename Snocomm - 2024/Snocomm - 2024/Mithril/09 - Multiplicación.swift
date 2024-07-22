//
//  09 - Multiplicación.swift
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

func mul_l(_ f1_l: BigInt, _ f2_l: BigInt) -> (BigInt, CLINTError) {
    let BITPERDGT = 16
    let CLINTMAXDIGIT = 1024
    
    var pp_l = BigInt(0)
    
    if f1_l == 0 || f2_l == 0 {
        return (pp_l, .ok)
    }
    
    
    var aa_l = f1_l
    var bb_l = f2_l
    
    
    var a_l: BigInt
    var b_l: BigInt
    
    if aa_l.bitWidth < bb_l.bitWidth {
        a_l = bb_l
        b_l = aa_l
    } else {
        a_l = aa_l
        b_l = bb_l
    }
    
    var carry: BigInt = 0
    let msdptra_l = a_l.bitWidth / BITPERDGT
    let msdptrb_l = b_l.bitWidth / BITPERDGT
    
    
    var av = a_l & (BigInt(1) << BITPERDGT - 1)
    var p_l = BigInt(0)
    
    for b in 0..<msdptrb_l {
        let b_l_digit = (b_l >> (b * BITPERDGT)) & (BigInt(1) << BITPERDGT - 1)
        let result = av * b_l_digit + (carry & (BigInt(1) << BITPERDGT - 1))
        carry = (carry >> BITPERDGT) + (result >> BITPERDGT)
        p_l |= (result & (BigInt(1) << BITPERDGT - 1)) << (b * BITPERDGT)
    }
    p_l |= carry << (msdptrb_l * BITPERDGT)
    
    
    for i in 1..<msdptra_l {
        av = (a_l >> (i * BITPERDGT)) & (BigInt(1) << BITPERDGT - 1)
        carry = 0
        
        for j in 0..<msdptrb_l {
            let b_l_digit = (b_l >> (j * BITPERDGT)) & (BigInt(1) << BITPERDGT - 1)
            let csptr_l = (p_l >> ((i + j) * BITPERDGT)) & (BigInt(1) << BITPERDGT - 1)
            
            let result = av * b_l_digit + csptr_l + (carry & (BigInt(1) << BITPERDGT - 1))
            carry = (carry >> BITPERDGT) + (result >> BITPERDGT)
            p_l &= ~(BigInt(1) << BITPERDGT - 1) << ((i + j) * BITPERDGT)
            p_l |= (result & (BigInt(1) << BITPERDGT - 1)) << ((i + j) * BITPERDGT)
        }
        p_l |= carry << ((i + msdptrb_l) * BITPERDGT)
    }
    
    
    let finalDigits = (p_l.bitWidth + BITPERDGT - 1) / BITPERDGT
    if finalDigits > CLINTMAXDIGIT {
        pp_l = (BigInt(1) << (CLINTMAXDIGIT * BITPERDGT)) - 1
        return (pp_l, .overflow)
    } else {
        pp_l = p_l
        return (pp_l, .ok)
    }
}
