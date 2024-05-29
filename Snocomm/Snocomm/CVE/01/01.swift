import Foundation

class AuthService {
    let baseURL = URL(string: "/.Snocomm/api")!
    
    func authenticate(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = baseURL.appendingPathComponent("authenticate")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body: [String: Any] = [
            "username": username,
            "password": password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -1, userInfo: nil)))
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let token = json["token"] as? String {
                completion(.success(token))
            } else {
                completion(.failure(NSError(domain: "InvalidResponse", code: -1, userInfo: nil)))
            }
        }
        
        task.resume()
    }
}
