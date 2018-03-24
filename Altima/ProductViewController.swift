//
//  ProductViewController.swift
//  Altima
//
//  Created by Elizaveta Rudenko on 21.08.17.
//  Copyright © 2017 Altima. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Kingfisher
import SCLAlertView

class ProductViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ProductStepperDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let product = ProductSingleton.shared()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        product.getProduct()
        NotificationCenter.default.addObserver(self, selector: #selector(loadProduct), name: NSNotification.Name(rawValue: "ProductArrayLoaded"), object: nil)
        self.tableView.tableFooterView = UIView.init()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        product.changeProductFromBasket()
        tableView.reloadData()
    }
    
    func loadProduct() {
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product.productItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellProduct") as! ProductTableViewCell
        let productItem = product.productItems[indexPath.row]
        cell.nameLabel.text = productItem.name
        cell.priceLable.text = "\(productItem.price)₽"
        cell.descriptionLable.text = productItem.title
        cell.stepperValue.text = String(productItem.count)
        cell.stepper.value = Double(productItem.count)
        let url = URL(string: productItem.image)
        cell.previewImage.kf.setImage(with: url)
        cell.delegate = self
        return cell
    }
    
    func stepperButton(sender: ProductTableViewCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            product.productItems[indexPath.row].count = Int(sender.stepper.value)
            print("row: \(indexPath), value: \(sender.stepper.value)")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FullProductViewController") as! FullProductViewController
        vc.productIdex = indexPath.row
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
