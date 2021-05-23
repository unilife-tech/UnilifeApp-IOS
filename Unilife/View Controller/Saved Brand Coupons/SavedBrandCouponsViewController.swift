//
//  SavedBrandCouponsViewController.swift
//  Unilife
//
//  Created by Apple on 03/09/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class SavedBrandCouponsViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var savedBrand_CollectionView: UICollectionView!
    
    // MARK: - Variable
    
    var saveCoupon: SavedBrandCoupon?
    var  `var` : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    deinit {
        print(#file)
        
    self.saveCoupon = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Saved Brand Coupons ", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
        self.tabBarController?.tabBar.isHidden = true
        
        self.viewSavedBrandCoupon()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
}

extension SavedBrandCouponsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.saveCoupon?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.savedBrand_CollectionView.dequeueReusableCell(withReuseIdentifier: "BrandCouponsCollectionViewCell", for: indexPath) as! BrandCouponsCollectionViewCell
        
      cell.coupon_ImageView.sd_setImage(with: URL(string:  offerImageUrl + (self.saveCoupon?[indexPath.row].offerUserSaved?.image ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
        
        cell.couponName_lbl.text! = self.saveCoupon?[indexPath.row].offerUserSaved?.brandNameData?.brandName ?? ""
        
        cell.couponCode_lbl.text! = self.saveCoupon?[indexPath.row].offerUserSaved?.discountCode ?? ""
        
        cell.couponCode_lbl.isHidden = true 
        
        if self.saveCoupon?[indexPath.row].offerUserSaved?.type == "online" {
            
            cell.viewInStore_btn.isHidden = true
            cell.viewOnline_btn.isHidden = false
        }else if self.saveCoupon?[indexPath.row].offerUserSaved?.type == "instore" {
         cell.viewOnline_btn.isHidden = true
            cell.viewInStore_btn.isHidden = false
            
        }else {
            
            cell.viewInStore_btn.isHidden = false
            
            cell.viewOnline_btn.isHidden = false
        }
        
        cell.viewInStore_btn.tag = indexPath.row
        
        cell.viewInStore_btn.addTarget(self, action: #selector(tapInstore_btn(_:)), for: .touchUpInside)
        
        cell.viewOnline_btn.tag = indexPath.row
        
        cell.viewOnline_btn.addTarget(self, action: #selector(tapOnline_btn(_:)), for: .touchUpInside)
        
        cell.viewOnline_btn.titleLabel?.numberOfLines = 2
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: self.savedBrand_CollectionView.bounds.width / 2 - 10, height: 196)
    }
    
    // MARK: - Button Action
    
     @objc func tapInstore_btn(_ sender: UIButton) {
        
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "RedeemCouponViewController") as! RedeemCouponViewController
        
    vc.offer_id = self.saveCoupon?[sender.tag].offerID ?? 0
    
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapOnline_btn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RedeemCouponViewController") as! RedeemCouponViewController
        
        vc.offer_id = self.saveCoupon?[sender.tag].offerID ?? 0
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension SavedBrandCouponsViewController {
    func viewSavedBrandCoupon() {
        
        Indicator.shared.showProgressView(self.view)
        
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "user_list_saved_offer/\( UserData().userId)") {[weak self] (receviedData) in
            
            print(receviedData)
            
            guard let self = self else {
                return
            }
            
            Indicator.shared.hideProgressView()
            
            if  Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    guard let data = receviedData["data"] as? [[String: AnyObject]] else{
                        
                        return
                    }
                    
                    do{
                        
                        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        
                        self.saveCoupon = try?  JSONDecoder().decode(SavedBrandCoupon.self, from: jsonData!)
                        
                        self.savedBrand_CollectionView.delegate = self
                        
                        self.savedBrand_CollectionView.dataSource = self
                        self.savedBrand_CollectionView.register(UINib(nibName: "ViewBrandCoupons", bundle: nil), forCellWithReuseIdentifier: "BrandCouponsCollectionViewCell")
                        
                    } catch {
                        
                        print(error.localizedDescription)
                    }
                    
                    
                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ??  "" )
                }
                
            }else {
                
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["Error"] as? String ??  "" )
                
            }
            
        }
        
        
        
        
    }
    
    
}

