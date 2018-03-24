//
//  ProductSingleton.swift
//  Altima
//
//  Created by Elizaveta Rudenko on 13.09.17.
//  Copyright © 2017 Altima. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ProductSingleton {
    
    var productItems: [ProductModel] = []
    var productBasket: [ProductModel] = []
    var ref: DatabaseReference! = nil
    
    private static var uniqueInstance: ProductSingleton?
    
    static func shared() -> ProductSingleton {
        if uniqueInstance == nil {
            uniqueInstance = ProductSingleton()
        }
        return uniqueInstance!
    }
    
    func getProduct() {
        ref = Database.database().reference(withPath: "Product")
        ref.queryOrdered(byChild: "name").observe(.value, with: { snapshot in
            for item in snapshot.children {
                let groceryItem = ProductModel(snapshot: item as! DataSnapshot)
                self.productItems.append(groceryItem)
                print("item :", item)
            }
            //send message
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ProductArrayLoaded"), object: nil)
        })
    }
    
    func filterProductBasket() {
        productBasket = productItems.filter({$0.count > 0})
    }
    
    func changeProductFromBasket() {
        for filterItem in 0..<productBasket.count {
            for oridginalItem in 0..<productItems.count {
                if productBasket[filterItem].key == productItems[oridginalItem].key {
                    productItems[oridginalItem].count = productBasket[filterItem].count
                }
            }
        }
    }
}
