//
//  RequestReceivedPopUpTableViewCell.swift
//  Unilife
//
//  Created by Apple on 30/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class RequestReceivedPopUpTableViewCell: UITableViewCell {
    
    @IBOutlet weak var differentName_lbl: UILabel!
    
    @IBOutlet weak var select_btn: UISwitch!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
