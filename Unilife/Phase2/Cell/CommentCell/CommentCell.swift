//
//  FeedUserCell.swift
//  RUNDOWN
//
//  Created by developer on 12/07/19.
//  Copyright © 2019 RUNDOWN. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

  @IBOutlet weak var viwOuter:UIView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblComment:UILabel!
    @IBOutlet weak var imgUserProfile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
