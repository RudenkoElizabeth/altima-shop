//
//  UserModel.swift
//  Altima
//
//  Created by Elizaveta Rudenko on 08.09.17.
//  Copyright © 2017 Altima. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct UserModel {
    
    let key: String
    let address: String
    let fio: String
    let phone: String
    let ref: DatabaseReference?
    
    
    init(fio: String, phone: String, address: String, key: String = "") {
        self.key = key
        self.fio = fio
        self.phone = phone
        self.address = address
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        if let snapshotValue = snapshot.value as? [String: AnyObject]
        {
            if snapshotValue["fio"] != nil {
                fio = snapshotValue["fio"] as! String
            } else {
                fio = ""
            }
            if snapshotValue["address"] != nil {
                address = snapshotValue["address"] as! String
            } else {
                address = ""
            }
            if snapshotValue["phone"] != nil {
                phone = snapshotValue["phone"] as! String
            } else {
                phone = ""
            }
        }
        else
        {
            fio = ""
            address = ""
            phone = ""
        }
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "phone": phone,
            "address": address,
            "fio": fio
        ]
    }
}
