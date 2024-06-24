//
//  01 - Listing Adapters.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/24/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation
import SystemConfiguration

func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)

    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    }

    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return false
    }

    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    return isReachable && !needsConnection
}

if isConnectedToNetwork() {
    print("Ok.")
} else {
    print("Failed to initialize.")
}
