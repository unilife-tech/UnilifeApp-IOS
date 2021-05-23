//
//  LikesTableViewCell.swift
//  Unilife
//
//  Created by Apple on 05/10/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class LikesTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userProfile_ImageView: CircleImage!
    
    
    @IBOutlet weak var userName_lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
