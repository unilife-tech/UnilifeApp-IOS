//
//  BrandCouponsViewController.swift
//  Unilife
//
//  Created by Apple on 03/09/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class BrandCouponsViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var brandsCoupon_CollectionView: UICollectionView!
    
    // MARK: - Variable
    
    var viewCouponData: ViewCouponsModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ViewBrandCoupons
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "View Brand Coupons ", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
        
        self.tabBarController?.tabBar.isHidden = true
        
        viewBrandCoupons()
        
    }
    
    deinit {
        print(#file)
        
    self.viewCouponData = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    
}

extension BrandCouponsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.viewCouponData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.brandsCoupon_CollectionView.dequeueReusableCell(withReuseIdentifier: "BrandCouponsCollectionViewCell", for: indexPath) as! BrandCouponsCollectionViewCell
        
        
        cell.coupon_ImageView.sd_setImage(with: URL(string:  offerImageUrl + (self.viewCouponData?[indexPath.row].offerUserView?.image ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
        
        cell.couponName_lbl.text! = self.viewCouponData?[indexPath.row].offerUserView?.brandNameData?.brandName ?? ""
        
        cell.couponCode_lbl.text! = self.viewCouponData?[indexPath.row].offerUserView?.discountCode ?? ""
        
        cell.couponCode_lbl.isHidden = true 
        
        if self.viewCouponData?[indexPath.row].offerUserView?.type == "online" {
            
            cell.viewInStore_btn.isHidden = true
            cell.viewOnline_btn.isHidden = false
            
        }else if self.viewCouponData?[indexPath.row].offerUserView?.type == "instore" {
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
        
        
        return CGSize(width: self.brandsCoupon_CollectionView.bounds.width / 2 - 10, height: 196)
    }
    
    @objc func tapInstore_btn(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RedeemCouponViewController") as! RedeemCouponViewController
        
        vc.offer_id = self.viewCouponData?[sender.tag].offerID ?? 0
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapOnline_btn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RedeemCouponViewController") as! RedeemCouponViewController
        
        vc.offer_id = self.viewCouponData?[sender.tag].offerID ?? 0
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}

extension BrandCouponsViewController{
    
    func viewBrandCoupons() {
        
        Indicator.shared.showProgressView(self.view)
         Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "user_list_view_offer/\(UserData().userId)") {[weak self] (receviedData) in
            
            print(receviedData)
            
            guard let self = self else {
                return
            }
            
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    guard let data = receviedData["data"] as? [[String: AnyObject]]else{
                        
                    return
                        
                    }
                    
                    do{
                    
                        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        
                    self.viewCouponData = try JSONDecoder().decode(ViewCouponsModel.self, from: jsonData!)
                        
                        self.brandsCoupon_CollectionView.reloadData()
                        
                        self.brandsCoupon_CollectionView.delegate = self
                        
                        self.brandsCoupon_CollectionView.dataSource = self
                        
                        
                        self.brandsCoupon_CollectionView.register(UINib(nibName: "ViewBrandCoupons", bundle: nil), forCellWithReuseIdentifier: "BrandCouponsCollectionViewCell")
                    }catch {
                    
                    print(error.localizedDescription)
                        
                    }
                   
                }else {
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
                
            }else {
           self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
                
            }
            
            
        }
        
        
    }
}
