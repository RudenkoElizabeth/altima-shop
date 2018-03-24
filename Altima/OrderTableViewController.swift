//
//  OrderTableViewController.swift
//  Altima
//
//  Created by Elizaveta Rudenko on 31.08.17.
//  Copyright © 2017 Altima. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseDatabase

class OrderTableViewController: UITableViewController {
    
    public var indexOrder = ""
    var orderProductItem: [OrderProductModel] = []
    var productItem: ProductModel!
    var ref: DatabaseReference! = nil
    var refProduct: DatabaseReference! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if indexOrder != "" {
            getOrderProductItem()
        }
        self.tableView.tableFooterView = UIView.init()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderProductItem.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderProductCell") as! OrderProductTableViewCell
        let itemOrder = orderProductItem[indexPath.row]
        cell.countLabel.text = String(itemOrder.count)
        refProduct = Database.database().reference(withPath: "Product").child(itemOrder.product)
        refProduct.observe(.value, with: { (snapshot) in
            self.productItem = ProductModel(snapshot: snapshot )
            cell.productLabel.text = self.productItem.name
            cell.priceLabel.text = String(self.productItem.price)
            let url = URL(string: self.productItem.image)
            cell.productImage.kf.setImage(with: url)
        })
        return cell
    }
    
    func getOrderProductItem () {
        ref = Database.database().reference(withPath: "OrderProduct").child(indexOrder)
        ref.observe(.value, with: { (snapshot) in
            self.orderProductItem.removeAll()
            for item in snapshot.children {
                let groceryItem = OrderProductModel(snapshot: item as! DataSnapshot)
                self.orderProductItem.append(groceryItem)
            }
            self.tableView.reloadData()
        })
    }
}
