//
//  ReplyCommentTableViewCell.swift
//  Unilife
//
//  Created by Apple on 24/09/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class ReplyCommentTableViewCell: UITableViewCell {
    
    // MARK: - Variable
    
    @IBOutlet weak var replyCommentProfile_ImageView: CircleImage!
    
    @IBOutlet weak var replyCommentUserName_lbl: UILabel!
    
    @IBOutlet weak var replyCommentUserTag_lbl: UILabel!
    
    @IBOutlet weak var heart_btn: UIButton!
    
    @IBOutlet weak var replyComment_lbl: UILabel!
    
    @IBOutlet weak var replyComment_StackView: UIStackView!
    
    @IBOutlet weak var replyCommentTime_lbl: UILabel!
    
    @IBOutlet weak var replyCommentLike_lbl: UILabel!
    
    @IBOutlet weak var replyCommentReply_btn: UIButton!
    
    @IBOutlet weak var viewAllReplyLike_btn: UIButton!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
