//
//  13 - División con Residuo.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 8/5/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation

typealias CLINT = [UInt16]
let BASEDIV2: UInt16 = 32768
let BASE: UInt16 = 65536
let BASEMINONE: UInt16 = 65535
let BITPERDGT: Int = 16
let CLINTMAXDIGIT: Int = 1024

func cpy_l(_ dest: inout CLINT, _ src: CLINT) {
    dest = src
}

func EQZ_L(_ clint: CLINT) -> Bool {
    return clint.allSatisfy { $0 == 0 }
}

func SETZERO_L(_ clint: inout CLINT) {
    clint = CLINT(repeating: 0, count: clint.count)
}

func SETONE_L(_ clint: inout CLINT) {
    SETZERO_L(&clint)
    clint[0] = 1
}

func DIGITS_L(_ clint: CLINT) -> Int {
    return clint.count
}

func MSDPTR_L(_ clint: CLINT) -> UnsafeMutablePointer<UInt16> {
    return UnsafeMutablePointer(mutating: clint) + (DIGITS_L(clint) - 1)
}

func LSDPTR_L(_ clint: CLINT) -> UnsafeMutablePointer<UInt16> {
    return UnsafeMutablePointer(mutating: clint)
}

func cmp_l(_ a: CLINT, _ b: CLINT) -> Int {
    if a == b { return 0 }
    return a.lexicographicallyPrecedes(b) ? -1 : 1
}

func SETDGITIS_L(_ clint: inout CLINT, _ digits: Int) {
    clint = Array(clint.prefix(digits))
}

func RMLDZRS_L(_ clint: inout CLINT) {
    while clint.last == 0 {
        clint.removeLast()
    }
}

func u2clint_l(_ clint: inout CLINT, _ value: UInt16) {
    SETZERO_L(&clint)
    clint[0] = value
}

