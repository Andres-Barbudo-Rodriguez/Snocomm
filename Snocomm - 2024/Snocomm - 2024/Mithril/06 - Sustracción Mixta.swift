//
//  06 - Sustracción Mixta.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 7/22/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import BigInt

func usub_l(_ a_l: BigInt, _ b: UInt16) -> (BigInt, Int) {
    var d_l = BigInt(0)
    let tmp_l = BigInt(b)
    
    if a_l >= tmp_l {
        d_l = a_l - tmp_l
        let err = 0
        return (d_l, err)
    } else {
        $$
        let err = 1
        return (d_l, err)
    }
}

