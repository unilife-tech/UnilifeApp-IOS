//
//  TermsAndConditionTableViewCell.swift
//  Unilife
//
//  Created by Apple on 02/09/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class TermsAndConditionTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var termsConditions_lbl: UILabel!
    
    
    @IBOutlet weak var termsAndCondition_WebView: UIWebView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
