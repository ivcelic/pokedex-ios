//
//  Util.swift
//  Pokedex
//
//  Created by Iris on 23/09/2017.
//  Copyright © 2017 Iris Veronika Celic. All rights reserved.
//

import Foundation

class Util: NSObject {
    
    static func readFromPlist(key: String) -> String? {
        guard let plist = Bundle.main.infoDictionary else {
            return ""
        }
        
        guard let value: String = plist[key] as? String else {
            return ""
        }
        
        return value
    }
}
