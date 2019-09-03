//
//  ClientTest.swift
//  App
//
//  Created by Telekom MK on 3/4/19.
//

import Foundation
import Vapor
import Fluent


final class ClientTest{
    
    
    func client(_ req: Request) throws -> Future<BinNumber>{
        
        var url: URL!
        url = URL.init(string: "https://neutrinoapi.com/bin-lookup")
        url = url.append("user-id", value: "petar.mitevski").append("api-key", value: "yvtbBS0dNwGoi2LLApTpBFmU5k8Z8HeJ7sFaJ69yEdAUDD02").append("bin-number", value: "536506").append("output-case", value: "camel")
        
         return try req.client().get(url.absoluteString).flatMap(to: BinNumber.self) { response in

                guard response.http.status == .ok else {

                    throw Abort(.unauthorized)
                }
            
            print(response)
            return try response.content.decode(BinNumber.self)
        }
        
        
    }
}
