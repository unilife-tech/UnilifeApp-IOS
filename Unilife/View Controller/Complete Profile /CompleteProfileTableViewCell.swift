//
//  CompleteProfileTableViewCell.swift
//  Unilife
//
//  Created by promatics on 21/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class CompleteProfileTableViewCell: UITableViewCell {
    
    
    @IBOutlet var question_lbl: UILabel!
    
    @IBOutlet weak var selectCircle_ImageView: CircleImage!
    
    @IBOutlet weak var select_View: UIView!
    
    @IBOutlet weak var answer_TextView: GrowingTextView!
    
    @IBOutlet weak var selectDropDown_btn: UIButton!
    
    
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
