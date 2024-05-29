import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isAuthenticated = false
    @State private var authError: String?
    
    var authService = AuthService()
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            if let authError = authError {
                Text(authError)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button(action: authenticate) {
                Text("Login")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
            
            if isAuthenticated {
                Text("User is authenticated!")
                    .foregroundColor(.green)
                    .padding()
            }
        }
        .padding()
    }
    
    func authenticate() {
        authService.authenticate(username: username, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    print("Authenticated with token: \(token)")
                    isAuthenticated = true
                    authError = nil
                    // Aquí puedes guardar el token y permitir que el usuario envíe tráfico a la red

                case .failure(let error):
                    print("Failed to authenticate: \(error)")
                    authError = "Failed to authenticate. Please check your credentials."
                    isAuthenticated = false
                }
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        LoginView()
    }
}

@main
struct Snocomm: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
