import Foundation
import Network

class NetworkMonitor {
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue.global(qos: .background)
    
    var isConnected: Bool {
        return monitor.currentPath.status == .satisfied
    }
    
    var connectionUpdateHandler: ((Bool) -> Void)?
    
    init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.connectionUpdateHandler?(path.status == .satisfied)
            if path.status == .satisfied {
                print("Conectado a la red")
            } else {
                print("No hay conexión a la red")
            }
        }
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
}
