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

class PokemonCommentCell: UITableViewCell {
    @IBOutlet var author: UILabel!
    @IBOutlet var comment: UILabel!
}

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var pokemonDetailsTable: UITableView!
    var pokemon: Pokemon!
    var pokemonComments = [Comment]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadComments()
        addTitle(title: pokemon.name)
        pokemonDetailsTable.delegate = self
        pokemonDetailsTable.dataSource = self
    }
    
    func loadComments() {
        Util.showProgressDialog(view: self.view)
        let id = String(pokemon.pokemonId)
        PokemonService().getCommentsForPokemonId(id: id, success: { (comments) in
            if (comments.count == 0) {
                Util.hideProgressDialog(view: self.view)
                return
            }
            for comment in comments {
                AuthenticationService().getUsernameForUserId(id: comment.authorId, success: { (username) in
                    let commentWithName = Comment.init(authorId: comment.authorId, authorName: username, comment: comment.comment)
                    self.pokemonComments.append(commentWithName)
                    if(self.pokemonComments.count == comments.count) {
                        self.pokemonDetailsTable.reloadData()
                        Util.hideProgressDialog(view: self.view)
                    }
                }, failure: { (error) in
                    print(error)
                })
            }
        }) { (error) in
            self.showMessage(message: error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 + pokemonComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell: UITableViewCell
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonImageCell", for: indexPath) as! PokemonImageCell
            if(pokemon.imageUrl.characters.count > 0) {
                if(pokemon.image == nil) {
                PokemonService().getAPIImage(pokemon: pokemon, success: { (image) in
                    cell.pokemonImage.image = image
                }, failure: { (error) in
                    print(error)
                })
                } else {
                    cell.pokemonImage.image = pokemon.image
                }
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
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCommentCell", for: indexPath) as! PokemonCommentCell
            let comment = pokemonComments[indexPath.row-3] as Comment
            cell.author.text = comment.authorName
            cell.comment.text = comment.comment
            tableCell = cell
        }
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension UIViewController {
    
    func addTitle(title: String) {
        if(self.navigationController != nil) {
            self.navigationItem.title = title
        }
    }
}

