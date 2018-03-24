//
//  LogInViewController.swift
//  Altima
//
//  Created by Elizaveta Rudenko on 07.09.17.
//  Copyright © 2017 Altima. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SCLAlertView

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.keyboardType = UIKeyboardType.emailAddress
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func closeAction() {
        self.dismiss(animated: true, completion: {});
    }
    
    @IBAction func loginAction(_ sender: AnyObject) {
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            SCLAlertView().showNotice(
                "Ошибка",
                subTitle: "Пожалуйста введите свой \ne-mail и пароль",
                closeButtonTitle: "Ок",
                colorStyle: 0x00FF00,
                colorTextButton: 0xFFFFFF)
        } else {
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                if error == nil {
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    self.dismiss(animated: true, completion: nil)
                } else {
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    SCLAlertView().showNotice(
                        "Ошибка",
                        subTitle: "Неверный e-mail или пароль",
                        closeButtonTitle: "Ок",
                        colorStyle: 0x00FF00,
                        colorTextButton: 0xFFFFFF)
                }
            }
        }
    }
}
