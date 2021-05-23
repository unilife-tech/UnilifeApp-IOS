//
//  EventsCollectionCell.swift
//  RUNDOWN
//
//  Created by developer on 14/07/19.
//  Copyright © 2019 RUNDOWN. All rights reserved.
//

import UIKit

class RegisSearchUserCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var btnAddFriend: UIButton!
    @IBOutlet weak var btnNotINSchool: UIButton!
    
     override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
       }
   
       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)
   
           // Configure the view for the selected state
       }

}


