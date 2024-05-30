import Foundation
import Network

let SEND_BUF_SIZE = 4096
let RECV_BUF_SIZE = 4096

func modifyBuffSize() {
    
    let socketFD = socket(AF_INET, SOCK_STREAM, 0)
    if socketFD == -1 {
        print("Error creando el socket")
        return
    }
    
    
    var bufSize: Int32 = 0
    var len = socklen_t(MemoryLayout<Int32>.size)
    if getsockopt(socketFD, SOL_SOCKET, SO_SNDBUF, &bufSize, &len) == -1 {
        print("Error obteniendo el tamaño del buffer: \(errno)")
        close(socketFD)
        return
    }
    print("Tamaño del buffer [Antes]: \(bufSize)")
    
    
    var flag: Int32 = 1
    if setsockopt(socketFD, IPPROTO_TCP, TCP_NODELAY, &flag, socklen_t(MemoryLayout<Int32>.size)) == -1 {
        print("Error estableciendo TCP_NODELAY: \(errno)")
        close(socketFD)
        return
    }
    
    var sendBufSize = SEND_BUF_SIZE
    if setsockopt(socketFD, SOL_SOCKET, SO_SNDBUF, &sendBufSize, socklen_t(MemoryLayout<Int32>.size)) == -1 {
        print("Error estableciendo el tamaño del buffer de envío: \(errno)")
        close(socketFD)
        return
    }
    
    var recvBufSize = RECV_BUF_SIZE
    if setsockopt(socketFD, SOL_SOCKET, SO_RCVBUF, &recvBufSize, socklen_t(MemoryLayout<Int32>.size)) == -1 {
        print("Error estableciendo el tamaño del buffer de recepción: \(errno)")
        close(socketFD)
        return
    }
    
    
    if getsockopt(socketFD, SOL_SOCKET, SO_SNDBUF, &bufSize, &len) == -1 {
        print("Error obteniendo el tamaño del buffer: \(errno)")
        close(socketFD)
        return
    }
    print("Tamaño del buffer [Después]: \(bufSize)")
    
    
    close(socketFD)
}

modifyBuffSize()
