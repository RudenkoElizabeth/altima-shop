//
//  EditProfileViewController.swift
//  Altima
//
//  Created by Elizaveta Rudenko on 31.08.17.
//  Copyright © 2017 Altima. All rights reserved.
//

import UIKit
import SCLAlertView
import Firebase
import FirebaseAuth
import FirebaseDatabase

class EditProfileViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var addressText: UITextView!
    public var isFromProfile = false
    var authItem: AuthModel!
    var userItem: UserModel!
    var ref: DatabaseReference! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameText.delegate = self
        phoneText.delegate = self
        addressText.delegate = self
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                guard let user = user else { return }
                self.authItem = AuthModel(authData: user)
                self.getUserItem()
            } else {
                self.closeAction()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameText.resignFirstResponder()
        phoneText.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"  // Recognizes enter key in keyboard
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func getUserItem () {
        ref = Database.database().reference(withPath: "User").child(authItem.uid)
        ref.observe(.value, with: { (snapshot) in
            self.userItem = UserModel(snapshot: snapshot )
            self.nameText.text = self.userItem.fio
            self.addressText.text = self.userItem.address
            self.phoneText.text = self.userItem.phone
            
        })
    }
    
    func closeAction() {
        if isFromProfile {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: {});
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isFromProfile {
            self.navigationItem.setHidesBackButton(true, animated:true);
        }
    }
    
    @IBAction func buttonTapped() {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        if nameText.text == "" || phoneText.text == "" || addressText.text == "" {
            alertView.showNotice(
                "Ошибка",
                subTitle: "Заполните поля",
                duration: 3,
                colorStyle: 0x00FF00,
                colorTextButton: 0xFFFFFF)
            return
        } else {
            let dict = [ "fio": nameText.text!,
                         "address": addressText.text!,
                         "phone": phoneText.text! ]
            ref = Database.database().reference(withPath: "User")
            self.ref.child(authItem.uid).setValue(dict)
            alertView.showNotice(
                "Сохранено",
                subTitle: "",
                duration: 3,
                colorStyle: 0x00FF00,
                colorTextButton: 0xFFFFFF)
        }
        closeAction()
    }
}
