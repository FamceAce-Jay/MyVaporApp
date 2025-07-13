import App
import Vapor
import Foundation

if let envURL = URL(string: FileManager.default.currentDirectoryPath + "/.env") {
    let envVars = try? String(contentsOf: envURL)
    envVars?
        .split(separator: "\n")
        .forEach { line in
            let parts = line.split(separator: "=", maxSplits: 1).map { String($0) }
            if parts.count == 2 {
                setenv(parts[0], parts[1], 1)
            }
        }
}

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }

try configure(app)
try app.run()
