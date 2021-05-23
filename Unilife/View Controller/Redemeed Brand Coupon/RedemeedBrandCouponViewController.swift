//
//  RedemeedBrandCouponViewController.swift
//  Unilife
//
//  Created by Apple on 03/09/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class RedemeedBrandCouponViewController: UIViewController {
    
    // MARKL: - Outlet
    
    @IBOutlet weak var redemeedBrandCoupon_CollectionView: UICollectionView!
    
    // MARK: - Variable
    
    var redeemedBrandsOfferListing : ListRedeemedBrandCouponModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.redemeedBrandCoupon_CollectionView.delegate = self
        self.redemeedBrandCoupon_CollectionView.dataSource = self
        self.redemeedBrandCoupon_CollectionView.register(UINib(nibName: "ViewBrandCoupons", bundle: nil), forCellWithReuseIdentifier: "BrandCouponsCollectionViewCell")
        
        self.redeedmBrandList()
        
        // ViewBrandCoupons
    }
    
    deinit {
        print(#file)
        
    self.redeemedBrandsOfferListing = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Redeemed Brand Coupons ", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
}

extension RedemeedBrandCouponViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.redeemedBrandsOfferListing?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.redemeedBrandCoupon_CollectionView.dequeueReusableCell(withReuseIdentifier: "BrandCouponsCollectionViewCell", for: indexPath) as! BrandCouponsCollectionViewCell
        
        cell.coupon_ImageView.sd_setImage(with: URL(string: offerImageUrl + (self.redeemedBrandsOfferListing?[indexPath.row].offerRedeem?.image ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
        
        cell.couponCode_lbl.text! = self.redeemedBrandsOfferListing?[indexPath.row].offerRedeem?.discountCode ?? ""
        
        cell.couponName_lbl.text! = self.redeemedBrandsOfferListing?[indexPath.row].offerRedeem?.brandNameData?.brandName ?? ""
        
        if self.redeemedBrandsOfferListing?[indexPath.row].offerRedeem?.type == "online" {
            
            cell.viewInStore_btn.isHidden = true
            cell.viewOnline_btn.isHidden = false
            
        }else if self.redeemedBrandsOfferListing?[indexPath.row].offerRedeem?.type == "instore" {
            
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
        
        
        return CGSize(width: self.redemeedBrandCoupon_CollectionView.bounds.width / 2 - 10, height: 196)
    }
    
    
    @objc func tapInstore_btn(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RedeemCouponViewController") as! RedeemCouponViewController
        
        vc.offer_id = self.redeemedBrandsOfferListing?[sender.tag].couponID ?? 0
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapOnline_btn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RedeemCouponViewController") as! RedeemCouponViewController
        
         vc.offer_id = self.redeemedBrandsOfferListing?[sender.tag].couponID ?? 0
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}


extension RedemeedBrandCouponViewController{
    
    func redeedmBrandList(){
        
        Indicator.shared.showProgressView(self.view)
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "user_list_redeem_offer/\(UserData().userId)"){[weak self] (receviedData) in
            
            guard let self = self else {
                return
            }
            
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    guard let data = receviedData["data"] as? [[String: AnyObject]]else{
                        
                        return
                    }
                    
                    do {
                        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        
                        self.redeemedBrandsOfferListing = try JSONDecoder().decode(ListRedeemedBrandCouponModel.self, from: jsonData!)
                        
                        self.redemeedBrandCoupon_CollectionView.reloadData()
                        
                    }catch{
                        
                        print(error.localizedDescription)
                    }
                    
                    
                }else {
                    
                   self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["message"] as? String ?? "No data found")
                }
                
            }else {
                
             self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["Error"] as? String ?? "No data found")
            }
            
            
        }
    }
}
