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
    
    var imagePicker = UIImagePickerController()
    var imageURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboardWhenTappedAround()
        setTextFieldsDelegates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setTextFieldsDelegates() {
        pokemonDescription.delegate = self
        name.delegate = self
        height.delegate = self
        weight.delegate = self
        type.delegate = self
    }
    
    @IBAction func savePokemonPressed(_ sender: UIButton) {
        addPokemon(name: name.text! , height: height.text!, weight: weight.text!, type: type.text!, description: pokemonDescription.text!, imageUrl: imageURL)
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
    
    @IBAction func addImagePressed(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let imagePath = documentsPath?.appendingPathComponent(self.name.text! + ".jpg")
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.pokemonImage.image = image
            do {
                try UIImageJPEGRepresentation(image, 0.0)?.write(to: imagePath!)
                imageURL = (imagePath?.relativeString)!
            } catch {
                imageURL = ""
            }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
