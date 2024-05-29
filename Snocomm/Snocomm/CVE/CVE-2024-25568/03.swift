import UIKit
import DeviceCheck

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if DCDevice.current.isSupported {
            DCDevice.current.generateToken { (data, error) in
                if let error = error {
                    print("Error al generar el token: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("No se recibió ningún token")
                    return
                }
                
                
                let tokenString = data.base64EncodedString()
                print("Token generado: \(tokenString)")
                
                
                self.sendTokenToServer(tokenString)
            }
        } else {
            print("DeviceCheck no es compatible con este dispositivo")
        }
    }
    
    func sendTokenToServer(_ token: String) {
        // Implementa la lógica para enviar el token a tu servidor
        // Aquí puedes usar URLSession para hacer una solicitud POST
        let url = URL(string: "/.Snocomm/api/devicecheck")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["token": token]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error al enviar el token al servidor: \(error.localizedDescription)")
                return
            }
            
            print("Token enviado exitosamente")
        }
        
        task.resume()
    }
}
