// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "MyVaporApp",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
        // Vapor 核心
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        // Fluent ORM
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        // Fluent MySQL 驱动
        .package(url: "https://github.com/vapor/fluent-mysql-driver.git", from: "4.0.0"),
        // Fluent PostgreSQL 驱动
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0"),
        // DotEnv 支持
        .package(url: "https://github.com/orlandos-nl/DotEnv.git", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentMySQLDriver", package: "fluent-mysql-driver"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "DotEnv", package: "DotEnv")
            ],
            path: "Sources/App"
        ),
        .executableTarget(
            name: "Run",
            dependencies: [
                .target(name: "App")
            ],
            path: "Sources/Run"
        ),
        .testTarget(
            name: "AppTests",
            dependencies: [
                .target(name: "App"),
                .product(name: "XCTVapor", package: "vapor"),
            ],
            path: "Tests/AppTests"
        ),
    ]
)
