func readLine(ruta: String) {
    
    guard let directorioRaiz = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("No se pudo obtener el directorio raíz de la aplicación")
        return
    }
    
    
    let urlCompleta = directorioRaiz.appendingPathComponent(ruta)
    
    
    guard urlCompleta.path.hasPrefix(directorioRaiz.path) else {
        print("La ruta de archivo no es válida")
        return
    }
    
    
    do {
        let contenido = try String(contentsOf: urlCompleta, encoding: .utf8)
        print(contenido)
    } catch {
        print("Error al leer el archivo: \(error)")
    }
}
