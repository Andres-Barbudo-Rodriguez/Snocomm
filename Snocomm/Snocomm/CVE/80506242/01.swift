import Foundation

func ejecutarAwk(comando: String, argumentos: [String]) {
    let proceso = Process()
    proceso.launchPath = "/bin/bash"
    proceso.arguments = ["-c", "if [[ $(id -u) -eq 0 ]]; then \(comando) \(argumentos.joined(separator: " ")); else echo 'Acceso denegado'; fi"]
    
    let salida = Pipe()
    proceso.standardOutput = salida
    proceso.launch()
    
    let datos = salida.fileHandleForReading.readDataToEndOfFile()
    if let resultado = String(data: datos, encoding: .utf8) {
        print(resultado)
    }
}


ejecutarAwk(comando: "awk", argumentos: ["'{print $1}'", "archivo.txt"])
