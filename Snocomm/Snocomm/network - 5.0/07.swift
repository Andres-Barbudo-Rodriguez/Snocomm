import Foundation
import Network

let SERVIDOR_NTP = "0.uk.pool.ntp.org"
let EPOCH: TimeInterval = 2208988800

func clienteSNTP() {
    let socket = NWConnection(host: NWEndpoint.Host(SERVIDOR_NTP), port: 123, using: .udp)
    
    socket.stateUpdateHandler = { state in
        switch state {
        case .ready:
            let datos = Data([0x1b] + Array(repeating: 0, count: 47))
            socket.send(content: datos, completion: .contentProcessed({ error in
                if let error = error {
                    print("Error al enviar datos: \(error)")
                } else {
                    print("Datos enviados")
                    socket.receive(minimumIncompleteLength: 48, maximumLength: 48) { (data, context, isComplete, error) in
                        if let error = error {
                            print("Error al recibir datos: \(error)")
                            return
                        }
                        guard let data = data else {
                            print("No se recibieron datos")
                            return
                        }
                        print("Respuesta recibida")
                        var timeData = data.subdata(in: 40..<44)
                        var timeInt: UInt32 = 0
                        timeData.withUnsafeBytes {
                            timeInt = $0.load(as: UInt32.self)
                        }
                        timeInt = UInt32(bigEndian: timeInt)
                        let tiempo = TimeInterval(timeInt) - EPOCH
                        print("\tTiempo = \(Date(timeIntervalSince1970: tiempo))")
                        socket.cancel()
                    }
                }
            }))
        case .failed(let error):
            print("Conexión fallida: \(error)")
            socket.cancel()
        default:
            break
        }
    }
    
    socket.start(queue: .global())
}

clienteSNTP()
