import Foundation

let bufferSize = 255
let port: UInt16 = 2000
let ipAddress = "127.0.0.1"


let socketDelServidor = socket(AF_INET, SOCK_STREAM, 0)
if socketDelServidor == -1 {
    print("Error al crear el socket del servidor")
    exit(1)
}


var direccionDelServidor = sockaddr_in()
direccionDelServidor.sin_family = sa_family_t(AF_INET)
direccionDelServidor.sin_port = port.bigEndian
direccionDelServidor.sin_addr.s_addr = inet_addr(ipAddress)
direccionDelServidor.sin_zero = (0, 0, 0, 0, 0, 0, 0, 0)


let bindResult = withUnsafePointer(to: &direccionDelServidor) {
    $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { bind(socketDelServidor, $0, socklen_t(MemoryLayout<sockaddr_in>.size)) }
}
if bindResult == -1 {
    print("Error al enlazar el socket")
    close(socketDelServidor)
    exit(1)
}


if listen(socketDelServidor, 5) == -1 {
    print("Escucha no disponible")
    close(socketDelServidor)
    exit(1)
}

print("Ingrese el texto que se enviará al cliente: ", terminator: "")
guard let input = readLine(), !input.isEmpty else {
    print("Entrada vacía o no válida")
    close(socketDelServidor)
    exit(1)
}


let envio = accept(socketDelServidor, nil, nil)
if envio == -1 {
    print("Error al aceptar la conexión entrante")
    close(socketDelServidor)
    exit(1)
}


input.withCString { ptr in
    let bytesSent = send(envio, ptr, Int(strlen(ptr)), 0)
    if bytesSent == -1 {
        print("Error al enviar datos al cliente")
    } else {
        print("Datos enviados al cliente")
    }
}


close(envio)
close(socketDelServidor)
