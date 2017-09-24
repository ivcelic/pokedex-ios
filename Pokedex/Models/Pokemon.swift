//
//  Pokemon.swift
//  Pokedex
//
//  Created by Iris on 24/09/2017.
//  Copyright © 2017 Iris Veronika Celic. All rights reserved.
//

import Foundation
import Unbox

class Pokemon: Unboxable {
    
    var pokemonId: Int = -1
    var name: String = ""
    var type: String = ""
    var height: Int = -1
    var weight: Int = -1
    var gender: String = ""
    var description: String = ""
    var imageUrl: String = ""
    private var attributes = [String : AnyObject]()
    
    required init(unboxer: Unboxer) throws {
        self.pokemonId = try unboxer.unbox(key: "id")
        self.type = try unboxer.unbox(key: "type") 
        self.attributes = try unboxer.unbox(key: "attributes")
        self.name = attributes["name"] as? String ?? ""
        self.height = attributes["height"] as? Int ?? -1
        self.weight = attributes["weight"] as? Int ?? -1
        self.gender = attributes["gender"] as? String ?? ""
        self.description = attributes["description"] as? String ?? ""
        self.imageUrl = attributes["image-url"] as? String ?? ""
    }
}




