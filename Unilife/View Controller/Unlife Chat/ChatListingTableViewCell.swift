//
//  ChatListingTableViewCell.swift
//  Unilife
//
//  Created by Apple on 27/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class ChatListingTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var chatListingUser_ImageView: CircleImage!
    
    @IBOutlet weak var chatListingUser_btn: SetButton!
    
    @IBOutlet weak var chatListingUserName_lbl: UILabel!
    
    @IBOutlet weak var chatListingUserDescription_lbl: UILabel!
    
    @IBOutlet weak var userMessageCount_btn: SetButton!
    
    @IBOutlet weak var userProfile_btn: UIButton!
    
    @IBOutlet weak var selectUserImage_btn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
