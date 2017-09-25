//
//  AddPokemonViewController.swift
//  Pokedex
//
//  Created by Iris on 25/09/2017.
//  Copyright © 2017 Iris Veronika Celic. All rights reserved.
//

import Foundation
import UIKit

class AddPokemonViewController: UIViewController {
    
    @IBOutlet var name: UITextField!
    @IBOutlet var height: UITextField!
    @IBOutlet var weight: UITextField!
    @IBOutlet var type: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func savePokemonPressed(_ sender: UIButton) {
        addPokemon(name: name.text! , height: height.text!, weight: weight.text!, type: type.text!, description: "", imageUrl: "")
    }
    
    func addPokemon(name: String, height: String, weight: String, type: String, description: String, imageUrl: String) {
        Util.showProgressDialog(view: self.view)
        //gender is male
        PokemonService().saveNewPokemon(name: name, height:Int(height)!, weight:Int(weight)!, gender: 0, type: type, description: description, imageUrl: imageUrl, success: { (pokemon) in
            Util.hideProgressDialog(view: self.view)
            self.returnToMainScreen()
        }) { (error) in
            self.showMessage(message: error)
        }
    }
    
    func returnToMainScreen() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func showMessage(message: String) {
        Util.hideProgressDialog(view: self.view)
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
}
