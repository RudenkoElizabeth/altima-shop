//
//  ProductModel.swift
//  Altima
//
//  Created by Elizaveta Rudenko on 05.09.17.
//  Copyright © 2017 Altima. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

struct ProductModel {
    
    let key: String
    let name: String
    let title: String
    let text: String
    let company: String
    let price: Int
    var image: String
    var count = 0
    let ref: DatabaseReference?
    
    init(name: String, title: String, text: String, image: String, company: String, price: Int, key: String = "") {
        self.name = name
        self.key = key
        self.title = title
        self.text = text
        self.image = image
        self.company = company
        self.price = price
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        if snapshotValue["name"] != nil {
            name = snapshotValue["name"] as! String
        } else {
            name = ""
        }
        if snapshotValue["title"] != nil {
            title = snapshotValue["title"] as! String
        } else {
            title = ""
        }
        if snapshotValue["text"] != nil {
            text = snapshotValue["text"] as! String
        } else {
            text = ""
        }
        if snapshotValue["image"] != nil {
            image = snapshotValue["image"] as! String
        } else {
            image = ""
        }
        if snapshotValue["company"] != nil {
            company = snapshotValue["company"] as! String
        } else {
            company = ""
        }
        if snapshotValue["price"] != nil {
            price = snapshotValue["price"] as! Int
        } else {
            price = 0
        }
        ref = snapshot.ref
    }
}
