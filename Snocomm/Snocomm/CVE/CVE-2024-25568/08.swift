import Foundation

class NetworkManager {
    
    var isConnected: Bool = false
    
    
    func fetchData(completion: @escaping (Result<String, Error>) -> Void) {
    
        if isConnected {
    
            completion(.success("Datos recibidos correctamente"))
        } else {
    
            completion(.failure(NSError(domain: "No hay conexión de red", code: 0, userInfo: nil)))
        }
    }
}

class ReconnectionHandler {
    var networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(networkChanged), name: .networkStatusChanged, object: nil)
    }
    
    @objc func networkChanged() {
        
        if networkManager.isConnected {
            print("¡Conexión restaurada! Intentando de nuevo la solicitud de red...")
            networkManager.fetchData { result in
                switch result {
                case .success(let data):
                    print("Solicitud de red exitosa: \(data)")
                case .failure(let error):
                    print("Error en la solicitud de red: \(error.localizedDescription)")
                }
            }
        }
    }
}


extension Notification.Name {
    static let networkStatusChanged = Notification.Name("NetworkStatusChanged")
}


let networkManager = NetworkManager()
let reconnectionHandler = ReconnectionHandler(networkManager: networkManager)


networkManager.isConnected = true
NotificationCenter.default.post(name: .networkStatusChanged, object: nil)
