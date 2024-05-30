import Foundation
import Network

func main() {
    
    let arguments = CommandLine.arguments
    var host: String?
    var port: Int?
    var filename: String?

    
    for i in 0..<arguments.count {
        switch arguments[i] {
        case "--host":
            host = arguments[i + 1]
        case "--port":
            if let portString = arguments[i + 1] as String?, let portInt = Int(portString) {
                port = portInt
            }
        case "--file":
            filename = arguments[i + 1]
        default:
            break
        }
    }
    
    guard let host = host, let port = port, let filename = filename else {
        print("Usage: --host <host> --port <port> --file <file>")
        exit(1)
    }
    
    
    var connection: NWConnection?
    do {
        let hostEndpoint = NWEndpoint.Host(host)
        let portEndpoint = NWEndpoint.Port(rawValue: UInt16(port))!
        connection = NWConnection(host: hostEndpoint, port: portEndpoint, using: .tcp)
    } catch {
        print("Error creating socket: \(error)")
        exit(1)
    }
    
    
    connection?.stateUpdateHandler = { newState in
        switch newState {
        case .ready:
            print("Connected to \(host) on port \(port)")
        case .failed(let error):
            print("Connection error: \(error)")
            exit(1)
        default:
            break
        }
    }
    
    connection?.start(queue: .main)
    
    
    let msg = "GET \(filename) HTTP/1.0\r\n\r\n"
    connection?.send(content: msg.data(using: .utf8), completion: .contentProcessed({ sendError in
        if let sendError = sendError {
            print("Error sending data: \(sendError)")
            exit(1)
        }
    }))
    
    
    connection?.receive(minimumIncompleteLength: 1, maximumLength: 2048, completion: { (data, _, isComplete, receiveError) in
        if let receiveError = receiveError {
            print("Error receiving data: \(receiveError)")
            exit(1)
        }
        
        if let data = data, let response = String(data: data, encoding: .utf8) {
            print(response)
        }
        
        if isComplete {
            exit(0)
        }
    })
    
    dispatchMain()
}

main()
