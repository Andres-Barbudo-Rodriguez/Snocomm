import Foundation

let fifoPath = "RedireccionDeIPC"
let bufferSize = 255


guard let lectura = FileHandle(forReadingAtPath: fifoPath) else {
    print("Error al abrir FIFO para lectura")
    exit(1)
}


let data = lectura.readData(ofLength: bufferSize)


if let str = String(data: data, encoding: .utf8) {
    print("Lectura del operador de redirección FIFO: \(str)")
} else {
    print("Error al convertir datos leídos a cadena")
}


lectura.closeFile()
