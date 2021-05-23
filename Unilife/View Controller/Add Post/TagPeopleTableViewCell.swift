//
//  TagPeopleTableViewCell.swift
//  Unilife
//
//  Created by Apple on 07/10/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class TagPeopleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tagPeopleUserName_lbl: UILabel!
    
    @IBOutlet weak var selctUserName_btn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
