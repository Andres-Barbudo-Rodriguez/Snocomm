import Foundation

let host = "localhost"
let dataPayload = 2048

func servidorEcho(port: Int) {
    do {
        var socketDeUDP = try Socket(socketDomain: .inet, type: .datagram, protocol: .udp)
        let direccionDelServidor = SocketAddress(host: host, port: port)
        print("Inicializando el servidor echo en \(host) puerto \(port)")
        try socketDeUDP.bind(to: direccionDelServidor)
        
        while true {
            print("Esperando a recibir el mensaje desde el cliente")
            var buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: dataPayload)
            defer { buffer.deallocate() }
            let (bytesRecibidos, direccion) = try socketDeUDP.readDatagram(into: buffer, bufSize: dataPayload)
            print("Recibidos \(bytesRecibidos) bytes desde \(direccion)")
            let datos = Data(bytes: buffer, count: bytesRecibidos)
            print("Datos: \(datos)")
            
            let bytesEnviados = try socketDeUDP.write(from: datos, to: direccion)
            print("Enviados \(bytesEnviados) bytes de vuelta a \(direccion)")
        }
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

servidorEcho(port: port)
