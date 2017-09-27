//
//  AddPokemonViewController.swift
//  Pokedex
//
//  Created by Iris on 25/09/2017.
//  Copyright © 2017 Iris Veronika Celic. All rights reserved.
//

import Foundation
import UIKit

class AddPokemonViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    @IBOutlet var name: UITextField!
    @IBOutlet var height: UITextField!
    @IBOutlet var weight: UITextField!
    @IBOutlet var type: UITextField!
    @IBOutlet var pokemonImage: UIImageView!
    @IBOutlet var pokemonDescription: UITextView!
    
    var kbHeight: CGFloat!
    var imagePicker = UIImagePickerController()
    var imageURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setDelegates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setDelegates() {
        imagePicker.delegate = self
        pokemonDescription.delegate = self
        name.delegate = self
        height.delegate = self
        weight.delegate = self
        type.delegate = self
    }
    
    @IBAction func savePokemonPressed(_ sender: UIButton) {
        addPokemon(name: name.text! , height: height.text!, weight: weight.text!, type: type.text!, description: pokemonDescription.text!, image: pokemonImage.image!)
    }
    
    func addPokemon(name: String, height: String, weight: String, type: String, description: String, image: UIImage) {
        Util.showProgressDialog(view: self.view)
        PokemonService().saveNewPokemon(name: name, height:Int(height)!, weight:Int(weight)!, gender: 0, type: type, description: description, image: image, success: { (pokemon) in
            Util.hideProgressDialog(view: self.view)
            self.returnToMainScreen()
        }) { (error) in
            self.showMessage(message: error)
        }
    }
    
    @IBAction func addImagePressed(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.pokemonImage.image = image
        }
        picker.dismiss(animated: true, completion: nil);
    }
    
    func returnToMainScreen() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if (textView.text == "Description")
        {
            textView.text = ""
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView.text == "")
        {
            textView.text = "Description"
        }
        textView.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text == "")
        {
            textField.text = getDefaultTextFor(textField: textField)
        }
        textField.resignFirstResponder()
    }
    
    func getDefaultTextFor(textField: UITextField) -> String {
        switch textField {
        case name:
            return "Name"
        case height:
            return "Height"
        case weight:
            return "Weight"
        case type:
            return "Type"
        default:
            return ""
        }
    }
}
