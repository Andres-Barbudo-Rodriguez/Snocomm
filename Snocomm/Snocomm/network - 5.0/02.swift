import Foundation
import Network

func testSocketTimeout() {
    
    let host = NWEndpoint.Host("localhost")
    let port = NWEndpoint.Port(integerLiteral: 8080)
    let parameters = NWParameters.tcp
    
  
    let queue = DispatchQueue(label: "SocketQueue")
    let connection = NWConnection(host: host, port: port, using: parameters)
    
    
    let defaultTimeout = connection.parameters.defaultProtocolStack.internetProtocol!.ipOptions!.receivePacketTimeout
    print("Default socket timeout: \(defaultTimeout?.nanoseconds ?? 0)")
    
    
    let timeoutDuration = 100 * Double(NSEC_PER_SEC)
    connection.parameters.defaultProtocolStack.internetProtocol!.ipOptions!.receivePacketTimeout = timeoutDuration
    
    
    let currentTimeout = connection.parameters.defaultProtocolStack.internetProtocol!.ipOptions!.receivePacketTimeout
    print("Current socket timeout: \(currentTimeout?.nanoseconds ?? 0)")
    
    
    connection.start(queue: queue)
    
   
    sleep(1)
}

testSocketTimeout()
