//
//  TrendingTableViewCell.swift
//  Unilife
//
//  Created by Apple on 26/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class TrendingTableViewCell: UITableViewCell {
    
    // MARK: - Outlet
    @IBOutlet weak var offerTitle_lbl: UILabel!
    
    @IBOutlet weak var viewAll_btn: SetButton!
    
    @IBOutlet weak var offers_CollectionView: UICollectionView!
    
    @IBOutlet weak var offerView_height: NSLayoutConstraint!
    
    @IBOutlet weak var offer_View: UIView!
    
    // MARK: - Variable
    
    var brandImageArray = [UIImage(named: "brand-3"), UIImage(named: "brand-4"), UIImage(named: "brand-5"), UIImage(named: "brand-6"), UIImage(named: "brand-7")]
    
    var brandDiscount = ["10% OFF", "20% OFF","30% OFF","10% OFF","20% OFF"]
    
    var brandArray : [BrandOffer]?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.offers_CollectionView.delegate = self
        
        self.offers_CollectionView.dataSource = self
        
        
        self.offers_CollectionView.register(UINib(nibName: "TrendingOfferCollectionView", bundle: nil), forCellWithReuseIdentifier: "TrendingCollectionViewCell")
        
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension TrendingTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (self.brandArray?.count ?? 0) > 6 {
            
        return 6
            
        }else {
        
        return brandArray?.count ?? 0
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        guard let cell = self.offers_CollectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCollectionViewCell", for: indexPath) as? TrendingCollectionViewCell else {
            
            return UICollectionViewCell()
        }
        
        
        cell.product_ImageView.sd_setImage(with: URL(string: offerImageUrl + (self.brandArray?[indexPath.row].image ?? ""))!, placeholderImage: UIImage(named: "noimage_icon"))
        
        
        if self.brandArray?[indexPath.row].discountPercent != nil  {
            
         cell.productDiscount_lbl.text! = ""
            
            
        }else {
            
             cell.productDiscount_lbl.text! = ""
        
//        cell.productDiscount_lbl.text! = String(describing: (self.brandArray[indexPath.row])["discount_percent"]!) + " % OFF"
        
        
        }
        return cell
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.offers_CollectionView.frame.height - 20, height: self.offers_CollectionView.frame.height)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    let vc = self.viewContainingController()?.storyboard?.instantiateViewController(withIdentifier: "RedeemCouponViewController") as! RedeemCouponViewController
        
    vc.offer_id = brandArray?[indexPath.row].id ?? 0
         self.viewContainingController()?.navigationController?.pushViewController(vc, animated: true)
        
    
        
        
    }
    
    
}

