import FluentMySQL
import Vapor
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
    ) throws {
    try services.register(FluentMySQLProvider())
    let router = EngineRouter.default()
    try routes(router)
    let serverConfigure = NIOServerConfig.default(hostname: "127.0.0.1", port: 8080)
    services.register(serverConfigure)
    services.register(router, as: Router.self)
    var middlewares = MiddlewareConfig()
    middlewares.use(ErrorMiddleware.self)
    services.register(middlewares)
    var databases = DatabasesConfig()
    
    let databaseConfig = MySQLDatabaseConfig(
        hostname: "db4free.net",
        username: "nikola123",
        password: "password123",
        database: "vapornikola")
    
    let database = MySQLDatabase(config: databaseConfig)
    databases.add(database: database, as: .mysql)
    services.register(databases)
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .mysql)
    migrations.add(model: Locations.self, database: .mysql)
    migrations.add(model: Token.self, database: .mysql)
    services.register(migrations)
    
}
