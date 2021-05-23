//
//  NewlyAddedOffersTableViewCell.swift
//  Unilife
//
//  Created by Apple on 26/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class NewlyAddedOffersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productName_lbl: UILabel!
    
    @IBOutlet weak var productDiscount_lbl: UILabel!
    
    @IBOutlet weak var producImage_View: SetImage!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
