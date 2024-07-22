//
//  01 - Interface para métodos estadísticos.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 7/22/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation
import SwiftR




func readDelim(filePath: String, delimiter: Character) -> [[String: String]]? {
    guard let content = try? String(contentsOfFile: filePath) else {
        print("No se pudo abrir el archivo en la ruta proporcionada")
        return nil
    }
    
    let rows = content.components(separatedBy: "\n").filter { !$0.isEmpty }
    guard let headerRow = rows.first else { return nil }
    let headers = headerRow.components(separatedBy: delimiter)
    
    var data: [[String: String]] = []
    
    for row in rows.dropFirst() {
        let values = row.components(separatedBy: delimiter)
        var rowDict: [String: String] = [:]
        
        for (index, header) in headers.enumerated() {
            if index < values.count {
                rowDict[header] = values[index]
            }
        }
        
        data.append(rowDict)
    }
    
    return data
}


if let sequenceData = readDelim(filePath: "sequence.index", delimiter: "\t") {
    print("Datos leídos correctamente:")
    for entry in sequenceData {
        print(entry)
    }
} else {
    print("Error al leer los datos.")
}


let rSession = R()

do {
    
    rSession["sequence_data"] = sequenceData
    
    
    let script = """
    summary(sequence_data)
    """
    let result = try rSession.execute(script)
    
    
    print("Resultado de R: \(result)")
} catch {
    print("Error ejecutando script de R: \(error)")
}
