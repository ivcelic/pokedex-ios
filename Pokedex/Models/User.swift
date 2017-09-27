//
//  User.swift
//  Pokedex
//
//  Created by Iris on 24/09/2017.
//  Copyright © 2017 Iris Veronika Celic. All rights reserved.
//

import Foundation
import Unbox

class User: Unboxable {
    
    var userId: Int = -1
    var email: String = ""
    var username: String = ""
    var authToken: String = ""
    private var attributes = [String : String]()
    
    required init(unboxer: Unboxer) throws {
        self.userId = try unboxer.unbox(key: "id")
        self.attributes = try unboxer.unbox(key: "attributes")
        self.email = attributes["email"]!
        self.username = attributes["username"]!
        if(attributes["auth-token"] != nil) {
            self.authToken = attributes["auth-token"]!
        }
    }
}
