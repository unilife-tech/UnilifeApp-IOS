//
//  GroupDetailTableViewCell.swift
//  Unilife
//
//  Created by Apple on 20/11/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class GroupDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var groupImage_View: CircleImage!
    
    @IBOutlet weak var groupName_lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
