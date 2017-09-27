//
//  PokemonService.swift
//  Pokedex
//
//  Created by Iris on 24/09/2017.
//  Copyright © 2017 Iris Veronika Celic. All rights reserved.
//

import Foundation
import Alamofire
import Unbox

class PokemonService: BaseService {
    
    let kBaseAPIURL: String = "APIURL"
    let kPokemonsAPIURL: String = "/pokemons"
    
    func getAllPokemons(success: @escaping ((_ pokemons: Array<Pokemon>) -> Void), failure:@escaping ((_ errorMessage: String) -> Void)){
        let header = AuthenticationService.initAuthHeader()
        let baseUrl = Util.readFromPlist(key:kBaseAPIURL)
        if baseUrl != nil {
            let url: URLConvertible = baseUrl! + kPokemonsAPIURL
            Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
                .responseJSON { response in
                    switch response.result {
                    case .failure(let error):
                        failure(error.localizedDescription)
                    case .success(let data):
                        do{
                            if(response.response?.statusCode == 200) {
                                let parsedData = data as! NSDictionary
                                let pokemonsArray = parsedData.object(forKey: "data") as! NSArray
                                var pokemons: [Pokemon] = []
                                for pokemonDict in pokemonsArray {
                                    let pokemon: Pokemon = try unbox(dictionary: pokemonDict as! UnboxableDictionary)
                                    pokemons.append(pokemon)
                                }
                                success(pokemons)
                            } else {
                                failure(BaseService.kAPIErrorMessage)
                                print(data)
                            }
                        } catch {
                            failure(BaseService.kDefaultErrorMessage)
                        }
                    }
            }
        }
    }

    func saveNewPokemon(name: String, height: Int, weight: Int, gender: Int, type: String, description: String, image: UIImage, success: @escaping ((_ pokemon: Pokemon?) -> Void), failure:@escaping ((_ errorMessage: String) -> Void)){
        let header = AuthenticationService.initAuthHeader()
        var dict: [String: AnyObject] = [:]
        var params: [String: AnyObject] = [:]
        let attributes = [ "name":name, "height": height, "weight":weight, "gender-id":gender, "type":type, "description":description, "image-url":"aaaa"] as [String : Any]
        params["attributes"] = attributes as AnyObject
        dict["data"] = params as AnyObject
        let baseUrl = Util.readFromPlist(key:kBaseAPIURL)
        if baseUrl != nil {
            let url: URLConvertible = baseUrl! + kPokemonsAPIURL
            Alamofire.request(url, method: .post, parameters: dict, encoding: JSONEncoding.default, headers: header)
                .responseJSON { response in
                    switch response.result {
                    case .failure(let error):
                        failure(error.localizedDescription)
                    case .success(let data):
                        do{
                            if(response.response?.statusCode == 201) {
                                let pokemon: Pokemon = try unbox(dictionary: data as! UnboxableDictionary, atKey: "data")
                                self.saveAPIImage(image: image, pokemonId: pokemon.pokemonId, success: { (imageUrl) in
                                    pokemon.imageUrl = imageUrl!
                                    success(pokemon)
                                }, failure: { (error) in
                                    failure(BaseService.kAPIErrorMessage)
                                })
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
    
    func getAPIImage(imageUrl: String, success: @escaping ((_ image: UIImage?) -> Void), failure:@escaping ((_ errorMessage: String) -> Void)){
        if imageUrl.characters.count != 0 {
        DataRequest.addAcceptableImageContentTypes(["image/jpg"])
        DataRequest.addAcceptableImageContentTypes(["image/png"])
        let baseUrl = Util.readFromPlist(key:kBaseAPIURL)
        if baseUrl != nil {
            let url: URLConvertible = "https://pokeapi.infinum.co" + imageUrl
            Alamofire.request(url).responseImage { response in
                if let image = response.result.value {
                    success(image)
                }
            }
        }
        }
    }
    
    func saveAPIImage(image: UIImage, pokemonId: Int, success: @escaping ((_ imageUrl: String?) -> Void), failure:@escaping ((_ errorMessage: String) -> Void)){
        let header = AuthenticationService.initAuthHeader()
        let imageData = UIImagePNGRepresentation(image)!
        let imageUrl = "/uploads/store/pokemon/" + String(pokemonId) + "/image/pokemonImage.png"
        let url: URLConvertible = "https://pokeapi.infinum.co" + imageUrl
        Alamofire.upload(imageData, to: url, headers: header).responseJSON { response in
            success(imageUrl)
        }
    }
    
    func getCommentsForPokemonId(id: String, success: @escaping ((_ comments: NSArray) -> Void), failure:@escaping ((_ errorMessage: String) -> Void)){
        let header = AuthenticationService.initAuthHeader()
        let baseUrl = Util.readFromPlist(key:kBaseAPIURL)
        if baseUrl != nil {
            let url: URLConvertible = baseUrl! + kPokemonsAPIURL + "/" + id + "/comments"
            Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
                .responseJSON { response in
                    switch response.result {
                    case .failure(let error):
                        failure(error.localizedDescription)
                    case .success(let data):
                        if(response.response?.statusCode == 200) {
                            let parsedData = data as! NSDictionary
                            let commentsArray = parsedData.object(forKey: "data") as! NSArray
                            print(data)
                            success(commentsArray)
                        } else {
                            failure(BaseService.kAPIErrorMessage)
                            print(data)
                        }
                    }
            }
        }
    }

}
