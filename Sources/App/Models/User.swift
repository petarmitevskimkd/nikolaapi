//
//  User.swift
//  App
//
//  Created by Telekom MK on 2/26/19.
//

import Foundation
import Vapor
import FluentMySQL

final class User: Content, MySQLUUIDModel{
    
    var id: UUID?
    var firstName: String!
    var lastName: String?
    var mail: String?
    var pin: String!
    var fullName: String?
    var dateCreated: Date?
    
    init(id: UUID?, firstName: String!, lastName: String?, mail: String?, pin: String!, fullName: String?, dateCreated: Date?){
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.mail = mail
        self.pin = pin
        self.fullName = fullName
        self.dateCreated = dateCreated
    }
}

extension User: Migration{}
extension User: Parameter{}

struct UserLogin: Content {
    var mail: String?
    var pin: String!
}
extension User{
    var tokens: Children<User, Token>{
        return children(\.id)
    }
    
    var locations: Children<User, Locations>{
        return children(\.id)
    }
}
