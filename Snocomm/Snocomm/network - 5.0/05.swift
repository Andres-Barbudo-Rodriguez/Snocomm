import Foundation
import Network

func testSocketModes() {
    
    let socketFD = socket(AF_INET, SOCK_STREAM, 0)
    if socketFD == -1 {
        print("Error creando el socket")
        return
    }
    
    
    var flags = fcntl(socketFD, F_GETFL, 0)
    if flags == -1 {
        print("Error obteniendo flags del socket")
        close(socketFD)
        return
    }
    
    
    flags &= ~O_NONBLOCK
    if fcntl(socketFD, F_SETFL, flags) == -1 {
        print("Error estableciendo el modo bloqueado del socket")
        close(socketFD)
        return
    }
    
    
    var timeout = timeval(tv_sec: 0, tv_usec: 500000) // 0.5 segundos
    if setsockopt(socketFD, SOL_SOCKET, SO_RCVTIMEO, &timeout, socklen_t(MemoryLayout<timeval>.size)) == -1 {
        print("Error configurando el timeout de recepción del socket")
        close(socketFD)
        return
    }
    
    if setsockopt(socketFD, SOL_SOCKET, SO_SNDTIMEO, &timeout, socklen_t(MemoryLayout<timeval>.size)) == -1 {
        print("Error configurando el timeout de envío del socket")
        close(socketFD)
        return
    }
    
    
    var addr = sockaddr_in()
    addr.sin_family = sa_family_t(AF_INET)
    addr.sin_port = in_port_t(0)
    addr.sin_addr = in_addr(s_addr: inet_addr("127.0.0.1"))
    
    let bindResult = withUnsafePointer(to: &addr) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            bind(socketFD, $0, socklen_t(MemoryLayout<sockaddr_in>.size))
        }
    }
    
    if bindResult == -1 {
        print("Error enlazando el socket: \(errno)")
        close(socketFD)
        return
    }
    
    
    var addrLen = socklen_t(MemoryLayout<sockaddr_in>.size)
    if getsockname(socketFD, withUnsafeMutablePointer(to: &addr) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { $0 }
    }, &addrLen) == -1 {
        print("Error obteniendo el nombre del socket")
        close(socketFD)
        return
    }
    
    let ipString = String(cString: inet_ntoa(addr.sin_addr))
    let port = Int(addr.sin_port).bigEndian
    print("Servidor inicializado en el socket: \(ipString):\(port)")
    
    
    while true {
        if listen(socketFD, 1) == -1 {
            print("Error escuchando en el socket: \(errno)")
            close(socketFD)
            return
        }
    }
    
    
    close(socketFD)
}

testSocketModes()
