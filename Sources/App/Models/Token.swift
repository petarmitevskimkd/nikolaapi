//
//  Token.swift
//  App
//
//  Created by Telekom MK on 2/27/19.
//

import Foundation
import Vapor
import FluentMySQL

final class Token: Content, MySQLUUIDModel{
    
    var id: UUID?
    var token: String?
    var createDate: Date?
    var expireDate: Date?
    var userId: User.ID
    
    
    init(id: UUID?, token: String?, createDate: Date?, expireDate: Date?, userId: User.ID) {
        self.id = id
        self.token = token
        self.createDate = createDate
        self.expireDate = expireDate
        self.userId = userId
    }
    
    final class Public: Codable{
        var token: String!
        init(token: String) {
            self.token = token
        }
        
    }
}
extension Token: Migration{
    static func prepare(on connection: MySQLConnection) -> Future<Void>{
        return Database.create(self, on: connection){builder in
            try addProperties(to: builder)
            builder.unique(on: \.token)
            builder.reference(from: \.userId, to: \User.id)
        }
    }
}


extension Token{
    var user: Parent<Token, User>{
        return parent(\.userId)
    }
}


extension Token: Parameter{}
extension Token.Public: Content {}

extension Token {
    // 1
    func convertToPublic() -> Token.Public {
        // 2
        return Token.Public(token: token!)
    }
}
extension Future where T: Token {
    // 2
    func convertToPublic() -> Future<Token.Public> {
        // 3
        return self.map(to: Token.Public.self) { token in
            // 4
            return token.convertToPublic()
        }
    } }
