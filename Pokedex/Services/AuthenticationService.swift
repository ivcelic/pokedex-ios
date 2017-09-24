//
//  AuthenticationService.swift
//  Pokedex
//
//  Created by Iris on 23/09/2017.
//  Copyright © 2017 Iris Veronika Celic. All rights reserved.
//

import UIKit
import Alamofire
import Unbox

class AuthenticationService: BaseService {
    
    let kBaseAPIURL: String = "APIURL"
    let kRegisterAPIURL: String = "/users"
    let kSignInAPIURL: String = "/users/login"
    let kSignOutAPIURL: String = "/users/logout"
    
    //username is same as email
    func createNewUser(email: String, andPassword password: String, success: @escaping ((_ user: User?) -> Void), failure:@escaping ((_ errorMessage: String) -> Void)){
        var dict: [String: AnyObject] = [:]
        var params: [String: AnyObject] = [:]
        params["type"] = "users" as AnyObject
        let attributes = [ "username":email, "email": email, "password":password, "password-confirmation":password ]
        params["attributes"] = attributes as AnyObject
        dict["data"] = params as AnyObject
        let baseUrl = Util.readFromPlist(key:kBaseAPIURL)
        if baseUrl != nil {
            let url: URLConvertible = baseUrl! + kRegisterAPIURL
            Alamofire.request(url, method: .post, parameters: dict, encoding: JSONEncoding.default)
                .responseJSON { response in
                    switch response.result {
                    case .failure(let error):
                        failure(error.localizedDescription)
                    case .success(let data):
                        do{
                            if(response.response?.statusCode == 201) {
                                let user: User = try unbox(dictionary: data as! UnboxableDictionary, atKey: "data")
                                success(user)
                            } else {
                                failure(BaseService.kAPIErrorMessage)
                            }
                        } catch {
                            failure(BaseService.kDefaultErrorMessage)
                        }
                    }
            }
        }
    }
    
    func signinWithEmail(email: String, andPassword password: String, success: @escaping ((_ user: User?) -> Void), failure:@escaping ((_ errorMessage: String) -> Void)){
        var dict: [String: AnyObject] = [:]
        var params: [String: AnyObject] = [:]
        params["type"] = "session" as AnyObject
        let attributes = [ "email": email, "password":password ]
        params["attributes"] = attributes as AnyObject
        dict["data"] = params as AnyObject
        let baseUrl = Util.readFromPlist(key:kBaseAPIURL)
        if baseUrl != nil {
            let url: URLConvertible = baseUrl! + kSignInAPIURL
            Alamofire.request(url, method: .post, parameters: dict, encoding: JSONEncoding.default)
                .responseJSON { response in
                    switch response.result {
                    case .failure(let error):
                        failure(error.localizedDescription)
                    case .success(let data):
                        do{
                            if(response.response?.statusCode == 201) {
                                let user: User = try unbox(dictionary: data as! UnboxableDictionary, atKey: "data")
                                self.setUserCredentials(email: user.email,authToken: user.authToken)
                                success(user)
                            } else {
                                failure(BaseService.kAPIErrorMessage)
                            }
                        } catch {
                            failure(BaseService.kDefaultErrorMessage)
                        }
                    }
            }
        }
    }
    
    func signout(success:@escaping () -> (), failure: @escaping (_ errorMessage: String) -> ()) {
        let header = AuthenticationService.initAuthHeader()
        let baseUrl = Util.readFromPlist(key: kBaseAPIURL)
        if baseUrl != nil {
            let url: URLConvertible = baseUrl! + kSignOutAPIURL
            Alamofire.request(url, method: .delete, headers: header)
                .responseJSON { response in
                    switch response.result {
                    case .failure(let error):
                        failure(error.localizedDescription)
                    case .success(let data):
                            if(response.response?.statusCode == 204) {
                                self.removeUserCredentials()
                                print(data)
                                success()
                            } else {
                                print(data)
                                failure(BaseService.kAPIErrorMessage)
                            }
                    }
            }
        }
    }
    

    
    func setUserCredentials(email:String, authToken:String) {
        UserDefaults.standard.setValue(email,forKey:AuthenticationService.kUserDefaultsEmailKey)
        UserDefaults.standard.setValue(authToken,forKey:AuthenticationService.kUserDefaultsAuthTokenKey)
        UserDefaults.standard.synchronize()
    }
    
    func removeUserCredentials() {
        UserDefaults.standard.removeObject(forKey: AuthenticationService.kUserDefaultsEmailKey)
        UserDefaults.standard.removeObject(forKey:AuthenticationService.kUserDefaultsAuthTokenKey)
        UserDefaults.standard.synchronize()
    }
}

