//
//  SharedCouponViewController.swift
//  Unilife
//
//  Created by Apple on 03/09/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class SharedCouponViewController: UIViewController {
    
    // MARK: - Outlet
    
    
    @IBOutlet weak var sharedCoupon_CollectionView: UICollectionView!
    
    // MARK: - Variable
    
    var sharedCouponData: SharedBrandModel?
    
    
    
    // MARK: - Default View
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // ViewBrandCoupons
    }
    
    deinit {
        
        print(#file)
        
        self.sharedCouponData = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Shared Brand Coupons ", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
        self.tabBarController?.tabBar.isHidden = true
        
        sharedCouponsListing()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
}

extension SharedCouponViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.sharedCouponData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.sharedCoupon_CollectionView.dequeueReusableCell(withReuseIdentifier: "BrandCouponsCollectionViewCell", for: indexPath) as! BrandCouponsCollectionViewCell
        
        
        cell.coupon_ImageView.sd_setImage(with: URL(string: offerImageUrl + (self.sharedCouponData?[indexPath.row].offerUserShared?.image ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
        
        cell.couponCode_lbl.text! = self.sharedCouponData?[indexPath.row].offerUserShared?.discountCode ?? ""
        
        cell.couponName_lbl.text! = self.sharedCouponData?[indexPath.row].offerUserShared?.brandNameData?.brandName ?? ""
        
        cell.couponCode_lbl.isHidden = true
        
        if self.sharedCouponData?[indexPath.row].offerUserShared?.type == "online" {
            
            cell.viewInStore_btn.isHidden = true
            cell.viewOnline_btn.isHidden = false
            
        }else if self.sharedCouponData?[indexPath.row].offerUserShared?.type == "instore" {
            
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
    
    // MARK: - Button Action
    
    @objc func tapInstore_btn(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RedeemCouponViewController") as! RedeemCouponViewController
        
        vc.offer_id = self.sharedCouponData?[sender.tag].offerID ?? 0
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapOnline_btn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RedeemCouponViewController") as! RedeemCouponViewController
        
        vc.offer_id = self.sharedCouponData?[sender.tag].offerID ?? 0
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: self.sharedCoupon_CollectionView.bounds.width / 2 - 10, height: 196)
    }
    
}

extension SharedCouponViewController {
    
    func sharedCouponsListing() {
        
        Indicator.shared.showProgressView(self.view)
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "user_list_shared_offer/\(UserData().userId)") {[weak self] (receviedData) in
            
            Indicator.shared.hideProgressView()
            
            guard let self = self else {
                return
            }
            
            
            print(receviedData)
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    guard let data = receviedData["data"] as? [[String: AnyObject]]else {
                        
                    return
                        
                    }
                    
                    do {
                    
                let json = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    
                        self.sharedCouponData = try JSONDecoder().decode(SharedBrandModel.self, from: json!)
                        
                        self.sharedCoupon_CollectionView.delegate = self
                        self.sharedCoupon_CollectionView.dataSource = self
                        self.sharedCoupon_CollectionView.register(UINib(nibName: "ViewBrandCoupons", bundle: nil), forCellWithReuseIdentifier: "BrandCouponsCollectionViewCell")
                        
                    self.sharedCoupon_CollectionView.reloadData()
                        
                    }catch {
                        
                    print(error.localizedDescription)
                    }
                    
                    
                }else {
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ??  "" )
                    
                }
                
            }else {
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ??  "" )
                
            }
            
            
        }
    }
    
}
