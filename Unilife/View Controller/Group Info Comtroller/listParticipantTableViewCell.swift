//
//  listParticipantTableViewCell.swift
//  Unilife
//
//  Created by Promatics on 2/11/20.
//  Copyright © 2020 promatics. All rights reserved.
//

import UIKit

class listParticipantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var user_ImageView: SetImage!
    
    @IBOutlet weak var userName_lbl: UILabel!
    
    @IBOutlet weak var userStatus_lbl: UILabel!
    
    @IBOutlet weak var groupAdmin_btn: SetButton!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
