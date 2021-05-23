//
//  SeacrhGroupNameTableViewCell.swift
//  Unilife
//
//  Created by Apple on 07/10/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class SeacrhGroupNameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var groupName_lbl: UILabel!
    
    @IBOutlet weak var selectGroupName_btn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
