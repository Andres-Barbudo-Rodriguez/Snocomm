import Foundation

// Función para buscar patrones sospechosos en el archivo de registro
func detectIntrusion() {
    let logFilePath = "/var/log/system.log" // Ruta del archivo de registro del sistema
    
    do {
        let logFileContents = try String(contentsOfFile: logFilePath)
        
        // Verificar si hay un acceso de root no autorizado en el archivo de registro
        if logFileContents.contains("su: ROOT USER ") {
            print("Se ha detectado un acceso de root no autorizado en el archivo de registro del sistema.")
            // Aquí puedes agregar cualquier acción que desees realizar cuando se detecte una intrusión
            // Por ejemplo, puedes enviar una notificación por correo electrónico, registrar un mensaje, etc.
        } else {
            print("No se han detectado intrusiones.")
        }
    } catch {
        print("Error al leer el archivo de registro del sistema: \(error)")
    }
}

// Llama a la función para detectar intrusiones
detectIntrusion()

