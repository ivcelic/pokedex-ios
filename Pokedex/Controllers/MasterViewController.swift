//
//  MasterViewController.swift
//  Pokedex
//
//  Created by Iris on 23/09/2017.
//  Copyright © 2017 Iris Veronika Celic. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class PokemonCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
}

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    var objects = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarApperance()
        loadTableData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logout(_ sender: Any) {
        AuthenticationService().signout(success: {
        }) { (error) in
            self.showMessage(message: error)
        }
    }
    
    func setNavigationBarApperance() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = Util.basicBlueColor()
        self.navigationController?.navigationItem.titleView?.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    
    func loadTableData() {
        Util.showProgressDialog(view: self.view)
        loadPokemons()
    }
    
    func loadPokemons() {
        PokemonService().getAllPokemons(success: { (pokemons) in
            self.objects = pokemons
            self.tableView.reloadData()
            Util.hideProgressDialog(view: self.view)
        }) { (error) in
            self.showMessage(message: error)
        }
    }

    func insertNewObject(_ sender: Any) {
        objects.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let pokemon = objects[indexPath.row] as! Pokemon
                let controller = segue.destination as! DetailViewController
                controller.pokemon = pokemon
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath) as! PokemonCell
        let pokemon = objects[indexPath.row] as! Pokemon
        cell.nameLabel!.text = pokemon.name
        cell.tag = indexPath.row
        if(indexPath.row == cell.tag) {
            if(pokemon.image == nil) {
                cell.pokemonImageView.setImageForPokemon(pokemon: pokemon)
            } else {
                cell.pokemonImageView.image = pokemon.image
            }
            cell.pokemonImageView.setCircleMask()
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension UIImageView {
    
    func setImageForPokemon(pokemon: Pokemon) {
        PokemonService().getAPIImage(pokemon: pokemon, success: { (image) in
            pokemon.image = image
        }) { (error) in
            print(error)
        }
    }
    
    public func setCircleMask() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
}



