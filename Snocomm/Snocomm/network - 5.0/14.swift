import Foundation

let host = "localhost"
let dataPayload = 2048
let backlog = 5

func echoServer(port: Int) {
    var socketDeTCP = Socket(socketDomain: .inet, type: .stream, protocol: .tcp)
    guard let socket = socketDeTCP else {
        print("Error al crear el socket de TCP")
        return
    }

    do {
        try socket.setOption(level: .socket, name: .reuseAddress, value: true)
        let direccionDelServidor = SocketAddress(host: host, port: port)
        print("Inicializando el Servidor Echo en \(host) puerto \(port)")
        try socket.bind(to: direccionDelServidor)
        try socket.listen(backlog: backlog)
        
        while true {
            print("Esperando a recibir el mensaje del cliente")
            let (cliente, direccion) = try socket.accept()
            guard let datos = try cliente.read(maxBytes: dataPayload) else {
                cliente.close()
                continue
            }

            print("Datos: \(datos)")
            try cliente.write(datos)
            print("Enviados \(datos.count) bytes de regreso a \(direccion)")
            
            
            cliente.close()
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

echoServer(port: port)
