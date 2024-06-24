//
//  02 - Listing Adapters.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/24/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation
import Network

func getNetworkInterfaces() {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue.global(qos: .background)
    monitor.start(queue: queue)
    
    monitor.pathUpdateHandler = { path in
        if path.status == .satisfied {
            print("Connected to network.")
            
            let interfaces = path.availableInterfaces
            for interface in interfaces {
                print("\nInterface name: \(interface.name)")
                print("\tType: \(interface.type)")
                // getifaddrs(?).net
            }
            
        } else {
            print("No network connection.")
        }
        
        monitor.cancel()
    }
}

func getInterfaceAddresses() {
    var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
    guard getifaddrs(&ifaddr) == 0 else {
        print("Failed to get network interfaces.")
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
                let address = family == UInt8(AF_INET) ? "IPV4" : "IPV6"
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                            &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST)
                let addressString = String(cString: hostname)
                print("\(name) - \(address): \(addressString)")
            }
        }
        ptr = interface.ifa_next
    }
}


getNetworkInterfaces()
getInterfaceAddresses()
