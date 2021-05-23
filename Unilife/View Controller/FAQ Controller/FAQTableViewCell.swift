//
//  FAQTableViewCell.swift
//  Unilife
//
//  Created by Apple on 03/09/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class FAQTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionNumber_lbl: CircleLabel!

    @IBOutlet weak var questionName_lbl: UILabel!
    
    @IBOutlet weak var down_btn: UIButton!
    
    @IBOutlet weak var answer_lbl: UILabel!

    @IBOutlet weak var answerHeight_Constant: NSLayoutConstraint!
    
    
    

    override func awakeFromNib() {
        
        self.answerHeight_Constant.constant = 0
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
