//
//  12 - Multiplicación con el metodo de Karatsuba.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 7/30/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation

typealias Clint = [UInt32]
let CLINTMAXSHORT = 1024
let MUL_THRESHOLD = 32

func kmul(aptr_l: Clint, bptr_l: Clint, len_a: Int, len_b: Int, p_l: inout Clint) {
    var c01_l = Clint(repeating: 0, count: CLINTMAXSHORT + 2)
    var c10_l = Clint(repeating: 0, count: CLINTMAXSHORT + 2)
    var c0_l = Clint(repeating: 0, count: CLINTMAXSHORT + 2)
    var c1_l = Clint(repeating: 0, count: CLINTMAXSHORT + 2)
    var c2_l = Clint(repeating: 0, count: CLINTMAXSHORT + 2)
    var tmp_l = Clint(repeating: 0, count: CLINTMAXSHORT * 2 + 2)
    
    if (len_a == len_b) && (len_a >= MUL_THRESHOLD) && (len_a & 1 == 0) {
        let l2 = len_a / 2
        let a1ptr_l = Array(aptr_l[l2..<len_a])
        let b1ptr_l = Array(bptr_l[l2..<len_b])
        
        kmul(aptr_l: aptr_l, bptr_l: bptr_l, len_a: l2, len_b: l2, p_l: &c0_l)
        kmul(aptr_l: a1ptr_l, bptr_l: b1ptr_l, len_a: l2, len_b: l2, p_l: &c1_l)
        
        addkar(a1ptr_l, aptr_l, l2, &c01_l)
        addkar(b1ptr_l, bptr_l, l2, &c10_l)
        
        kmul(aptr_l: c01_l, bptr_l: c10_l, len_a: c01_l.count, len_b: c10_l.count, p_l: &c2_l)
        
        sub(c2_l, c1_l, &tmp_l)
        sub(tmp_l, c0_l, &c2_l)
        
        shiftadd(c1_l, c2_l, l2, &tmp_l)
        shiftadd(tmp_l, c0_l, l2, &p_l)
    } else {
        var c1_l_copy = Array(aptr_l[..<len_a])
        var c2_l_copy = Array(bptr_l[..<len_b])
        
        mult(&c1_l_copy, &c2_l_copy, &p_l)
        RMLDZRS_L(&p_l)
    }
}



func addkar(_ a: Clint, _ b: Clint, _ len: Int, _ result: inout Clint) {
    var carry: UInt32 = 0
    for i in 0..<len {
        let sum = UInt64(a[i]) + UInt64(b[i]) + UInt64(carry)
        result[i] = UInt32(sum & 0xFFFFFFFF)
        carry = UInt32(sum >> 32)
    }
    if carry != 0 {
        result[len] = carry
    }
}


func sub(_ a: Clint, _ b: Clint, _ result: inout Clint) {
    var borrow: Int64 = 0
    for i in 0..<a.count {
        let diff = Int64(a[i]) - Int64(b[i]) - borrow
        if diff < 0 {
            result[i] = UInt32(diff + 0x100000000)
            borrow = 1
        } else {
            result[i] = UInt32(diff)
            borrow = 0
        }
    }
}


func shiftadd(_ a: Clint, _ b: Clint, _ shift: Int, _ result: inout Clint) {
    for i in 0..<b.count {
        result[i + shift] += b[i]
    }
    var carry: UInt32 = 0
    for i in 0..<result.count {
        let sum = UInt64(result[i]) + UInt64(carry)
        result[i] = UInt32(sum & 0xFFFFFFFF)
        carry = UInt32(sum >> 32)
    }
}


func mult(_ a: inout Clint, _ b: inout Clint, _ result: inout Clint) {
    let len_a = a.count
    let len_b = b.count
    result = Clint(repeating: 0, count: len_a + len_b)
    
    for i in 0..<len_a {
        var carry: UInt64 = 0
        for j in 0..<len_b {
            let prod = UInt64(a[i]) * UInt64(b[j]) + UInt64(result[i + j]) + carry
            result[i + j] = UInt32(prod & 0xFFFFFFFF)
            carry = prod >> 32
        }
        result[i + len_b] = UInt32(carry)
    }
}


func RMLDZRS_L(_ a: inout Clint) {
    while a.last == 0 && a.count > 1 {
        a.removeLast()
    }
}
