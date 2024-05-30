import Foundation

let host = "localhost"
let dataPayload = 2048

func clienteEcho(port: Int) {
    do {
        let socketDeUDP = try Socket(socketDomain: .inet, type: .datagram, protocol: .udp)
        let direccionDelServidor = SocketAddress(host: host, port: port)
        print("Conectando con \(host) en el puerto \(port)")
        let mensaje = "Este mensaje será replica"
        
        
        print("Enviando \(mensaje)")
        try socketDeUDP.write(from: mensaje, to: direccionDelServidor)
        
        
        var buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: dataPayload)
        defer { buffer.deallocate() }
        let (bytesRecibidos, _) = try socketDeUDP.readDatagram(into: buffer, bufSize: dataPayload)
        let datos = Data(bytes: buffer, count: bytesRecibidos)
        print("Recibido \(datos)")
        
        
        socketDeUDP.close()
    } catch let error as SocketError {
        print("Error de socket: \(error)")
    } catch {
        print("Error: \(error)")
    }
}

guard CommandLine.arguments.count == 3, CommandLine.arguments[1] == "--port", let port = Int(CommandLine.arguments[2]) else {
    print("Uso: \(CommandLine.arguments[0]) --port [puerto]")
    exit(1)
}

clienteEcho(port: port)
