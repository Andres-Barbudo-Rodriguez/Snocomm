//
//  03 - Listing Adapters -mac ios and linux.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/24/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation

func getInterfaceAddresses() {
    var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
    guard getifaddrs(&ifaddr) == 0 else {
        print("getifaddrs call failed")
        return
    }
    defer {
        freeifaddrs(ifaddr)
    }
    
    var ptr = ifaddr
    while ptr != nil {
        if let interface = ptr?.pointee {
            let name = String(cString: interface.ifa_name)
            let family = interface.ifa_addr.pointee.sa_family
            if family == UInt8(AF_INET) || family == UInt8(AF_INET6) {
                print("\(name)\t", terminator: "")
                print(family == UInt8(AF_INET) ? "IPV4" : "IPV6", terminator: "\t")
                
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                let familySize = family == UInt8(AF_INET) ? MemoryLayout<sockaddr_in>.size : MemoryLayout<sockaddr_in6>.size
                if getnameinfo(interface.ifa_addr, socklen_t(familySize), &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                    let addressString = String(cString: hostname)
                    print("\t\(addressString)")
                } else {
                    print("\tgetnameinfo call failed")
                }
            }
        }
        ptr = interface.ifa_next
    }
}


getInterfaceAddresses()
