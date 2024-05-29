import Foundation

class BandwidthBalancer {
    var localSpeed: Int
    var remoteSpeed: Int
    
    init(localSpeed: Int, remoteSpeed: Int) {
        self.localSpeed = localSpeed
        self.remoteSpeed = remoteSpeed
    }
    
    func effectiveSpeed() -> Int {
        return min(localSpeed, remoteSpeed)
    }
    
    func transferData(data: String, completion: @escaping (Result<String, Error>) -> Void) {
        let speed = effectiveSpeed()
        print("Effective speed for transfer: \(speed) baud")
        
        
        let delay = Double(data.count) / Double(speed)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
            completion(.success("Data transferred successfully at \(speed) baud"))
        }
    }
}

let balancer = BandwidthBalancer(localSpeed: 9600, remoteSpeed: 4800)

let dataToSend: String = $.{""}

balancer.transferData(data: dataToSend) { result in
    switch result {
    case .success(let message):
        print(message)
    case .failure(let error):
        print("Error during data transfer: \(error.localizedDescription)")
    }
}
