//
//  11 - Exponenciación.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 7/29/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

struct CLINT {
    
    var digits: Int = 0
    var isZero: Bool { return digits == 0 }
    var msdPtr: UnsafePointer<UInt16> {  }
    var lsdPtr: UnsafeMutablePointer<UInt16> { }
    
    mutating func setZero() {
        
    }
}

struct CLINTD {
    
    var lsdPtr: UnsafeMutablePointer<UInt16> {  }
    var msdPtr: UnsafeMutablePointer<UInt16> {  }
    
    mutating func removeLeadingZeros() {

    }
    
    mutating func andMax() {

    }
}


let E_CLINT_OK = 0
let E_CLINT_OFL = -1
let BITPERDGT: UInt32 = 16
let CLINTMAXDIGIT: Int = 1024

extension UnsafeMutablePointer {
    func advanced(by n: Int) -> UnsafeMutablePointer<Pointee> {
        return self + n
    }
    
    var pointee: Pointee {
        get { return self.pointee }
        set { self.pointee = newValue }
    }
    
    var successor: UnsafeMutablePointer<Pointee> {
        return self + 1
    }
}


func sqr_l(f_l: CLINT, pp_l: inout CLINT) -> Int {
    var a_l = CLINT()
    var p_l = CLINTD()
    var carry: UInt32 = 0
    var av: UInt16 = 0
    var OFL = E_CLINT_OK
    
    a_l = f_l
    if a_l.isZero {
        pp_l.setZero()
        return E_CLINT_OK
    }
    
    let msdptrb_l = a_l.msdPtr
    let msdptra_l = msdptrb_l - 1
    p_l.lsdPtr.pointee = 0
    av = a_l.lsdPtr.pointee
    
    for (bptr_l, pptr_l) in zip(a_l.lsdPtr.advanced(by: 1)...msdptrb_l, p_l.lsdPtr.advanced(by: 1)...p_l.msdPtr) {
        pptr_l.pointee = UInt16(carry: UInt32(av) * UInt32(bptr_l.pointee) + UInt32(UInt16(carry >> BITPERDGT)))
    }
    p_l.lsdPtr.advanced(by: a_l.digits + 1).pointee = UInt16(carry >> BITPERDGT)
    
    for (aptr_l, csptr_l) in zip(a_l.lsdPtr.advanced(by: 1)...msdptra_l, p_l.lsdPtr.advanced(by: 3).stride(by: 2)) {
        carry = 0
        av = aptr_l.pointee
        for (bptr_l, pptr_l) in zip(aptr_l.advanced(by: 1)...msdptrb_l, csptr_l...) {
            pptr_l.pointee = UInt16(carry: UInt32(av) * UInt32(bptr_l.pointee) + UInt32(pptr_l.pointee) + UInt32(UInt16(carry >> BITPERDGT)))
        }
        p_l.msdPtr.pointee = UInt16(carry >> BITPERDGT)
    }
    
    carry = 0
    for pptr_l in p_l.lsdPtr...p_l.msdPtr {
        pptr_l.pointee = UInt16(carry: (UInt32(pptr_l.pointee) << 1) + UInt32(UInt16(carry >> BITPERDGT)))
    }
    p_l.msdPtr.pointee = UInt16(carry >> BITPERDGT)
    
    carry = 0
    for (bptr_l, pptr_l) in zip(a_l.lsdPtr...msdptrb_l, p_l.lsdPtr...) {
        pptr_l.pointee = UInt16(carry: UInt32(bptr_l.pointee) * UInt32(bptr_l.pointee) + UInt32(pptr_l.pointee) + UInt32(UInt16(carry >> BITPERDGT)))
        pptr_l.successor().pointee = UInt16(carry: UInt32(pptr_l.successor().pointee) + (carry >> BITPERDGT))
    }
    
    p_l.digits = a_l.digits << 1
    p_l.removeLeadingZeros()
    
    if p_l.digits > CLINTMAXDIGIT {
        p_l.andMax()
        OFL = E_CLINT_OFL
    }
    pp_l = p_l
    return OFL
}
