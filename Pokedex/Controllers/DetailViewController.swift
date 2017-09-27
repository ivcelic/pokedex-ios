//
//  DetailViewController.swift
//  Pokedex
//
//  Created by Iris on 23/09/2017.
//  Copyright © 2017 Iris Veronika Celic. All rights reserved.
//

import UIKit

class PokemonImageCell: UITableViewCell {
    @IBOutlet var pokemonImage: UIImageView!
}

class PokemonDescriptionCell: UITableViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var pokemonDescription: UITextView!
}

class PokemonAttributesCell: UITableViewCell {
    @IBOutlet var gender: UILabel!
    @IBOutlet var type: UILabel!
    @IBOutlet var weight: UILabel!
    @IBOutlet var height: UILabel!
}

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var pokemonDetailsTable: UITableView!
    var pokemon: Pokemon!

    func configureView() {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonDetailsTable.delegate = self
        pokemonDetailsTable.dataSource = self
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell: UITableViewCell
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonImageCell", for: indexPath) as! PokemonImageCell
            if(pokemon.imageUrl.characters.count > 0) {
                PokemonService().getAPIImage(imageUrl: pokemon.imageUrl, success: { (image) in
                    cell.pokemonImage.image = image
                }, failure: { (error) in
                    print(error)
                })
            }
            tableCell = cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonDescriptionCell", for: indexPath) as! PokemonDescriptionCell
            cell.name.text = pokemon.name
            cell.pokemonDescription.text = pokemon.description
            tableCell = cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonAttributesCell", for: indexPath) as! PokemonAttributesCell
            cell.height.text = String(describing: pokemon.height)
            cell.weight.text = String(describing: pokemon.weight)
            cell.type.text = pokemon.type
            cell.gender.text = pokemon.gender
            tableCell = cell
//        case >3:
//            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath) 
            tableCell = cell
        }
        
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }


}

