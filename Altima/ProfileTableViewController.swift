//
//  ProfileTableViewController.swift
//  Altima
//
//  Created by Elizaveta Rudenko on 30.08.17.
//  Copyright © 2017 Altima. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var exitButton: UIBarButtonItem!
    
    var authView: AuthView?
    var authItem: AuthModel!
    var userItem: UserModel!
    var orderArray: [OrderModel] = []
    var ref: DatabaseReference! = nil
    var refOrder: DatabaseReference! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView.init()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.authView?.removeFromSuperview()
                guard let user = user else { return }
                self.authItem = AuthModel(authData: user)
                self.tableView.reloadData()
                self.exitButton.isEnabled = true
                self.exitButton.tintColor = .black
                self.getUserItem()
                self.getUserOrders()
            } else {
                self.showLoginPlaceholder()
                self.exitButton.isEnabled = false
                self.exitButton.tintColor = .clear
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if (authItem != nil) {
            if orderArray.count > 0 {
                return 2
            }
            return 1
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return orderArray.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        }
        return 90
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellProfile") as! ProfileTableViewCell
            if userItem != nil {
                cell.nameLabel.text = userItem.fio
                cell.phoneLabel.text = userItem.phone
                cell.addressLable.text = userItem.address
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellOrder") as! OrderTableViewCell
            let item = orderArray[indexPath.row]
            let idOrder = indexPath.row + 1
            cell.orderLabel.text = "Заказ № \(idOrder)"
            cell.statusLable.text = item.status
            cell.priceLablel.text = "\(item.price)₽"
            let dateFormatter = DateFormatter.init()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            cell.dateLabel.text =  dateFormatter.string(from: (item.date) )
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Заказы"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 30
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        if indexPath.section == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
            vc.isFromProfile = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderTableViewController") as! OrderTableViewController
            let item = orderArray[indexPath.row]
            vc.indexOrder = item.key
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func signUpAction() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        let navController = UINavigationController.init(rootViewController: vc)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    func logInAction() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
        let navController = UINavigationController.init(rootViewController: vc)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    @IBAction func logOutAction(sender: AnyObject) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func showLoginPlaceholder() {
        authView?.removeFromSuperview()
        authView = Bundle.main.loadNibNamed("AuthView", owner: nil, options: nil)?[0] as? AuthView
        authView?.frame = self.view.frame
        authView?.signUpButton.addTarget(self, action: #selector(self.signUpAction), for: UIControlEvents.touchUpInside)
        authView?.logInButton.addTarget(self, action: #selector(self.logInAction), for: UIControlEvents.touchUpInside)
        self.view.addSubview(authView!)
    }
    
    func getUserItem () {
        ref = Database.database().reference(withPath: "User").child(authItem.uid)
        ref.observe(.value, with: { (snapshot) in
            self.userItem = UserModel(snapshot: snapshot )
            self.tableView.reloadData()
        })
    }
    
    func getUserOrders () {
        refOrder = Database.database().reference(withPath: "Order").child(authItem.uid)
        refOrder.queryOrdered(byChild: "date").observe(.value, with: { snapshot in
            var orderItems: [OrderModel] = []
            for item in snapshot.children {
                let groceryItem = OrderModel(snapshot: item as! DataSnapshot)
                orderItems.append(groceryItem)
            }
            self.orderArray = orderItems.sorted(by: { $0.date > $1.date })
            self.tableView.reloadData()
        })
    }
}
