//
//  FullProductViewController.swift
//  Altima
//
//  Created by Elizaveta Rudenko on 25.08.17.
//  Copyright © 2017 Altima. All rights reserved.
//

import UIKit
import SCLAlertView
import FirebaseDatabase
import Kingfisher

class FullProductViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    public var productIdex: Int?
    let product = ProductSingleton.shared()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView.init()
        self.tableView.register(UINib(nibName: "ImageProductCell", bundle: nil), forCellReuseIdentifier: "ImageProductCell")
        self.tableView.register(UINib(nibName: "DescriptionProductCell", bundle: nil), forCellReuseIdentifier: "DescriptionProductCell")
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let singleProduct = product.productItems[productIdex!]
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageProductCell") as! ImageProductCell
            let url = URL(string: (singleProduct.image ))
            cell.imageProduct.kf.setImage(with: url)
            cell.nameProduct.text = singleProduct.name
            cell.priceProduct.text = "\(singleProduct.price)₽"
            cell.titleProduct.text = singleProduct.title
            cell.company.text = singleProduct.company
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionProductCell") as! DescriptionProductCell
            cell.descriptionProduct.text = singleProduct.text
            return cell
        }
    }
    
    @IBAction func buttonTapped() {
        let alertView = SCLAlertView()
        let txt = alertView.addTextField("Введите количество")
        txt.keyboardType =  UIKeyboardType.numberPad
        alertView.addButton("Добавить в корзину") {
            self.product.productItems[self.productIdex!].count = Int(txt.text!) ?? 0
        }
        alertView.showEdit(
            "Добавить в корзину",
            subTitle: "",
            closeButtonTitle: "Закрыть",
            colorStyle: 0x00FF00,
            colorTextButton: 0xFFFFFF)
    }
    
}
