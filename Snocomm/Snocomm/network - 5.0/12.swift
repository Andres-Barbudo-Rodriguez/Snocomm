import Foundation

let mensajeRecibido = UnsafeMutablePointer<CChar>.allocate(capacity: 255)
let mensajeParaElServidor = UnsafeMutablePointer<CChar>.allocate(capacity: 255)
let port: UInt16 = 2000
let ipAddress = "127.0.0.1"

print("Escriba el mensaje que desea enviarle al servidor: ", terminator: "")
guard let input = readLine(strippingNewline: true) else {
    print("Entrada vacía o no válida")
    exit(1)
}
strncpy(mensajeParaElServidor, input, 255)
mensajeParaElServidor[254] = 0

var direccionDelCliente = sockaddr_in()
bzero(&direccionDelCliente, MemoryLayout.size(ofValue: direccionDelCliente))
direccionDelCliente.sin_family = sa_family_t(AF_INET)
direccionDelCliente.sin_port = port.bigEndian
direccionDelCliente.sin_addr.s_addr = inet_addr(ipAddress)

let SocketDeUDP = socket(AF_INET, SOCK_DGRAM, 0)
if SocketDeUDP < 0 {
    perror("Ocurrió un error el socket no pudo crearse")
    exit(1)
}

if connect(SocketDeUDP, UnsafePointer<sockaddr>(&direccionDelCliente), socklen_t(MemoryLayout.size(ofValue: direccionDelCliente))) < 0 {
    print("\n Error: el intento de conexión falló \n")
    exit(1)
}

_ = mensajeParaElServidor.withMemoryRebound(to: UInt8.self, capacity: 255) {
    sendto(SocketDeUDP, $0, 255, 0, nil, 0)
}

print("Mensaje enviado al servidor.")

_ = mensajeRecibido.withMemoryRebound(to: UInt8.self, capacity: 255) {
    recvfrom(SocketDeUDP, $0, 255, 0, nil, nil)
}

print("Respuesta del Servidor: \(String(cString: mensajeRecibido))")
close(SocketDeUDP)
