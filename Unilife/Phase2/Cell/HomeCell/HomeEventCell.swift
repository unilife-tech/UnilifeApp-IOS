//
//  FeedUserCell.swift
//  RUNDOWN
//
//  Created by developer on 12/07/19.
//  Copyright © 2019 RUNDOWN. All rights reserved.
//

import UIKit

class HomeEventCell: UITableViewCell {

  
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblTime:UILabel!
    @IBOutlet weak var lblMemberRegis:UILabel!
    @IBOutlet weak var lblDes:UILabel!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var btnRegis: UIButton!
    @IBOutlet weak var btnfavClick: UIButton!
    @IBOutlet weak var btnCommentClick: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnfav: UIButton!
    @IBOutlet weak var btnRegisCount: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnThreeDot: UIButton!
@IBOutlet weak var btnImageZoom: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
