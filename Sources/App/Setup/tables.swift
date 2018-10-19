//
//  tables.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/19.
//

import Foundation
import FluentMySQL

public let mysqlHostname = "47.106.231.100"//"127.0.0.1"
public let mysqlPort = 3306
public let mysqlUsername = "root"
public let mysqlPassword = "root"
public let mysqlDatabase = "vapor_test"

final class SQLConfig {


    func config() -> DatabasesConfig {
        
        var databases = DatabasesConfig()
        let mysql = MySQLDatabase(config: MySQLDatabaseConfig(hostname: mysqlHostname, port: mysqlPort, username: mysqlUsername, password: mysqlPassword, database: mysqlDatabase, characterSet: .utf8_general_ci, transport: .cleartext))
        
        databases.add(database: mysql, as: .mysql)
        databases.enableLogging(on: .mysql)
        
        return databases
    }
    
    
}


public func setupSQL(_ env: Environment, _ services: inout Services) {
    let sqlconfig = SQLConfig()
    if env.isRelease {
        print("start mysql release")
    } else {
        print("start mysql debug")
        
    }
    let databases = sqlconfig.config()
    services.register(databases)
}

public func registerFlunet(_ services: inout Services) {
    
    let migrations = registerTable()
    services.register(migrations)
}


fileprivate func registerTable() -> MigrationConfig {
    /// Configure migrations
    var migrations = MigrationConfig()
 
    migrations.add(model: AccessToken.self, database: .mysql)
    migrations.add(model: RefreshToken.self, database: .mysql)
    migrations.add(model: User.self, database: .mysql)
    
    return migrations
}
