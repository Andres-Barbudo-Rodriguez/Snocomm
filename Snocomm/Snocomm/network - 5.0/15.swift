import Foundation

let host = "localhost"

func clienteEcho(port: Int) {
    var socketDeTCP = Socket(socketDomain: .inet, type: .stream, protocol: .tcp)
    guard let socket = socketDeTCP else {
        print("Error al crear el socket de TCP/IP")
        return
    }

    do {
        let direccionDelServidor = SocketAddress(host: host, port: port)
        print("Conectando con \(host) en el puerto \(port)")
        try socket.connect(to: direccionDelServidor)
        
        let mensaje = "mensaje de prueba echo"
        print("Enviando \(mensaje)")
        try socket.write(from: mensaje)
        
        var cantidadRecibida = 0
        let cantidadEsperada = mensaje.utf8.count
        var buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: cantidadEsperada)
        defer { buffer.deallocate() }
        
        while cantidadRecibida < cantidadEsperada {
            let bytesRecibidos = try socket.read(into: buffer.advanced(by: cantidadRecibida), bufSize: cantidadEsperada - cantidadRecibida)
            if bytesRecibidos == 0 {
                break
            }
            cantidadRecibida += bytesRecibidos
            let datos = Data(bytes: buffer, count: bytesRecibidos)
            print("Recibido: \(String(decoding: datos, as: UTF8.self))")
        }
    } catch let error as SocketError {
        print("Ocurrió un Error en el socket: \(error)")
    } catch {
        print("Ocurrió una excepción: \(error)")
    } finally {
        print("Cerrando conexión con el servidor")
        socket.close()
    }
}

guard CommandLine.arguments.count == 3, CommandLine.arguments[1] == "--port", let port = Int(CommandLine.arguments[2]) else {
    print("Uso: \(CommandLine.arguments[0]) --port [puerto]")
    exit(1)
}

clienteEcho(port: port)
