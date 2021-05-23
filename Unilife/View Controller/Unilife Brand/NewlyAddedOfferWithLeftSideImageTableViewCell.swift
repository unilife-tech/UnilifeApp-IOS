//
//  NewlyAddedOfferWithLeftSideImageTableViewCell.swift
//  Unilife
//
//  Created by Apple on 26/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class NewlyAddedOfferWithLeftSideImageTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var productImage_View: SetImage!
    
    @IBOutlet weak var productName_lbl: UILabel!
    
    @IBOutlet weak var productDiscount_lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
