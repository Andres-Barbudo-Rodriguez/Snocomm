//
//  03 - Adición.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 7/8/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation

typealias CLINT = [UInt16]
let BASE: UInt32 = 1 << 16
let BITPERDGT = 16

func LSDPTR_L(_ a: CLINT) -> UnsafeMutablePointer<UInt16> {
    return UnsafeMutablePointer(mutating: a)
}

func MSDPTR_L(_ a: CLINT) -> UnsafeMutablePointer<UInt16> {
    return UnsafeMutablePointer(mutating: a) + a.count - 1
}

func DIGITS_L(_ a: CLINT) -> Int {
    return a.count
}

func SETDIGITS_L(_ a: inout CLINT, _ digits: Int) {
    a = Array(a.prefix(digits))
}

func ANDMAX_L(_ a: inout CLINT) {
    
    
}

func cpy_l(_ dest: inout CLINT, _ src: CLINT) {
    dest = src
}

func add_l(_ a_l: CLINT, _ b_l: CLINT, _ s_l: inout CLINT) -> Int {
    var ss_l: CLINT = Array(repeating: 0, count: max(a_l.count, b_l.count) + 1)
    var msdptra_l: UnsafeMutablePointer<UInt16>
    var msdptrb_l: UnsafeMutablePointer<UInt16>
    var aptr_l: UnsafeMutablePointer<UInt16>
    var bptr_l: UnsafeMutablePointer<UInt16>
    var sptr_l: UnsafeMutablePointer<UInt16> = LSDPTR_L(ss_l)
    var carry: UInt32 = 0
    var OFL = 0
    
    if DIGITS_L(a_l) < DIGITS_L(b_l) {
        aptr_l = LSDPTR_L(b_l)
        bptr_l = LSDPTR_L(a_l)
        msdptra_l = MSDPTR_L(b_l)
        msdptrb_l = MSDPTR_L(a_l)
        SETDIGITS_L(&ss_l, DIGITS_L(b_l))
    } else {
        aptr_l = LSDPTR_L(a_l)
        bptr_l = LSDPTR_L(b_l)
        msdptra_l = MSDPTR_L(a_l)
        msdptrb_l = MSDPTR_L(b_l)
        SETDIGITS_L(&ss_l, DIGITS_L(a_l))
    }
    
    while bptr_l <= msdptrb_l {
        carry = UInt32(aptr_l.pointee) + UInt32(bptr_l.pointee) + (carry >> 16)
        sptr_l.pointee = UInt16(carry & 0xFFFF)
        aptr_l += 1
        bptr_l += 1
        sptr_l += 1
    }
    
    while aptr_l <= msdptra_l {
        carry = UInt32(aptr_l.pointee) + (carry >> 16)
        sptr_l.pointee = UInt16(carry & 0xFFFF)
        aptr_l += 1
        sptr_l += 1
    }
    
    if carry & BASE != 0 {
        sptr_l.pointee = 1
        SETDIGITS_L(&ss_l, DIGITS_L(ss_l) + 1)
    }
    
    if DIGITS_L(ss_l) > 0xFFFF {
        ANDMAX_L(&ss_l)
        OFL = 1
    }
    
    cpy_l(&s_l, ss_l)
    return OFL
}
