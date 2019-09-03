//
//  Locations.swift
//  App
//
//  Created by Telekom MK on 2/26/19.
//

import Foundation
import Vapor
import FluentMySQL

final class Locations: Content, MySQLUUIDModel{
    
    var id: UUID?
    var longitude: Double?
    var latitude: Double?
    var imageBeforeUrl: String?
    var imageAfterUrl: String?
    var state: Bool?
    var dateCreated: Date?
    var userId: User.ID!
    
    init(id: UUID?, longitude: Double?, latitude: Double?, imageBeforeUrl: String?, imageAfterUrl: String?, state: Bool?, dateCreated: Date?, userId: User.ID!) {
        self.id = id
        self.longitude = longitude
        self.latitude = latitude
        self.imageBeforeUrl = imageBeforeUrl
        self.imageAfterUrl = imageAfterUrl
        self.state = state
        self.dateCreated = dateCreated
        self.userId = userId
    }

}
extension Locations: Parameter{}
extension Locations{
    
    var user: Parent<Locations, User>{
        return parent(\.userId)
    }
}
extension Locations: Migration{
    static func prepare(on connection: MySQLConnection) -> Future<Void>{
        return Database.create(self, on: connection){builder in
            try addProperties(to: builder)
            builder.reference(from: \.userId, to: \User.id)
        }
    }
}
