import Foundation

let port: UInt16 = 2000
let ipAddress = "127.0.0.1"
let bufferSize = 255


let socketDelCliente = socket(AF_INET, SOCK_STREAM, 0)
if socketDelCliente == -1 {
    print("Error al crear el socket del cliente")
    exit(1)
}


var direccionDelCliente = sockaddr_in()
direccionDelCliente.sin_family = sa_family_t(AF_INET)
direccionDelCliente.sin_port = port.bigEndian
direccionDelCliente.sin_addr.s_addr = inet_addr(ipAddress)
direccionDelCliente.sin_zero = (0, 0, 0, 0, 0, 0, 0, 0)


let tamañoDeLaDireccion = socklen_t(MemoryLayout<sockaddr_in>.size)
let connectResult = withUnsafePointer(to: &direccionDelCliente) {
    $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { connect(socketDelCliente, $0, tamañoDeLaDireccion) }
}
if connectResult == -1 {
    print("Error al conectar al servidor")
    close(socketDelCliente)
    exit(1)
}


var str = [CChar](repeating: 0, count: bufferSize)
let bytesReceived = recv(socketDelCliente, &str, bufferSize, 0)
if bytesReceived == -1 {
    print("Error al recibir datos del servidor")
} else {
    print("Datos recibidos del servidor:", String(cString: str))
}


close(socketDelCliente)
