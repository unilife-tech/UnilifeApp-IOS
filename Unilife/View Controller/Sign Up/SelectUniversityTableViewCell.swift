//
//  SelectUniversityTableViewCell.swift
//  Unilife
//
//  Created by Apple on 05/09/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class SelectUniversityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectUniversity_lbl: UILabel!
    
    @IBOutlet weak var selectUniversity_btn: UIButton!

    @IBOutlet weak var selectUniversityButton_Width: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
