//
//  07 - ahorrar ancho de banda.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/17/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation
import Swifter
import Gzip

let server = HttpServer()

let HTML_CONTENT = "<html><body><h1>Compressed Hello World!</h1></body></html>"

func compressBuffer(_ buffer: String) -> Data {
    if let data = buffer.data(using: .utf8) {
        return (try? data.gzipped()) ?? Data()
    }
    return Data()
}

server["/"] = { request in
    let compressedData = compressBuffer(HTML_CONTENT)
    return HttpResponse.raw(200, "OK", ["Content-Type": "text/html", "Content-Encoding": "gzip", "Content-Length": "\(compressedData.count)"], { writer in
        try writer.write(compressedData)
    })
}

do {
    let port: UInt16 = 8800
    try server.start(port)
    print("Server has started ( port = \(port) ). Try to connect now...")
    RunLoop.main.run()
} catch {
    print("Server start error: \(error)")
}
