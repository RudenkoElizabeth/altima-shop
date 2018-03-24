//
//  OrderProductTableViewCell.swift
//  Altima
//
//  Created by Elizaveta Rudenko on 11.09.17.
//  Copyright © 2017 Altima. All rights reserved.
//

import UIKit

class OrderProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
