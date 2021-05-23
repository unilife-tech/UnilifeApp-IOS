//
//  DrawerTableViewCell.swift
//  Unilife
//
//  Created by Apple on 29/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class DrawerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var drawer_ImageView: UIImageView!
    
    
    @IBOutlet weak var drawerName_lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
