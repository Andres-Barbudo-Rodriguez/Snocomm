import Vapor

struct User: Content {
    var name: String
    var email: String
    var age: Int
}
