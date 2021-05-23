//
//  NotificationListingTableViewCell.swift
//  Unilife
//
//  Created by Apple on 02/12/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class NotificationListingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage_View: CircleImage!
    
    @IBOutlet weak var userName_lbl: UILabel!
    
    @IBOutlet weak var userNotificationDescription_lbl: UILabel!
    
    @IBOutlet weak var notificationDate_lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
