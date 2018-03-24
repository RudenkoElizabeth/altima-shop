//
//  FullNewsViewController.swift
//  Altima
//
//  Created by Elizaveta Rudenko on 25.08.17.
//  Copyright © 2017 Altima. All rights reserved.
//

import UIKit

class FullNewsViewController: UIViewController {
    
    @IBOutlet weak var headingLable: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var text: UITextView!
    public var newsItem: NewsModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headingLable.text = newsItem?.title
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateLable.text =  dateFormatter.string(from: (newsItem?.date) ?? Date.init())
        text.text = newsItem?.text
    }
    
    override func viewDidLayoutSubviews() {
        self.text.setContentOffset(.zero, animated: false)
    }
}
