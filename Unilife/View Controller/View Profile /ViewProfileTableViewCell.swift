//
//  ViewProfileTableViewCell.swift
//  Unilife
//
//  Created by promatics on 22/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class ViewProfileTableViewCell: UITableViewCell {
    
    
    @IBOutlet var description_ImageView: UIImageView!
    
    @IBOutlet var description_lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
