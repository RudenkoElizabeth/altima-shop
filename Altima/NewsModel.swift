//
//  NewsModel.swift
//  Altima
//
//  Created by Elizaveta Rudenko on 31.08.17.
//  Copyright © 2017 Altima. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

struct NewsModel {
    
    let key: String
    let title: String
    let text: String
    var image: String
    var date: Date
    let ref: DatabaseReference?
    
    init(title: String, text: String, image: String, date: Date, key: String = "") {
        self.key = key
        self.title = title
        self.text = text
        self.image = image
        self.date = date
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
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
            "title": title,
            "text": text,
            "image": image,
            "date": date
        ]
    }
}
