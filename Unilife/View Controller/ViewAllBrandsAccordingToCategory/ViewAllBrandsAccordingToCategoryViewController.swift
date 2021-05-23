//
//  ViewAllBrandsAccordingToCategoryViewController.swift
//  Unilife
//
//  Created by Apple on 02/11/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class ViewAllBrandsAccordingToCategoryViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var viewAllBrandsCategory_CollectionView: UICollectionView!
    
    // MARK: - Variable
    
    var allOfferData : [Offer1]?
    var allOfferData2 : NSArray = NSArray()
    
    var navigationTitle = ""
    
    // MARK: - Default View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewAllBrandsCategory_CollectionView.delegate = self
        
        self.viewAllBrandsCategory_CollectionView.dataSource = self 
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Categories", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
    }
    
    
}

extension ViewAllBrandsAccordingToCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //return self.allOfferData?.count ?? 0
        return self.allOfferData2.count 
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.viewAllBrandsCategory_CollectionView.dequeueReusableCell(withReuseIdentifier: "ViewAllBrandsCollectionViewCell", for: indexPath) as! ViewAllBrandsCollectionViewCell
        let getDic:NSDictionary = allOfferData2.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
      //  print(getDic)
        
        //... nishant waiting image
       // cell.brand_ImageView.sd_setImage(with: URL(string: brandImageUrl +  (self.allOfferData?[indexPath.row].image ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
        
       // cell.brandName_lbl.text! = self.allOfferData?[indexPath.row].name ?? ""
        
      //  cell.brandDiscount_lbl.text! = ""
        let getimageURl = getDic.value(forKey:  "image") as? String ?? ""
        if(getimageURl.count > 0)
                   {
                       cell.brand_ImageView.sd_setImage(with: URL(string:getimageURl), placeholderImage: UIImage(named: "noimage"))
                   }else
                   {
                       cell.brand_ImageView.image = UIImage.init(named: "noImage")
                   }
        
        cell.brandName_lbl.text = getDic.value(forKey:  "category") as? String ?? ""
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.viewAllBrandsCategory_CollectionView.bounds.width / 2 - 10, height: self.viewAllBrandsCategory_CollectionView.bounds.width / 2 )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let getOBJ:NSDictionary = self.allOfferData2.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
       // print(getOBJ)
         let id:String = getOBJ.value(forKey: "categories_id") as? String ?? ""
         let getName:String = getOBJ.value(forKey: "category") as? String ?? ""
        // print(id)
         
         let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBrandsViewController") as! ViewAllBrandsViewController
         vc.condition = "offers"
         vc.categories_id = id//String(id ?? 0)
         vc.navigationTitle = getName
         self.navigationController?.pushViewController(vc, animated: true)
        
        /*
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBrandsViewController") as! ViewAllBrandsViewController
        
        vc.condition = ""
        
        //        vc.brandArray = self.allOfferData?.first?.categoriesBrand?[indexPath.row]
        
        let trendingOfferData = self.allOfferData?[indexPath.row].categoriesBrand
        
        let newData = trendingOfferData?.filter({$0.brandOffer?.filter({$0 != nil}) != nil })
        
        var brandOffear = [[BrandOffer]]()
        
        for i in 0..<(newData?.count ?? 0) {
            
            brandOffear.append((newData?[i].brandOffer!)! as [BrandOffer])
            
        }
        
        //   let kllaKllaIndexOfBrandOffer = brandOffear.flatMap({$0})
        
        vc.brandArray =  brandOffear.flatMap({$0})
        
        vc.navigationTitle = self.allOfferData?[indexPath.row].name ?? ""
        
        
        
        self.navigationController?.pushViewController(vc, animated: true)
        */
        
    }
    
}
