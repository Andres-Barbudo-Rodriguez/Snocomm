import Foundation
import Darwin

func reutilizarLaDireccionDeSocket() {
    
    let sock = socket(AF_INET, SOCK_STREAM, 0)
    if sock == -1 {
        print("Error creando el socket")
        return
    }
    
    
    var estadoAnterior: Int32 = 0
    var len = socklen_t(MemoryLayout<Int32>.size)
    if getsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &estadoAnterior, &len) == -1 {
        print("Error obteniendo el estado del socket: \(errno)")
        close(sock)
        return
    }
    print("El estado anterior del socket es: \(estadoAnterior)")
    
    
    var reuseAddr: Int32 = 1
    if setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &reuseAddr, socklen_t(MemoryLayout<Int32>.size)) == -1 {
        print("Error habilitando SO_REUSEADDR: \(errno)")
        close(sock)
        return
    }
    
    
    var estadoActual: Int32 = 0
    if getsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &estadoActual, &len) == -1 {
        print("Error obteniendo el estado actual del socket: \(errno)")
        close(sock)
        return
    }
    print("Estado actual del socket: \(estadoActual)")
    
    
    let puertoLocal: UInt16 = 8282
    let srv = socket(AF_INET, SOCK_STREAM, 0)
    if srv == -1 {
        print("Error creando el socket del servidor")
        close(sock)
        return
    }
    
    if setsockopt(srv, SOL_SOCKET, SO_REUSEADDR, &reuseAddr, socklen_t(MemoryLayout<Int32>.size)) == -1 {
        print("Error habilitando SO_REUSEADDR en el servidor: \(errno)")
        close(srv)
        close(sock)
        return
    }
    
    var addr = sockaddr_in()
    addr.sin_family = sa_family_t(AF_INET)
    addr.sin_port = in_port_t(puertoLocal.bigEndian)
    addr.sin_addr = in_addr(s_addr: inet_addr("0.0.0.0"))
    
    let bindResult = withUnsafePointer(to: &addr) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            bind(srv, $0, socklen_t(MemoryLayout<sockaddr_in>.size))
        }
    }
    
    if bindResult == -1 {
        print("Error enlazando el socket del servidor: \(errno)")
        close(srv)
        close(sock)
        return
    }
    
    if listen(srv, 1) == -1 {
        print("Error estableciendo la escucha en el socket del servidor: \(errno)")
        close(srv)
        close(sock)
        return
    }
    print("Escucha activa en el puerto: \(puertoLocal)")
    
    
    while true {
        var clientAddr = sockaddr_in()
        var clientLen = socklen_t(MemoryLayout<sockaddr_in>.size)
        let clientSocket = withUnsafeMutablePointer(to: &clientAddr) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                accept(srv, $0, &clientLen)
            }
        }
        
        if clientSocket == -1 {
            if errno == EINTR {
                break 
            }
            print("Error aceptando la conexión: \(errno)")
            continue
        }
        
        let clientIP = String(cString: inet_ntoa(clientAddr.sin_addr))
        let clientPort = Int(clientAddr.sin_port).bigEndian
        print("Conectado por \(clientIP):\(clientPort)")
        
        
        close(clientSocket)
    }
    
    
    close(srv)
    close(sock)
}

reutilizarLaDireccionDeSocket()
