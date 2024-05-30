import Vapor

func routes(_ app: Application) throws {
    app.post("user") { req -> HTTPStatus in
        
        do {
            let user = try req.content.decode(User.self)

            
            guard user.age > 0 else {
                throw Abort(.badRequest, reason: "La edad debe ser un número positivo.")
            }

            guard user.email.contains("@") else {
                throw Abort(.badRequest, reason: "El email no es válido.")
            }

            
            return .ok
        } catch {
            
            throw Abort(.badRequest, reason: "Solicitud mal formada: \(error.localizedDescription)")
        }
    }
}
