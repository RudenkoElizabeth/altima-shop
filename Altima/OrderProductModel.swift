//
//  OrderProductModel.swift
//  Altima
//
//  Created by Elizaveta Rudenko on 11.09.17.
//  Copyright © 2017 Altima. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct OrderProductModel {
    
    let key: String
    let product: String
    let count: Int
    let ref: DatabaseReference?
    
    init(key: String = "", product: String, count: Int) {
        self.key = key
        self.product = product
        self.count = count
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        if snapshotValue["product"] != nil {
            product = snapshotValue["product"] as! String
        } else {
            product = ""
        }
        if snapshotValue["count"] != nil {
            count = snapshotValue["count"] as! Int
        } else {
            count = 0
        }
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "product": product,
            "count": count
        ]
    }
}
