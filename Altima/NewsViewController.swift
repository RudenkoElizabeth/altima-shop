//
//  NewsViewController.swift
//  Altima
//
//  Created by Elizaveta Rudenko on 21.08.17.
//  Copyright © 2017 Altima. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Kingfisher

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var items: [NewsModel] = []
    var ref: DatabaseReference! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "News")
        ref.queryOrdered(byChild: "date").observe(.value, with: { snapshot in
            var newItems: [NewsModel] = []
            for item in snapshot.children {
                let groceryItem = NewsModel(snapshot: item as! DataSnapshot)
                newItems.append(groceryItem)
            }
            self.items = newItems.sorted(by: { $0.date > $1.date })
            self.tableView.reloadData()
        })
        self.tableView.tableFooterView = UIView.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellNews") as! NewsTableViewCell
        let newsItem = items[indexPath.row]
        cell.newsTextLabel.text = newsItem.title
        let url = URL(string: newsItem.image)
        cell.newsImageView.kf.setImage(with: url)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let newsItem = items[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FullNewsViewController") as! FullNewsViewController
        vc.newsItem = newsItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
