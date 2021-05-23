//
//  NumberBrandOfferCollectionViewCell.swift
//  Unilife
//
//  Created by Apple on 31/10/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class NumberBrandOfferCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var brandOfferData : [BrandOffer]?
    
    var index = 0
    

    @IBOutlet weak var brandOffersRealatedCollection_View: UICollectionView!
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        
      return self.brandOfferData?.count ?? 0
        
      // return 4
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        
        let cell = brandOffersRealatedCollection_View.dequeueReusableCell(withReuseIdentifier: "BrandsOffersCollectionViewCell", for: indexPath) as! BrandsOffersCollectionViewCell
        
        
        
      //  cell.brands_ImageView.sd_setImage(with: URL(string: offerImageUrl +  (self.brandOfferData?[indexPath.row].image ?? "")), placeholderImage: UIImage(named: "noimage"))
        
        cell.brands_ImageView.sd_setImage(with: URL(string: offerImageUrl +  (self.brandOfferData?[indexPath.row].image ?? "")), placeholderImage: UIImage(named: "noimage_icon"), options: .highPriority) {(image, error, type, url) in
            
            
            
            let ratio = (image?.size.width ?? 1.0 )/(image?.size.height ?? 1.0)
            
            print(ratio)
            
             cell.brands_ImageView.image =  self.ResizeImage(image: image ?? UIImage(named: "noimage_icon")!, targetSize: CGSize(width: cell.brands_ImageView.frame.width , height: 142))
            
            //                let image = image ?? UIImage(named: "noimage_icon")!
            //
            //                let newImage = image.resize(withSize: CGSize(width: 300, height: 400), contentMode: .contentAspectFill)
            //
            //                self.userPost_ImageView.image = newImage
            
        }
        
        cell.brandsDiscount_lbl.text = String(self.brandOfferData?[indexPath.row].discountPercent ?? 0) + "% OFF"
        
        cell.brandsName_lbl.text! = self.brandOfferData?[indexPath.row].brandNameData?.brandName ?? ""
        
        return cell 
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.brandOffersRealatedCollection_View.frame.width/2 - 10, height: self.brandOffersRealatedCollection_View.frame.height/2 - 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    let vc = viewContainingController()?.storyboard?.instantiateViewController(withIdentifier: "RedeemCouponViewController") as! RedeemCouponViewController
        
    vc.offer_id = self.brandOfferData?[indexPath.row].id ?? 0
 viewContainingController()?.navigationController?.pushViewController(vc, animated: true)
        
    }
  
}

extension NumberBrandOfferCollectionViewCell{
    
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        
        let heightRatio = targetSize.height / image.size.height
        
        
        // Figure out what our orientation is, and use that to form the rectangle
        
        var newSize: CGSize
        
        if(widthRatio > heightRatio) {
            
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            
        } else {
            
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
            
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        
        image.draw(in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        print(newImage)
        
        return newImage ?? image
        
    }
}
