//
//  FeedUserCell.swift
//  RUNDOWN
//
//  Created by developer on 12/07/19.
//  Copyright © 2019 RUNDOWN. All rights reserved.
//

import UIKit

class BlogTblCell: UITableViewCell {

    var delegate:HomeTBLCollectionTapProtocol?
    @IBOutlet weak var collectionAccess:UICollectionView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btnViewAll:UIButton!
    
    //var DataForCollection:NSArray = NSArray()
    var DataForCollection:[Slider] = [Slider]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
  @IBAction func Click_NewArrivalFav(sender:UIButton)
  {
    
//     let row = sender.tag % 1000
//     let section = sender.tag / 1000
//     self.delegate?.didFavTableCollectionCell(section: section, row: row)
        
    }
}




//------------------------------------------------------
// MARK: UICollectionView   ------
//------------------------------------------------------



extension BlogTblCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        
        return DataForCollection.count
        
        
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandTblCollectionCell", for: indexPath as IndexPath) as! BrandTblCollectionCell
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // Change `2.0` to the desired number of seconds.
//
//                       cell.imgProduct.layer.cornerRadius = 5
//                       cell.imgProduct.clipsToBounds = true
//                   }
           
 //           let getOBJ:NSDictionary = self.DataForCollection.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
      //      print(getOBJ)
        let getimageURl:String = DataForCollection[indexPath.row].image ?? ""
//        var discount_percent:Int = 0
//        let getBrandOffer:NSArray = getOBJ.value(forKey: "brand_offer") as? NSArray ?? NSArray()
//        if(getBrandOffer.count > 0)
//        {
//            let getofferIBJ:NSDictionary = getBrandOffer.object(at: 0) as? NSDictionary ?? NSDictionary()
//            getimageURl = getofferIBJ.value(forKey: "image") as? String ?? ""
//            discount_percent = getofferIBJ.value(forKey: "discount_percent") as? Int ?? 0
//        }
            
//            cell.lblProductName.text = getOBJ.value(forKey: "product_name") as? String ?? ""
//            let getPrice:String = getOBJ.value(forKey: "price") as? String ?? "0.00"
//            cell.lblPrice.text = getPrice + " SAR"
//            cell.lblType.text = getOBJ.value(forKey: "subcategory_name") as? String ?? ""
        
        cell.lblTitle.text = ""
        cell.lblDes.text = DataForCollection[indexPath.row].title
//            let getImageURL:String = getOBJ.value(forKey: "image") as? String ?? ""
//        print(getImageURL)
//        print("------->",offerImageUrl+getImageURL)
            if(getimageURl.count > 0)
                   {
                      // let fileUrl = URL(string: getImageURL)
                       
                     cell.imgProduct.sd_setImage(with: URL(string: blogImageUrl + getimageURl), placeholderImage: UIImage(named: "noimage"))
                   }else
                   {
                       cell.imgProduct.image = UIImage.init(named: "noImage")
                   }
        
        
        let lightcolor:UIColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        cell.viwOuter.layer.cornerRadius = 5
        cell.viwOuter.layer.borderColor = lightcolor.cgColor
        cell.viwOuter.layer.borderWidth = 0.5
            return cell
        
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return CGFloat(5)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
       
        return CGSize(width: self.bounds.size.width/3 + 50, height: self.collectionAccess.frame.size.height)
      
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didTapCollectionCell(section: collectionView.tag, row: indexPath.row)
        
    }
  
}
