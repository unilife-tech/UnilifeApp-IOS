//
//  FeedUserCell.swift
//  RUNDOWN
//
//  Created by developer on 12/07/19.
//  Copyright © 2019 RUNDOWN. All rights reserved.
//

import UIKit

class HomePollCell: UITableViewCell {

    var delegate:PollTapProtocol?
    @IBOutlet weak var collectionAccess:UICollectionView!
    @IBOutlet weak var heightOFPollCollection:NSLayoutConstraint!
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblTime:UILabel!
    
    
    @IBOutlet weak var btnfavClick: UIButton!
    @IBOutlet weak var btnCommentClick: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnfav: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnThreeDot: UIButton!
  //  @IBOutlet weak var btnYes:UIButton!
  //  @IBOutlet weak var btnNo:UIButton!
    var DataForCollection:NSArray = NSArray()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension HomePollCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        
        return DataForCollection.count
        
        
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PollOptionCollectionCell", for: indexPath as IndexPath) as! PollOptionCollectionCell
        let getDic:NSDictionary = self.DataForCollection.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
        
        let getOption = getDic.value(forKey: "options") as? String ?? ""
        let selected = getDic.value(forKey: "selected") as? String ?? "no"
        let selected_count:Int = getDic.value(forKey: "selected_count") as? Int ?? 0
        
        if(selected == "yes")
        {
            cell.viwOuter.backgroundColor = UIColor.unilifeYesColor
            cell.btnOption.textColor = UIColor.white
        }else
        {
            cell.viwOuter.backgroundColor = UIColor.clear
            cell.btnOption.textColor = UIColor.black
        }
            cell.btnOption.text = getOption + ", \(selected_count)" + " Votes"
            cell.viwOuter.layer.borderColor = UIColor.unilifeYesColor.cgColor
            cell.viwOuter.layer.borderWidth = 2.0
            cell.viwOuter.layer.cornerRadius = 4
            return cell
        
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return CGFloat(5)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
       
        return CGSize(width: self.bounds.size.width/2, height: 50)
      
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didTapCollectionCell(section: collectionView.tag, row: indexPath.row)
        
    }
  
}
