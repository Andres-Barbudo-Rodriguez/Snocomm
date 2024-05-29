import Foundation

class RemoteCommandExecutor {
    
    func executeRemoteCommand(_ command: String, onHost host: String, completion: @escaping (Result<String, Error>) -> Void) {
        let uuxCommand = "uux \(host)!\"\(command)\""
        let process = Process()
        process.launchPath = "/bin/zsh"
        process.arguments = ["-c", uuxCommand]
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        process.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""
        process.waitUntilExit()
        if process.terminationStatus == 0 {
            completion(.success(output))
        } else {
            let error = NSError(domain: "RemoteCommandExecutor", code: Int(process.terminationStatus), userInfo: [NSLocalizedDescriptionKey: output])
            completion(.failure(error))
        }
    }
}
