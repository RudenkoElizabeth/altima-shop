//
//  OrderTableViewCell.swift
//  Altima
//
//  Created by Elizaveta Rudenko on 30.08.17.
//  Copyright © 2017 Altima. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var statusLable: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLablel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
