//
//  08 - implementacion de fail-over para descargas interrumpidas.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/19/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation

let targetURL = "/.http/"
let targetFile = ""

class CustomURLSessionDelegate: NSObject, URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 206 {
            completionHandler(.allow)
        } else {
            completionHandler(.cancel)
        }
    }
}

func resumeDownload() {
    var fileExists = false
    let fileManager = FileManager.default
    let customDelegate = CustomURLSessionDelegate()
    let configuration = URLSessionConfiguration.default
    let session = URLSession(configuration: configuration, delegate: customDelegate, delegateQueue: nil)
    
    var outFile: FileHandle? = nil
    var fileSize: UInt64 = 0
    
    if fileManager.fileExists(atPath: targetFile) {
        outFile = try? FileHandle(forUpdating: targetFile)
        fileSize = (try? fileManager.attributesOfItem(atPath: targetFile)[.size] as? UInt64) ?? 0
        fileExists = true
    } else {
        fileManager.createFile(atPath: targetFile, contents: nil, attributes: nil)
        outFile = try? FileHandle(forWritingTo: URL(fileURLWithPath: targetFile))
    }
    
    guard let outFileHandle = outFile else {
        print("No se pudo abrir el archivo para escribir")
        return
    }
    
    var request = URLRequest(url: URL(string: targetURL + targetFile)!)
    if fileExists {
        request.setValue("bytes=\(fileSize)-", forHTTPHeaderField: "Range")
    }
    
    let dataTask = session.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print("Error al descargar el archivo: \(String(describing: error))")
            return
        }
        
        outFileHandle.seekToEndOfFile()
        outFileHandle.write(data)
        outFileHandle.closeFile()
        
        if let httpResponse = response as? HTTPURLResponse {
            for (key, value) in httpResponse.allHeaderFields {
                print("\(key) = \(value)")
            }
        }
        print("archivo copiado \(data.count) bytes desde \(request.url?.absoluteString ?? "")")
    }
    
    dataTask.resume()
}

resumeDownload()
