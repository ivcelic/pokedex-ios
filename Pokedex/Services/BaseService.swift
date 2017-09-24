//
//  BaseService.swift
//  Pokedex
//
//  Created by Iris on 23/09/2017.
//  Copyright © 2017 Iris Veronika Celic. All rights reserved.
//

import Foundation
import Alamofire

class BaseService: NSObject {
    
    static let kUserDefaultsAuthTokenKey = "user_auth_token"
    static let kUserDefaultsEmailKey = "user_email"

    static let kDefaultErrorMessage = "No internet connection!"
    static let kAPIErrorMessage = "Something went wrong. Please try again."
    
    class func initAuthHeader() -> HTTPHeaders {
        let apiToken = UserDefaults.standard.string(forKey: kUserDefaultsAuthTokenKey)
        let email = UserDefaults.standard.string(forKey: kUserDefaultsEmailKey)
        let authorizationHeader: String = "Token token=\(apiToken ?? ""), email=\(email ?? "")"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": authorizationHeader
        ]
        return headers
    }
}

