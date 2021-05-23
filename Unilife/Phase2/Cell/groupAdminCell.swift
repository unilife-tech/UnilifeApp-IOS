//
//  FeedUserCell.swift
//  RUNDOWN
//
//  Created by developer on 12/07/19.
//  Copyright © 2019 RUNDOWN. All rights reserved.
//

import UIKit

class groupAdminCell: UITableViewCell {

    @IBOutlet weak var imgUserProfile:UIImageView!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblType:UILabel!
    @IBOutlet weak var btnDelete:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
