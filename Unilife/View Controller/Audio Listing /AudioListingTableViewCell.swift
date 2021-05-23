//
//  AudioListingTableViewCell.swift
//  Unilife
//
//  Created by Apple on 28/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class AudioListingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backGround_View: UIView!
    @IBOutlet weak var audio_ImageView: UIImageView!
    
    @IBOutlet weak var selectAudio_btn: UIButton!

    @IBOutlet weak var audioName_lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