func div_l(_ d1_l: CLINT, _ d2_l: CLINT, _ quot_l: inout CLINT, _ rem_l: inout CLINT) -> Int {
    var b_l = CLINT()
    var r_l = CLINT(repeating: 0, count: 2 + (CLINTMAXDIGIT << 1))
    var bv, rv, qhat, ri, ri_1, ri_2, bn_1, bn_2: UInt16
    var right, left, rhat, borrow, carry: UInt64
    var sbitsminusd: Int
    var d: Int = 0
    var i: Int
    
    cpy_l(&r_l, d1_l)
    cpy_l(&b_l, d2_l)
    
    if EQZ_L(b_l) {
        return -1
    }
    
    if EQZ_L(r_l) {
        SETZERO_L(&quot_l)
        SETZERO_L(&rem_l)
        return 0
    }
    
    i = cmp_l(r_l, b_l)
    
    if i == -1 {
        cpy_l(&rem_l, r_l)
        SETZERO_L(&quot_l)
        return 0
    } else if i == 0 {
        SETONE_L(&quot_l)
        SETZERO_L(&rem_l)
        return 0
    }
    
    if DIGITS_L(b_l) == 1 {
        goto shortdiv
    }
    
    var msdptrb_l = MSDPTR_L(b_l)
    bn_1 = msdptrb_l.pointee
    
    while bn_1 < BASEDIV2 {
        d += 1
        bn_1 <<= 1
    }
    
    sbitsminusd = BITPERDGT - d
    
    if d > 0 {
        bn_1 += msdptrb_l.advanced(by: -1).pointee >> sbitsminusd
        if DIGITS_L(b_l) > 2 {
            bn_2 = (msdptrb_l.advanced(by: -1).pointee << d) + (msdptrb_l.advanced(by: -2).pointee >> sbitsminusd)
        } else {
            bn_2 = (msdptrb_l.advanced(by: -1).pointee << d)
        }
    } else {
        bn_2 = msdptrb_l.advanced(by: -1).pointee
    }
    
    msdptrb_l = MSDPTR_L(b_l)
    var msdptrr_l = MSDPTR_L(r_l).advanced(by: 1)
    var lsdptrr_l = MSDPTR_L(r_l).advanced(by: -DIGITS_L(b_l) + 1)
    msdptrb_l.pointee = 0
    var qptr_l = quot_l + (DIGITS_L(r_l) - DIGITS_L(b_l) + 1)
    
    while lsdptrr_l >= LSDPTR_L(r_l) {
        ri = (msdptrr_l.pointee << d) + (msdptrr_l.advanced(by: -1).pointee >> sbitsminusd)
        ri_1 = (msdptrr_l.advanced(by: -1).pointee << d) + (msdptrr_l.advanced(by: -2).pointee >> sbitsminusd)
        
        if msdptrb_l.advanced(by: -3) > r_l {
            ri_2 = (msdptrr_l.advanced(by: -2).pointee << d) + (msdptrr_l.advanced(by: -3).pointee >> sbitsminusd)
        } else {
            ri_2 = (msdptrr_l.advanced(by: -2).pointee << d)
        }
        
        if ri != bn_1 {
            qhat = UInt16((rhat = ((UInt64(ri) << BITPERDGT) + UInt64(ri_1)) / UInt64(bn_1)))
            right = ((rhat = (rhat - (UInt64(bn_1) * UInt64(qhat)))) << BITPERDGT) + UInt64(ri_2)
        } else {
            qhat = BASEMINONE
            right = ((UInt64(rhat = UInt64(bn_1) + UInt64(ri_1)) << BITPERDGT) + UInt64(ri_2))
        }
        
        if (left = UInt64(bn_2) * UInt64(qhat)) > right {
            qhat -= 1
            
            if (rhat + UInt64(bn_1)) < UInt64(BASE) {
                if (left - UInt64(bn_2) > right + (UInt64(bn_1) << BITPERDGT)) {
                    qhat -= 1
                }
            }
        }
        
        borrow = UInt64(BASE)
        carry = 0
        
        for bptr_l in LSDPTR_L(b_l)..<msdptrb_l {
            if borrow >= UInt64(BASE) {
                rptr_l.pointee = UInt16(borrow = (UInt64(rptr_l.pointee) + UInt64(BASE) - (UInt64(bptr_l.pointee) * UInt64(qhat) + (carry >> BITPERDGT))))
            } else {
                rptr_l.pointee = UInt16(borrow = (UInt64(rptr_l.pointee) + UInt64(BASEMINONE) - (UInt64(bptr_l.pointee) * UInt64(qhat) + (carry >> BITPERDGT))))
            }
        }
        
        if borrow >= UInt64(BASE) {
            rptr_l.pointee = UInt16(borrow = (UInt64(rptr_l.pointee) + UInt64(BASE) - (carry >> BITPERDGT)))
        } else {
            rptr_l.pointee = UInt16(borrow = (UInt64(rptr_l.pointee) + UInt64(BASEMINONE) - (carry >> BITPERDGT)))
        }
        
        qptr_l.pointee = qhat
        
        if borrow < UInt64(BASE) {
            carry = 0
            
            for bptr_l in LSDPTR_L(b_l)..<msdptrb_l {
                rptr_l.pointee = UInt16(carry = (UInt64(rptr_l.pointee) + UInt64(bptr_l.pointee) + (carry >> BITPERDGT)))
            }
            rptr_l.pointee += UInt16(carry >> BITPERDGT)
            qptr_l.pointee -= 1
        }
        
        msdptrr_l -= 1
        lsdptrr_l -= 1
        qptr_l -= 1
    }
    
    SETDGITIS_L(&quot_l, DIGITS_L(r_l) - DIGITS_L(b_l) + 1)
    RMLDZRS_L(&quot_l)
    
    SETDGITIS_L(&r_l, DIGITS_L(b_l))
    cpy_l(&rem_l, r_l)
    
    return 0
    
    shortdiv:
    rv = 0
    bv = LSDPTR_L(b_l).pointee
    for rptr_l in MSDPTR_L(r_l)..<LSDPTR_L(r_l) {
        qptr_l.pointee = UInt16((rhat = (((UInt64(rv) << BITPERDGT) + UInt64(rptr_l.pointee)) / UInt64(bv))))
        rv = UInt16(rhat - (UInt64(bv) * UInt64(qptr_l.pointee)))
    }
    
    SETDGITIS_L(&quot_l, DIGITS_L(r_l))
    RMLDZRS_L(&quot_l)
    u2clint_l(&rem_l, rv)
    
    return 0 
}
