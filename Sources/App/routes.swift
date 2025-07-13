import Vapor

func routes(_ app: Application) throws {
    app.post("register") { req async throws -> User in
        let user = try req.content.decode(User.self)
        try await user.save(on: req.db)
        return user
    }
}
