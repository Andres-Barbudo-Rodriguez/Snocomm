//
//  05 - Adición Mixta.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 7/22/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import BigInt

func uadd_l(_ a_l: BigInt, _ b: UInt16) -> (BigInt, Int) {
    var s_l = BigInt(0)
    let tmp_l = BigInt(b)
    s_l = a_l + tmp_l
    
    let err = 0
    return (s_l, err)
}
