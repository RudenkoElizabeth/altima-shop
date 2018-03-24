//
//  OrderModel.swift
//  Altima
//
//  Created by Elizaveta Rudenko on 11.09.17.
//  Copyright © 2017 Altima. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

struct OrderModel {
    
    let key: String
    let status: String
    let price: Int
    var date: Date
    let ref: DatabaseReference?
    
    init(key: String = "", status: String, date: Date, price: Int) {
        self.key = key
        self.status = status
        self.date = date
        self.price = price
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        if snapshotValue["status"] != nil {
            status = snapshotValue["status"] as! String
        } else {
            status = ""
        }
        if snapshotValue["price"] != nil {
            price = snapshotValue["price"] as! Int
        } else {
            price = 0
        }
        if snapshotValue["date"] != nil {
            let stringDate = snapshotValue["date"] as! String
            let dateFormatter = DateFormatter.init()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            date = dateFormatter.date(from: stringDate) ?? Date.init()
            
            print("stringDate: \(stringDate), date: \(date)")
        } else {
            date = Date.init()
        }
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "date": date,
            "price": price,
            "satus": status
        ]
    }
}
