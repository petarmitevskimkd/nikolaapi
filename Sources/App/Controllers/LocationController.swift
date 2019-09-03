//
//  LocationController.swift
//  App
//
//  Created by Telekom MK on 2/26/19.
//

import Foundation
import Vapor
import Fluent
final class LocationController{
    
    func uploadLocation(_ req: Request) throws -> Future<Locations>{
        var token: String!
        if req.http.headers.contains(name: HTTPHeaderName.init("Authentication")){
            token = req.http.headers.firstValue(name: HTTPHeaderName.init("Authentication"))
        }else{
            throw Abort(.unauthorized, reason: "10001")
        }
        return try req.content.decode(Locations.self).flatMap(to: Locations.self){ location in
            
             return User.query(on: req).filter(\.id == location.userId).first().flatMap(to: Locations.self){ user in

                return try TokenController.validateToken(user, token, req).flatMap(to: Locations.self){ validation in
                    
                    if validation{
                        let locationUpload = location
                        locationUpload.dateCreated = Date()
                        locationUpload.imageAfterUrl = nil
                        return locationUpload.save(on: req)
                    }else{
                        throw Abort(.unauthorized)
                    }
                }

            }

        }
    }
    
    func returnLocations(_ req: Request) throws -> Future<[Locations]>{
        var page = 0
        var limit = 5
        if req.query[Int.self, at: "page"] != nil{
            page = req.query[Int.self, at: "page"]!
        }
        if req.query[Int.self, at: "limit"] != nil {
            limit = req.query[Int.self, at: "limit"]!
        }
        let startPoint = limit*page
        let endPoint = startPoint+limit
        return Locations.query(on: req).range(startPoint..<endPoint).all().map(to: [Locations].self) {locations in
            return locations
        }
    }
    
    
    
    func uploadCleanLocation(_ req: Request) throws -> Future<Locations>{
         var token: String!
        if req.http.headers.contains(name: HTTPHeaderName.init("Authentication")){
             token = req.http.headers.firstValue(name: HTTPHeaderName.init("Authentication"))
        }else{
            throw Abort(.unauthorized, reason: "10001")
        }
        return try req.content.decode(Locations.self).flatMap(to: Locations.self){ locationRequest in
            
            return User.query(on: req).filter(\.id == locationRequest.userId).first().flatMap(to: Locations.self){ user in
                
                return try TokenController.validateToken(user!, token, req).flatMap(to: Locations.self){ validation in
                    
                    
                    return Locations.query(on: req).filter(\.id == locationRequest.id).first().flatMap(to: Locations.self){ location in
                        if validation{
                            let locationUpload = locationRequest
                            locationUpload.state = true
                            locationUpload.imageBeforeUrl = location?.imageBeforeUrl
                            locationUpload.latitude = location?.latitude
                            locationUpload.longitude = location?.longitude
                            locationUpload.dateCreated = location?.dateCreated
                            return locationUpload.update(on: req, originalID: locationUpload.id)
                        }else{
                            throw Abort(.unauthorized)
                        }
                    }
                    
                }
            }
        }
    }
}
