//
//  04 - Sustracción.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 7/8/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation

typealias CLINT = [UInt16]
let CLINTMAXSHORT = 16
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

func RMLDZRS_L(_ a: inout CLINT) {
    while a.last == 0 && a.count > 1 {
        a.removeLast()
    }
}

func LT_L(_ a: CLINT, _ b: CLINT) -> Bool {
    if a.count != b.count {
        return a.count < b.count
    }
    for i in (0..<a.count).reversed() {
        if a[i] != b[i] {
            return a[i] < b[i]
        }
    }
    return false
}

func setmax_l(_ a: inout CLINT) {
    a = Array(repeating: UInt16.max, count: CLINTMAXSHORT)
}

func cpy_l(_ dest: inout CLINT, _ src: CLINT) {
    dest = src
}

func add_l(_ a: CLINT, _ b: CLINT, _ s: inout CLINT) -> Int {
    
    var ss_l = CLINT = Array(repeating: 0, count: max(a_l.count, b_l.count) + 1)
    var msdpotra_l: UnsafeMutablePointer<UInt16>
    var msdptrb_l: UnsafeMutablePointer<UInt16>
    var aptr_l: UnsafeMutablePointer<UInt16>
    var bptr_l: UnsafeMutablePointer<UInt16>
    var sptr_l: UnsafeMutablePointer<UInt16> = LSDPTR_L(ss_l)
    var carry: UInt32 = 0
    var OFL = 0
    
    if DIGITS_L(a_l) < DIGITS_L(b_l) {
        aptr_l = LSDPTR_L(b_l)
        bptr_l = LSDPTTR_L(a_l)
        msdptra_l = MSDPTR_L(b_l)
        msdptrb_l = MSDPTR_L(a_l)
        SETDIGITS_L(&ss_l, DIGIT_L,(a_l))
    }
    
    while bptr_l <= msdptrb_l {
        carr = UInt32(aptr_l.pointee) + UInt32(bptr_l.pointee) + (carry >> 16)
        sptr_l.pointee = UInt16(carry & = 0XFFFF)
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
        SETDIGITS_L(&ss_l, DIGITS_l(ssl_l) + 1)
    }
    
    if DIGITS_l(ss_l) > 0xFFFF {
        ANDMAX(&ss_l)
        OFL = 1
    }
    
    cpy_l(&s_l, ss_l)
    return OFL
    
    
    return 0
}

func inc_l(_ a: inout CLINT) {
    var carry: UInt32 = 1
    for i in 0..<a.count {
        carry = UInt32(a[i]) + carry
        a[i] = UInt16(carry & 0xFFFF)
        carry >>= 16
        if carry == 0 {
            break
        }
    }
    if carry > 0 {
        a.append(UInt16(carry))
    }
}

func sub_l(_ aa_l: CLINT, _ bb_l: CLINT, _ d_l: inout CLINT) -> Int {
    var b_l: CLINT = Array(repeating: 0, count: CLINTMAXSHORT + 1)
    var a_l: CLINT = Array(repeating: 0, count: CLINTMAXSHORT + 1)
    var msdptra_l: UnsafeMutablePointer<UInt16>
    var msdptrb_l: UnsafeMutablePointer<UInt16>
    var aptr_l: UnsafeMutablePointer<UInt16>
    var bptr_l: UnsafeMutablePointer<UInt16>
    var dptr_l: UnsafeMutablePointer<UInt16> = LSDPTR_L(d_l)
    var carry: UInt32 = 0
    var UFL = 0
    
    cpy_l(&a_l, aa_l)
    cpy_l(&b_l, bb_l)
    msdptra_l = MSDPTR_L(a_l)
    msdptrb_l = MSDPTR_L(b_l)
    
    if LT_L(a_l, b_l) {
        setmax_l(&a_l)
        msdptra_l = UnsafeMutablePointer(mutating: a_l) + CLINTMAXSHORT
        SETDIGITS_L(&d_l, CLINTMAXSHORT)
        UFL = 1
    } else {
        SETDIGITS_L(&d_l, DIGITS_L(a_l))
    }
    
    while bptr_l <= msdptrb_l {
        carry = UInt32(aptr_l.pointee) - UInt32(bptr_l.pointee) - ((carry & BASE) >> BITPERDGT)
        dptr_l.pointee = UInt16(carry & 0xFFFF)
        aptr_l += 1
        bptr_l += 1
        dptr_l += 1
    }
    
    while aptr_l <= msdptra_l {
        carry = UInt32(aptr_l.pointee) - ((carry & BASE) >> BITPERDGT)
        dptr_l.pointee = UInt16(carry & 0xFFFF)
        aptr_l += 1
        dptr_l += 1
    }
    
    RMLDZRS_L(&d_l)
    
    if UFL != 0 {
        add_l(d_l, aa_l, &d_l)
        inc_l(&d_l)
    }
    return UFL
}
