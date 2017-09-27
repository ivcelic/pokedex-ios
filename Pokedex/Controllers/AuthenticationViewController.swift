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
    
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func loadView() {
        super.loadView()
        self.hideKeyboardWhenTappedAround()
        loginButton.backgroundColor = Util.basicBlueColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        email.delegate = self;
        password.delegate = self;
        performSignIn(email: "irisc@gmail.com", password: "87654321")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        email.resignFirstResponder()
        password.resignFirstResponder()
        self.signIn(email: self.email.text!, password: self.password.text!)
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text == "")
        {
            textField.text = getDefaultTextFor(textField: textField)
        }
        textField.resignFirstResponder()
    }
    
    func getDefaultTextFor(textField: UITextField) -> String {
        switch textField {
        case email:
            return "Email"
        case password:
            return "Password"
        default:
            return ""
        }
    }
}
