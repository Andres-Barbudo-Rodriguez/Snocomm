import SwiftUI

struct ContentView: View {
    @State private var command = ""
    @State private var host = ""
    @State private var output = ""
    @State private var error: Error?
    
    var body: some View {
        VStack {
            TextField("Comando", text: $command)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Host", text: $host)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: executeCommand) {
                Text("Ejecutar Comando")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
            
            if let error = error {
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                Text("Output: \(output)")
                    .foregroundColor(.green)
                    .padding()
            }
        }
        .padding()
    }
    
    func executeCommand() {
        let executor = RemoteCommandExecutor()
        executor.executeRemoteCommand(command, onHost: host) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let output):
                    self.output = output
                    self.error = nil
                case .failure(let error):
                    self.error = error
                    self.output = ""
                }
            }
        }
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
