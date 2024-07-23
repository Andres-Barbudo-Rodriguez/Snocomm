//
//  10 - Multiplicación mixta.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 7/23/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation


enum ClintError: Error {
    case overflow
}

typealias CLINT = [UInt16]
typealias USHORT = UInt16
typealias ULONG = UInt32

let CLINTMAXSHORT = 16
let BITPERDGT = 16
let CLINTMAXDIGIT = 1024

let E_CLINT_OK = 0
let E_CLINT_OFL = 1


func cpy_l(_ dest: inout CLINT, _ src: CLINT) {
    dest = src
}

func EQZ_L(_ a: CLINT) -> Bool {
    return a.allSatisfy { $0 == 0 }
}

func SETZERO_L(_ a: inout CLINT) {
    a = [0]
}

func MSDPTR_L(_ a: CLINT) -> Int {
    return a.count - 1
}

func LSDPTR_L(_ a: CLINT) -> Int {
    return 0
}

func SETDIGITS_L(_ a: inout CLINT, _ digits: Int) {
    
    a = Array(a.prefix(digits))
}

func DIGITS_L(_ a: CLINT) -> Int {
    return a.count
}

func RMLDZRS(_ a: inout CLINT) {
    while a.last == 0 && a.count > 1 {
        a.removeLast()
    }
}

func ANDMAX_L(_ a: inout CLINT) {
    
    if a.count > CLINTMAXDIGIT {
        a = Array(a.prefix(CLINTMAXDIGIT))
    }
}

func umul(_ aa_l: CLINT, _ b: USHORT, _ pp_l: inout CLINT) throws -> Int {
    var a_l = CLINT(repeating: 0, count: CLINTMAXSHORT + 1)
    var p_l = CLINT(repeating: 0, count: CLINTMAXSHORT + 1)
    var carry: ULONG = 0
    var OFL = E_CLINT_OK
    
    cpy_l(&a_l, aa_l)
    
    if EQZ_L(a_l) || b == 0 {
        SETZERO_L(&pp_l)
        return E_CLINT_OK
    }
    
    let msdptra_l = MSDPTR_L(a_l)
    
    for i in LSDPTR_L(a_l)...msdptra_l {
        let product = ULONG(b) * ULONG(a_l[i]) + carry
        p_l[i] = USHORT(product & 0xFFFF)
        carry = product >> BITPERDGT
    }
    p_l[msdptra_l + 1] = USHORT(carry & 0xFFFF)
    
    SETDIGITS_L(&p_l, DIGITS_L(a_l) + 1)
    RMLDZRS(&p_l)
    
    if DIGITS_L(p_l) > USHORT(CLINTMAXDIGIT) {
        ANDMAX_L(&p_l)
        OFL = E_CLINT_OFL
    }
    
    cpy_l(&pp_l, p_l)
    if OFL == E_CLINT_OFL {
        throw ClintError.overflow
    }
    return OFL
}
