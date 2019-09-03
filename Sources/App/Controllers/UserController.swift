//
//  UserController.swift
//  App
//
//  Created by Telekom MK on 2/26/19.
//

import Foundation
import Vapor
import Fluent
import Crypto

final class UserController{
    func saveUser(_ req: Request) throws -> Future<User>{
        if req.http.headers.contains(name: HTTPHeaderName.init("ath")){
            if req.http.headers.firstValue(name: HTTPHeaderName.init("ath")) != "ath"{
                throw Abort(.unauthorized, reason: "10002")
            }
        }else{
            throw Abort(.unauthorized, reason: "10001")
        }
        return try req.content.decode(User.self).flatMap(to: User.self){ user in
            
            User.query(on: req).filter(\.mail == user.mail).all().flatMap(to: User.self){users in
                
                if users.count > 0{
                    throw Abort(.badRequest, reason: "a user with this mail already exists" , identifier: nil)
                }else{
                    let hashPin = try BCrypt.hash(user.pin)
                    let fullName = "\(user.firstName!) \(user.lastName!)"
                    let saveUser = User(id: user.id, firstName: user.firstName, lastName: user.lastName, mail: user.mail, pin: hashPin, fullName: fullName, dateCreated: Date())
                    return saveUser.save(on: req)
                }
            }
        }
    }
    
    
    func login(_ req: Request) throws -> Future<Token.Public>{
        
        if req.http.headers.contains(name: HTTPHeaderName.init("ath")){
            if req.http.headers.firstValue(name: HTTPHeaderName.init("ath")) != "ath"{
                throw Abort(.unauthorized, reason: "10002")
            }
        }else{
            throw Abort(.unauthorized, reason: "10001")
        }
        let tokenToken = self.randomString(length: 64)
       return try req.content.decode(User.self).flatMap(to: User.self){ userlogin in
            
           return User.query(on: req).filter(\.mail == userlogin.mail).all().map(to: User.self){ users in
                
                if users.count == 0{
                    throw Abort(.badRequest, reason:"ne postoi toj user")
                }else{
                    let user = users.first!
                    let hashPin = user.pin!
                    let verification = try BCrypt.verify(userlogin.pin, created: hashPin)
                    if !verification{
                        throw Abort(.unauthorized, reason: "greshen pin")
                    }else{
                        let token = Token.init(id: UUID.init(), token: tokenToken, createDate: Date(), expireDate: Calendar.current.date(byAdding: .minute, value: 60, to: Date())!, userId: user.id!)
                        print(token.create(on: req))
                        return userlogin

                        }
                    }
                }
 
            }.transform(to: Token.Public.init(token: tokenToken))
        
            }
    
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+=!?-*%$#"
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }
        
}

