//
//  AllRealtedDiscountOffersViewController.swift
//  Unilife
//
//  Created by Apple on 02/11/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class AllRealtedDiscountOffersViewController: UIViewController {
    
    // MARK: - outlet
    
    @IBOutlet weak var allRealtedDiscount_CollectionView: UICollectionView!
    
    // MARK: - Variable
    
    var allOffersRealtedData: [Offers]?
    
    var brandName = ""
    
    // MARK: - Default View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.allRealtedDiscount_CollectionView.delegate = self
        
        self.allRealtedDiscount_CollectionView.dataSource = self

       self.allRealtedDiscount_CollectionView.register(UINib(nibName: "BrandOffersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BrandsOffersCollectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       self.addNavigationBar(left: .Back, titleType: .Normal, title: self.brandName, titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
    }

}

extension AllRealtedDiscountOffersViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
    return self.allOffersRealtedData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.allRealtedDiscount_CollectionView.dequeueReusableCell(withReuseIdentifier: "BrandsOffersCollectionViewCell", for: indexPath) as! BrandsOffersCollectionViewCell
        
        
        cell.brands_ImageView.sd_setImage(with: URL(string: offerImageUrl + (self.allOffersRealtedData?[indexPath.row].image ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
        
        if(self.allOffersRealtedData?[indexPath.row].discountType == "percentage"){
            cell.brandsDiscount_lbl.text = "Upto " + "\(self.allOffersRealtedData?[indexPath.row].discountPercent ?? 0) % off"
        }else{
            cell.brandsDiscount_lbl.text = "Upto " + "\(allOffersRealtedData?[indexPath.row].discountPercent ?? 0) off"
        }
        
        cell.brandsName_lbl.text = brandName
        
        return cell 
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: allRealtedDiscount_CollectionView.frame.width/2 - 5, height:  (allRealtedDiscount_CollectionView.frame.width/2 - 10))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "RedeemCouponViewController") as! RedeemCouponViewController
        
    vc.offer_id = self.allOffersRealtedData?[indexPath.row].id ?? 0
        
    self.navigationController?.pushViewController(vc, animated: true)
    }
  
    }
