//
//  DownloadTaskCellTableViewCell.swift
//  Unilife
//
//  Created by Apple on 25/11/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class DownloadTaskCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name:UILabel!
    
    @IBOutlet weak var progressBar:UIProgressView!
    
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var startBtn:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
