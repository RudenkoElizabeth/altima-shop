//
//  RegistrationViewController.swift
//  Altima
//
//  Created by Elizaveta Rudenko on 05.09.17.
//  Copyright © 2017 Altima. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SCLAlertView

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var signUpButton: UIButton!
    
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
    
    @IBAction func createAccountAction(_ sender: AnyObject) {
        if emailTextField.text == "" {
            SCLAlertView().showNotice(
                "Ошибка",
                subTitle: "Пожалуйста введите свой \ne-mail и пароль",
                closeButtonTitle: "Ок",
                colorStyle: 0x00FF00,
                colorTextButton: 0xFFFFFF)
        } else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error == nil {
                    print("You have successfully signed up")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                } else { if (self.passwordTextField.text?.characters.count)! < 6 {
                    SCLAlertView().showNotice(
                        "Ошибка",
                        subTitle: "Пароль должен содержать более 6 символов",
                        closeButtonTitle: "Ок",
                        colorStyle: 0x00FF00,
                        colorTextButton: 0xFFFFFF)
                } else {
                    SCLAlertView().showNotice(
                        "Ошибка",
                        subTitle: "Неверный формат e-mail",
                        closeButtonTitle: "Ок",
                        colorStyle: 0x00FF00,
                        colorTextButton: 0xFFFFFF)
                    }
                }
            }
        }
    }
}
