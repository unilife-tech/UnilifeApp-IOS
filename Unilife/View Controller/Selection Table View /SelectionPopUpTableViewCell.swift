//
//  SelectionPopUpTableViewCell.swift
//  Unilife
//
//  Created by Apple on 09/09/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class SelectionPopUpTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectionPopName_lbl: UILabel!
    
    @IBOutlet weak var selectName_btn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
