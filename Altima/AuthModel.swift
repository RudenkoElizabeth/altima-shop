//
//  AuthModel.swift
//  Altima
//
//  Created by Elizaveta Rudenko on 06.09.17.
//  Copyright © 2017 Altima. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

struct AuthModel {
    
    let uid: String
    let email: String
    
    init(authData: User) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}
