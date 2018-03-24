//
//  BasketViewController.swift
//  Altima
//
//  Created by Elizaveta Rudenko on 30.08.17.
//  Copyright © 2017 Altima. All rights reserved.
//

import UIKit
import SCLAlertView
import Firebase
import FirebaseAuth
import FirebaseDatabase

class BasketViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, BasketStepperDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderButton: UIButton!
    var labelHeader = UILabel()
    var totalPrice = 0
    let product = ProductSingleton.shared()
    var refOrder: DatabaseReference! = nil
    var refProduct: DatabaseReference! = nil
    var orderItem: OrderModel? = nil
    var orderProductItems: OrderProductModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView.init()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        product.filterProductBasket()
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product.productBasket.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketCell") as! BasketTableViewCell
        let productItem = product.productBasket[indexPath.row]
        cell.nameLabel.text = productItem.name
        cell.priceLable.text = "\(productItem.price)₽"
        cell.stepperValue.text = String(productItem.count)
        cell.stepper.value = Double(productItem.count)
        cell.delegate = self
        return cell
    }
    
    func changePrice() {
        totalPrice = 0
        for item in 0..<product.productBasket.count {
            let productOrder = product.productBasket[item]
            totalPrice += productOrder.count * productOrder.price
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection  section: Int) -> UIView? {
        changePrice()
        labelHeader.text = "  Cтоимость заказа \(totalPrice)₽"
        labelHeader.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        return labelHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func stepperButton(sender: BasketTableViewCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            product.productBasket[indexPath.row].count = Int(sender.stepper.value)
            changePrice()
            labelHeader.text = "  Cтоимость заказа \(totalPrice)₽"
            print("row: \(indexPath), value: \(sender.stepper.value)")
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            print("remove \(indexPath.row)")
            product.productBasket[indexPath.row].count = 0
            product.changeProductFromBasket()
            product.productBasket.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    @IBAction func buttonTapped() {
        if Auth.auth().currentUser != nil {
            changePrice()
            let dateFormatter = DateFormatter.init()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let dateOrder = Date.init()
            let status = "Ожидает подтверждения"
            let unicIdOrder = UUID.init().uuidString
            let dictOrder = [ "date": dateFormatter.string(from: dateOrder),
                              "price": totalPrice,
                              "status": status ] as [String : Any]
            self.refOrder = Database.database().reference(withPath: "Order").child((Auth.auth().currentUser?.uid)!)
            self.refOrder.child(unicIdOrder).setValue(dictOrder)
            for itemBasket in 0..<product.productBasket.count {
                let itemProduct = product.productBasket[itemBasket].key
                let countProduct = product.productBasket[itemBasket].count
                let unicIdOrderProduct = UUID.init().uuidString
                let dictOrderProduct = [ "count": countProduct,
                                         "product": itemProduct ] as [String : Any]
                self.refProduct = Database.database().reference(withPath: "OrderProduct").child(unicIdOrder)
                self.refProduct.child(unicIdOrderProduct).setValue(dictOrderProduct)
            }
            for (index, _) in product.productBasket.enumerated() {
                product.productBasket[index].count = 0
            }
            product.changeProductFromBasket()
            product.filterProductBasket()
            tableView.reloadData()
            SCLAlertView().showNotice(
                "Заказ принят",
                subTitle: "Ожидайте звонка оператора",
                closeButtonTitle: "Закрыть",
                colorStyle: 0x00FF00,
                colorTextButton: 0xFFFFFF)
            tableView.reloadData()
        } else {
            SCLAlertView().showNotice(
                "Ошибка",
                subTitle: "Необходимо авторизоваться",
                closeButtonTitle: "Закрыть",
                colorStyle: 0x00FF00,
                colorTextButton: 0xFFFFFF)
        }
    }
}
