//
//  package.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/6/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//


import PackageDescription

let package = Package(
    name: "MultiTerminalChat",
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "MultiTerminalChat",
            dependencies: [.product(name: "NIO", package: "swift-nio")]
        ),
        ]
)
