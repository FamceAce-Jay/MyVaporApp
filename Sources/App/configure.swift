import Vapor
import Fluent
import FluentMySQLDriver
import FluentPostgresDriver
import NIOSSL
import DotEnv

public func configure(_ app: Application) throws {
    // ✅ 加载 .env 文件
    let dotenv = DotEnv(withFile: ".env")

    // ✅ 获取数据库驱动
    let databaseDriver = dotenv.get("DATABASE_DRIVER") ?? "postgres"

    if databaseDriver == "mysql" {
        // ✅ 读取 MySQL 配置
        let hostname = dotenv.get("DATABASE_HOST") ?? "localhost"
        let port = Int(dotenv.get("DATABASE_PORT") ?? "") ?? 3306
        let username = dotenv.get("DATABASE_USERNAME") ?? "root"
        let password = dotenv.get("DATABASE_PASSWORD") ?? ""
        let database = dotenv.get("DATABASE_NAME") ?? "my_database"

        // ✅ 加载 TLS 证书
        let caCertPath = "/Users/Jay/mysql-certs/ca.pem"
        let caCert = try NIOSSLCertificate.fromPEMFile(caCertPath)
        let tlsConfig = TLSConfiguration.forClient(
            certificateVerification: .noHostnameVerification,
            trustRoots: .certificates(caCert)
        )

        print("🛠 使用 MySQL 数据库")
        print("📍 Host: \(hostname)")
        print("👤 User: \(username)")
        print("🔐 Password: \(password.isEmpty ? "(空)" : "******")")
        print("📚 DB Name: \(database)")

        app.databases.use(.mysql(
            hostname: hostname,
            port: port,
            username: username,
            password: password,
            database: database,
            tlsConfiguration: tlsConfig
        ), as: .mysql)

    } else if databaseDriver == "postgres" {
        // ✅ 读取 PostgreSQL 配置
        let hostname = dotenv.get("DATABASE_HOST") ?? "localhost"
        let port = Int(dotenv.get("DATABASE_PORT") ?? "") ?? 5432
        let username = dotenv.get("DATABASE_USERNAME") ?? "postgres"
        let password = dotenv.get("DATABASE_PASSWORD") ?? ""
        let database = dotenv.get("DATABASE_NAME") ?? "postgres"

        print("🛠 使用 PostgreSQL 数据库")
        print("📍 Host: \(hostname)")
        print("👤 User: \(username)")
        print("🔐 Password: \(password.isEmpty ? "(空)" : "******")")
        print("📚 DB Name: \(database)")

        app.databases.use(.postgres(
            hostname: hostname,
            port: port,
            username: username,
            password: password,
            database: database
        ), as: .psql)

    } else {
        fatalError("❌ 不支持的数据库驱动: \(databaseDriver)。请在 .env 中设置 DATABASE_DRIVER 为 mysql 或 postgres")
    }

    // ✅ 添加迁移（你可以在这里添加更多模型）
    app.migrations.add(CreateUser())

    // ✅ 注册路由
    try routes(app)
}

