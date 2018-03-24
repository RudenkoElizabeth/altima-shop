//
//  BasketTableViewCell.swift
//  Altima
//
//  Created by Elizaveta Rudenko on 30.08.17.
//  Copyright © 2017 Altima. All rights reserved.
//

import UIKit

protocol BasketStepperDelegate {
    
    func stepperButton(sender: BasketTableViewCell)
    
}

class BasketTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLable: UILabel!
    @IBOutlet weak var stepperValue: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    var delegate: BasketStepperDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func stepperButtonTapped(sender: UIStepper) {
        
        if delegate != nil {
            
            //print("row: \(sender.tag), value: \(sender.value)")
            delegate?.stepperButton(sender: self)
            stepperValue.text = "\(Int(stepper.value))"
            
        }
    }
}
