//
//  01 - Optimización de Memoria y CPU.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/23/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation

let UCHAR_MAX: UInt8 = UInt8.max        // 0xff
let USHRT_MAX: UInt16 = UInt16.max      // 0xffff
let UINT_MAX: UInt32 = UInt32.max       // 0xffffffff
let ULONG_MAX: UInt32 = UInt32.max      // 0xffffffff
let ULONG_MAX: UInt64 = UInt64.max      // 0xffffffff

print("UCHAR_MAX: \(UCHAR_MAX)")
print("USHRT_MAX: \(USHRT_MAX)")
print("UINT_MAX: \(UINT_MAX)")
print("ULONG_MAX: \(ULONG_MAX)")

typealias Clint = UInt16
typealias CLINT = [Clint]

let CLINTMAXDIGIT = 0
let CLINTMAXSHORT = CLINTMAXDIGIT + 1
let CLINTMAXBIT = CLINTMAXDIGIT << 4

typealias CLINTD = [Clint]
typealias CLINTQ = [Clint]

func createCLINTD() -> CLINTD {
    return [Clint](repeating: 0, count: 1 + (CLINTMAXDIGIT << 1))
}

func createCLINTQ() -> CLINTQ {
    return [Clint](repeating: 0, count: 1 + (CLINTMAXDIGIT << 2))
}
