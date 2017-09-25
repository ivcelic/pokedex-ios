//
//  AuthenticationViewController.swift
//  Pokedex
//
//  Created by Iris on 25/09/2017.
//  Copyright © 2017 Iris Veronika Celic. All rights reserved.
//

import Foundation
import UIKit

class AuthenticationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    override func loadView() {
        super.loadView()
        loginButton.backgroundColor = Util.basicBlueColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        self.signIn(email: self.emailTextField.text!, password: self.passwordTextField.text!)
    }
    
    func signIn(email: String, password: String) {
        if email.characters.count > 0 && password.characters.count > 0  {
            if(password.characters.count < 8) {
                showMessage(message: "Password should be at least 8 characters long.")
            }
            Util.showProgressDialog(view: self.view)
            performSignIn(email: email,password: password)
        } else {
            showMessage(message: "All required fields should be filled!")
        }
    }
    
    func performSignIn(email: String, password: String) {
        AuthenticationService().signinWithEmail(email: email, andPassword: password, success: { (user) in
            self.signinSuccessfull()
        }) { (error) in
            self.showMessage(message: error)
        }
    }
    
    func signinSuccessfull() {
        Util.hideProgressDialog(view: self.view)
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "showMainView", sender: self)
        }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        performSignIn(email: emailTextField.text!, password: passwordTextField.text!)
        return true
    }
}
