//
//  04 - Socket Setup.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/24/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation

#if os(Windows)
import WinSDK
#else
import Darwin
#endif

func initializeNetwork() {
    #if os(Windows)
    var wsaData = WSADATA()
    let result = WSAStartup(MAKEWORD(2, 2), &wsaData)
    if result != 0 {
        print("Failed to initialize.")
        exit(1)
    }
    #endif
    print("Ready to use socket API.")
}

func cleanupNetwork() {
    #if os(Windows)
    WSACleanup()
    #endif
}

func main() {
    initializeNetwork()
    // Your socket API code would go here.
    cleanupNetwork()
}

main()
