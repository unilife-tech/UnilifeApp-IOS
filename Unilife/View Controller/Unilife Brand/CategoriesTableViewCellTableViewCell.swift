//
//  CategoriesTableViewCellTableViewCell.swift
//  Unilife
//
//  Created by Apple on 26/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class CategoriesTableViewCellTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryImage_ImgView: SetImage!
    @IBOutlet weak var categoryName_lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
