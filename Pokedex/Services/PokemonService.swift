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
                            }
                        } catch {
                            failure(BaseService.kDefaultErrorMessage)
                        }
                    }
            }
        }
    }
    
    

}
