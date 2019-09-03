//
//  TokenController.swift
//  App
//
//  Created by Telekom MK on 3/4/19.
//

import Foundation
import Vapor
import Fluent

final class TokenController{
    
    class func validateToken(_ forUser: User!, _ token: String!, _ req: Request) throws -> Future<Bool>{
        print(token)
        print("uuid string: \(forUser.id?.uuidString)")
        return Token.query(on: req).filter(\.token == token).first().map(to: Bool.self){ tokenObject in
            if tokenObject == nil{
                return false
            }else{
                if tokenObject?.userId == forUser.id{
                    if tokenObject!.expireDate! > Date(){
                    return true
                    }else{
                        return false
                    }
                }else{
                    return false
                }
            }
            }
    }
}
