import Foundation

var addresses: UnsafeMutablePointer<ifaddrs>? = nil

guard getifaddrs(&addresses) == 0 else {
    print("La invocación a getifaddrs falló")
    exit(1)
}

var address = addresses
while address != nil {
    let family = address!.pointee.ifa_addr.pointee.sa_family
    
    if family == UInt8(AF_INET) || family == UInt8(AF_INET6) {
        print("\(String(cString: address!.pointee.ifa_name))\t", terminator: "")
        print("\(family == UInt8(AF_INET) ? "IPv4" : "IPv6")\t", terminator: "")
        
        var ap = [CChar](repeating: 0, count: Int(NI_MAXHOST))
        let familySize = family == UInt8(AF_INET) ? socklen_t(MemoryLayout<sockaddr_in>.size) : socklen_t(MemoryLayout<sockaddr_in6>.size)
        
        getnameinfo(address!.pointee.ifa_addr, familySize, &ap, socklen_t(ap.count), nil, 0, NI_NUMERICHOST)
        print("\t\(String(cString: ap))")
    }
    
    address = address!.pointee.ifa_next
}

freeifaddrs(addresses)
