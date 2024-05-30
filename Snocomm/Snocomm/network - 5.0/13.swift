import Foundation

var mensajeRecibido = [CChar](repeating: 0, count: 255)
var mensajeParaElCliente = [CChar](repeating: 0, count: 255)
var SocketDeUDP: Int32 = 0
var tamaño: socklen_t = 0

var direccionDelServidor = sockaddr_in()
var direccionDelCliente = sockaddr_in()

bzero(&direccionDelServidor, MemoryLayout.size(ofValue: direccionDelServidor))
print("Esperando el mensaje del cliente")
SocketDeUDP = socket(AF_INET, SOCK_DGRAM, 0)
if SocketDeUDP < 0 {
    perror("Ocurrió un error no se puede crear el socket")
    exit(1)
}

direccionDelServidor.sin_addr.s_addr = htonl(INADDR_ANY)
direccionDelServidor.sin_port = htons(2000)
direccionDelServidor.sin_family = sa_family_t(AF_INET)

if bind(SocketDeUDP, UnsafePointer<sockaddr>(&direccionDelServidor), socklen_t(MemoryLayout.size(ofValue: direccionDelServidor))) < 0 {
    perror("Error la conexión no se pudo establecer")
    exit(1)
}

tamaño = socklen_t(MemoryLayout.size(ofValue: direccionDelCliente))
let n = recvfrom(SocketDeUDP, &mensajeRecibido, 255, 0, UnsafeMutablePointer<sockaddr>(&direccionDelCliente), &tamaño)
mensajeRecibido[Int(n)] = 0
print("Mensaje recibido desde el cliente: \(String(cString: mensajeRecibido))")

print("Escriba la respuesta que desea enviar al cliente: ", terminator: "")
guard let input = readLine(strippingNewline: true) else {
    print("Entrada vacía o no válida")
    exit(1)
}
strncpy(&mensajeParaElCliente, input, 255)

_ = mensajeParaElCliente.withUnsafeBytes {
    sendto(SocketDeUDP, $0.baseAddress, 255, 0, UnsafePointer<sockaddr>(&direccionDelCliente), socklen_t(MemoryLayout.size(ofValue: direccionDelCliente)))
}

print("Respuesta enviada al cliente")
