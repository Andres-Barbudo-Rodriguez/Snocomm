import Foundation

let fifoPath = "RedireccionDeIPC"
let bufferSize = 255


let fileManager = FileManager.default
if !fileManager.fileExists(atPath: fifoPath) {
    let result = mkfifo(fifoPath, 0o666)
    if result != 0 {
        perror("Error al crear FIFO")
        exit(1)
    }
}


guard let escritura = FileHandle(forWritingAtPath: fifoPath) else {
    print("Error al abrir FIFO para escritura")
    exit(1)
}


print("Enter text: ", terminator: "")
guard let input = readLine(), !input.isEmpty else {
    print("Entrada vacía o no válida")
    exit(1)
}


if let data = input.data(using: .utf8) {
    escritura.write(data)
} else {
    print("Error al convertir la entrada a datos")
}


escritura.closeFile()
