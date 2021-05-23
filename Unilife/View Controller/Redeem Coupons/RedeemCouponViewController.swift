//
//  RedeemCouponViewController.swift
//  Unilife
//
//  Created by Apple on 02/09/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class RedeemCouponViewController: UIViewController, UISearchControllerDelegate, UIWebViewDelegate {
    
    // MARK: - Outlet
    
    @IBOutlet weak var productName_lbl: UILabel!
    
    @IBOutlet weak var product_ImageView: UIImageView!
    
    @IBOutlet weak var online_btn: UIButton!
    
    @IBOutlet weak var inStore_btn: UIButton!
    
    @IBOutlet weak var online_ImageView: UIImageView!
    
    @IBOutlet weak var inStore_ImageView: UIImageView!
    
    @IBOutlet weak var redeemedCoupon_View: UIViewShadow!
    
    @IBOutlet weak var discountViewTitle_lbl: UILabel!
    
    @IBOutlet weak var discountCouponProductDetail_lbl: UILabel!
    
    @IBOutlet weak var revealCode_btn: SetButton!
    
    @IBOutlet weak var termsCondition_btn: SetButton!
    
    @IBOutlet weak var termCondition_TableView: UITableView!
    
    @IBOutlet weak var realtedDiscount_View: UIView!
    
    @IBOutlet weak var viewAll_btn: SetButton!
    
    @IBOutlet weak var brands_CollectionView: UICollectionView!
    
    @IBOutlet weak var termsAndConditionTableView_height: NSLayoutConstraint!
    
    @IBOutlet weak var relatedDataView_height: NSLayoutConstraint!
    
    @IBOutlet weak var redemeedStatus_ImageView: UIImageView!
    
    @IBOutlet weak var couponDescription_webView: UIWebView!
    
    
    // MARK: - Variable
    
    var condition = "online"
    
    var offerData: [BrandOffer]?
    var indexToBeView: Int = 0
    
    var termsAndConditionsArray = [String]()
    
    var couponData: RedeemCoupon?
    
    var offer_id : Int = 0
    
    // MARK:- default Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.termCondition_TableView.delegate =  self
        
        self.termCondition_TableView.dataSource = self
        
        //        self.brands_CollectionView.delegate = self
        //
        //        self.brands_CollectionView.dataSource = self
        //
        //        self.brands_CollectionView.register(UINib(nibName: "BrandOffersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BrandsOffersCollectionViewCell")
        
        self.termsAndConditionsArray = ((self.offerData?[self.indexToBeView].termCondition ?? "").components(separatedBy: "\n")).filter({$0 != ""})
        
        self.termsAndConditionTableView_height.constant = CGFloat(100 * self.termsAndConditionsArray.count)
        
        // self.defaultSearchBar()
        
        self.termsAndConditionTableView_height.constant = 0
        
    }
    
    deinit {
        print(#file)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.redeeemCoupon()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    // MARK:- User Defined Functions
    
    func setData() {
        
        // if(self.condition == "offers" || self.condition == "") {
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: self.couponData?.brand?.brandName ?? "", titlePosition: .Middle, right: .Icon, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
        
        self.productName_lbl.text = self.couponData?.offers?.title ?? ""
        self.product_ImageView.sd_setImage(with: URL(string: offerImageUrl + (self.couponData?.offers?.image ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
        
        //            self.discountCouponProductDetail_lbl.text = (self.couponData?.offers?.termCondition ??  "").html2String
        self.discountCouponProductDetail_lbl.text = (self.couponData?.offers?.offersDescription ?? "")
        
        self.couponDescription_webView.loadHTMLString((self.couponData?.offers?.offersDescription ?? ""), baseURL: nil)
        
        if self.couponData?.brand?.brandOffer?.count == 0 {
            
            self.viewAll_btn.isHidden = true
        }
        
        
        if((self.couponData?.brand?.brandOffer?.count ?? 0) > 0 ) {
            self.realtedDiscount_View.isHidden = false
            
            self.relatedDataView_height.constant = 420
        }else {
            self.realtedDiscount_View.isHidden = true
            self.relatedDataView_height.constant = 0
        }
        
        
        if self.couponData?.offers?.offerRedeemUser != nil {
            
            self.redemeedStatus_ImageView.isHidden = false
        }else {
            self.redemeedStatus_ImageView.isHidden = true
            
        }
        self.buttondata()
        
    }
    
    func buttondata() {
        
        if self.couponData?.offers?.type == "online" {
            
            self.revealCode_btn.setTitle("Display Code", for: .normal)
            
            self.online_btn.titleLabel?.textColor = UIColor.white
            self.online_btn.backgroundColor = UIColor.appSkyBlue
            
            //
            //            self.inStore_btn.titleLabel?.textColor = UIColor.appDarKGray
            //            self.inStore_btn.backgroundColor = UIColor.white
            
            self.inStore_ImageView.isHidden = true
            
            self.inStore_btn.isHidden = true
            
            
            self.online_ImageView.image = UIImage(named: "online-60")
            // self.inStore_ImageView.image = UIImage(named: "in-store-gray-30")
            
            self.inStore_btn.isUserInteractionEnabled = false
            self.online_btn.isUserInteractionEnabled = true
            
        }else if self.couponData?.offers?.type == "instore"{
            
             self.revealCode_btn.setTitle("Show Unilife ID ", for: .normal)
            
            
            self.inStore_btn.backgroundColor = UIColor.appSkyBlue
            self.inStore_btn.titleLabel?.textColor = UIColor.white
            
            //            self.online_btn.backgroundColor = UIColor.white
            //            self.online_btn.titleLabel?.textColor = UIColor.appDarKGray
            
            self.inStore_ImageView.image = UIImage(named: "in-store-30")
            //            self.online_ImageView.image = UIImage(named: "online-gray-30")
            
            self.online_ImageView.isHidden = true
            
            self.online_btn.isHidden = true
            
            self.online_btn.isUserInteractionEnabled = false
            self.inStore_btn.isUserInteractionEnabled = true
            
        }else if (self.couponData?.offers?.type == "online_instore" ){
            
             self.revealCode_btn.setTitle("Display Code", for: .normal)
            
            
            self.online_btn.titleLabel?.textColor = UIColor.white
            self.inStore_btn.titleLabel?.textColor = UIColor.appDarKGray
            self.online_btn.backgroundColor = UIColor.appSkyBlue
            self.online_ImageView.image = UIImage(named: "online-60")
            self.inStore_btn.backgroundColor = UIColor.white
            self.inStore_ImageView.image = UIImage(named: "in-store-gray-30")
            
            self.online_btn.isUserInteractionEnabled = true
            self.inStore_btn.isUserInteractionEnabled = true
            
        }
        
    }
    
    // MARK: - Serach Bar Function
    
    func defaultSearchBar() {
        
        if #available(iOS 11.0, *) {
            let sc = UISearchController(searchResultsController: nil)
            sc.delegate = self
            let scb = sc.searchBar
            scb.tintColor = UIColor.appDarKGray
            scb.barTintColor = UIColor.white
            scb.placeholder = "Search for Coupons & More"
            
            if let textfield = scb.value(forKey: "searchField") as? UITextField {
                textfield.textColor = UIColor.blue
                if let backgroundview = textfield.subviews.first {
                    
                    // Background color
                    backgroundview.backgroundColor = UIColor.white
                    
                    // Rounded corner
                    backgroundview.layer.cornerRadius = 10;
                    backgroundview.clipsToBounds = true;
                }
            }
            
            if let navigationbar = self.navigationController?.navigationBar {
                navigationbar.barTintColor = UIColor.white
            }
            navigationItem.searchController = sc
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    // MARK: - Button Action
    
    @IBAction func tapOnline_btn(_ sender: Any) {
        
          self.revealCode_btn.setTitle("Display Code", for: .normal)
        
        self.online_btn.titleLabel?.textColor = UIColor.white
        self.online_btn.backgroundColor = UIColor.appSkyBlue
        
        
        self.inStore_btn.titleLabel?.textColor = UIColor.appDarKGray
        self.inStore_btn.backgroundColor = UIColor.white
        
        
        self.online_ImageView.image = UIImage(named: "online-60")
        self.inStore_ImageView.image = UIImage(named: "in-store-gray-30")
        
    }
    
    
    @IBAction func tapInStore_btn(_ sender: Any) {
        
         self.revealCode_btn.setTitle("Show Unilife ID ", for: .normal)
        
        self.inStore_btn.backgroundColor = UIColor.appSkyBlue
        self.inStore_btn.titleLabel?.textColor = UIColor.white
        
        self.online_btn.backgroundColor = UIColor.white
        self.online_btn.titleLabel?.textColor = UIColor.appDarKGray
        
        self.inStore_ImageView.image = UIImage(named: "in-store-30")
        self.online_ImageView.image = UIImage(named: "online-gray-30")
        
    }
    
    @IBAction func tapRevealedCoupon_btn(_ sender: Any) {
        
        if self.revealCode_btn.currentTitle == "Show Unilife ID " {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "StoreControllerViewController") as! StoreControllerViewController
            vc.offerData = self.couponData?.offers
            vc.brandOfferData = self.couponData?.brand
            vc.indexToBeView = self.indexToBeView
            vc.navigationTitle = self.couponData?.brand?.brandName ?? ""
            //vc.offer_id = String(self.offer_id)
            
            if self.revealCode_btn.currentTitle == "Show Unilife ID " {
                
                vc.condition = "online"
                
            }else {
                
                vc.condition = ""
                
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else {
            
            self.redeemInstoreCoupon(type: "instore", coupon_id: String(self.offer_id))
            
        }
        
    }
    
    @IBAction func tapTermsAndCondition_btn(_ sender: Any) {
        
      
        
        if self.termCondition_TableView.isHidden {
            
            self.termCondition_TableView.isHidden = false
            
            //self.termsAndConditionTableView_height.constant = 110
              self.findTableSize()
            
        }else {
            
            self.termCondition_TableView.isHidden = true
            self.termsAndConditionTableView_height.constant = 0
            
        }
    }
    
    
    @IBAction func tapViewAll_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AllRealtedDiscountOffersViewController") as! AllRealtedDiscountOffersViewController
        vc.allOffersRealtedData = self.couponData?.brand?.brandOffer
        
        vc.brandName = self.couponData?.brand?.brandName ?? ""
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Find Content Size of Table
    
    func findTableSize(){
        var frame = self.termCondition_TableView.frame
        frame.size.height = self.termCondition_TableView.contentSize.height
        self.termCondition_TableView.frame = frame
        self.termCondition_TableView.reloadData()
        self.termCondition_TableView.layoutIfNeeded()
        self.termsAndConditionTableView_height.constant = CGFloat(self.termCondition_TableView.contentSize.height)
    }
    
}

extension RedeemCouponViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.termCondition_TableView.dequeueReusableCell(withIdentifier:"TermsAndConditionTableViewCell") as! TermsAndConditionTableViewCell
        cell.termsAndCondition_WebView.loadHTMLString((self.couponData?.offers?.termCondition ?? ""), baseURL: nil)
        
        cell.termsConditions_lbl.text =  (self.couponData?.offers?.termCondition ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
         return UITableView.automaticDimension
    }
    
    
}


extension RedeemCouponViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if((self.couponData?.brand?.brandOffer?.count ?? 0) > 4){
            
            
            return 4
        }else{
            return self.couponData?.brand?.brandOffer?.count ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.brands_CollectionView.dequeueReusableCell(withReuseIdentifier: "BrandsOffersCollectionViewCell", for: indexPath) as! BrandsOffersCollectionViewCell
        
        cell.brands_ImageView.sd_setImage(with: URL(string: offerImageUrl + (self.couponData?.brand?.brandOffer?[indexPath.row].image ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
        
        if(self.offerData?[indexPath.row].discountType == "percentage"){
            cell.brandsDiscount_lbl.text = "Upto " + "\(self.couponData?.brand?.brandOffer?[indexPath.row].discountPercent ?? 0) % off"
        }else{
            cell.brandsDiscount_lbl.text = "Upto " + "\(self.couponData?.brand?.brandOffer?[indexPath.row].discountPercent ?? 0) off"
        }
        
        cell.brandsName_lbl.text = self.couponData?.brand?.brandName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: brands_CollectionView.frame.width/2 - 5, height:  (brands_CollectionView.frame.width/2 - 10))
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RedeemCouponViewController") as! RedeemCouponViewController
        
        vc.offer_id = self.couponData?.brand?.brandOffer?[indexPath.row].id ?? 0
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}

extension RedeemCouponViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    
    // MARK: - Coupon Service Response
    
    func redeeemCoupon() {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId,"offer_id": self.offer_id] as [String: AnyObject]
        
        print(param)
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "show_single_offer_detail", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            
            print(receviedData)
            
            guard let self = self else {
                return
            }
            
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    print(receviedData)
                    do {
                        
                        let json = try? JSONSerialization.data(withJSONObject: receviedData as? [String : Any] as Any, options: .prettyPrinted)
                        
                        let data = try? JSONDecoder().decode(RedeemCoupon.self, from: json!)
                        
                        self.couponData = data
                        
                        self.setData()
                        
                        self.brands_CollectionView.delegate = self
                        
                        self.brands_CollectionView.dataSource = self
                        
                        self.brands_CollectionView.register(UINib(nibName: "BrandOffersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BrandsOffersCollectionViewCell")
                        
                        self.viewBrandOffer(offer_id: String(self.offer_id))
                        
                    }catch {
                        
                        print(error.localizedDescription)
                        
                        Indicator.shared.hideProgressView()
                        
                    }
                    
                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                    
                }
                
                
            }else {
                
                self.showDefaultAlert(Message: receviedData["Error"] as! String)
            }
            
            
        }
    }
    
    
    // MARK: - View Brand Offer
    
    func viewBrandOffer(offer_id: String){
        
        let param = ["user_id": UserData().userId,"offer_id": offer_id] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "user_view_offer", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            
            print(receviedData)
            
            guard let self = self else {
                return
            }
            
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    
                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
                
            }else {
                
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
            }
            
            
        }
        
    }
    
    
    // MARK: - Redeem Coupon
    
    func redeemInstoreCoupon(type: String, coupon_id: String){
        
        Indicator.shared.showProgressView(self.view)
        let param = ["user_id": UserData().userId,"type": type,"coupon_id": coupon_id] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "redeem_coupon", params: param as [String: AnyObject]){[weak self] (receviedData) in
            
            print(receviedData)
            
            guard let self = self else {
                return
            }
            
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    
//                    self.showAlertWithAction(Title: "Unilife", Message: ((receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found"), ButtonTitle: "Ok"){
                    
                        if ((receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found") == "Offer is already redeemed" {
                            
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "StoreControllerViewController") as! StoreControllerViewController
                            vc.offerData = self.couponData?.offers
                            vc.brandOfferData = self.couponData?.brand
                            vc.indexToBeView = self.indexToBeView
                            vc.navigationTitle = self.couponData?.brand?.brandName ?? ""
                            //vc.offer_id = String(self.offer_id)
                            
                            if self.revealCode_btn.currentTitle == "Show Unilife ID " {
                                
                                vc.condition = "online"
                                
                            }else {
                                
                                vc.condition = ""
                                
                            }
                        
                         self.navigationController?.pushViewController(vc, animated: true)
                        }else {
                        
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StoreControllerViewController") as! StoreControllerViewController
                        vc.offerData = self.couponData?.offers
                        vc.brandOfferData = self.couponData?.brand
                        vc.indexToBeView = self.indexToBeView
                        vc.navigationTitle = self.couponData?.brand?.brandName ?? ""
                        //vc.offer_id = String(self.offer_id)
                        
                        if self.revealCode_btn.currentTitle == "Show Unilife ID " {
                            
                            vc.condition = "online"
                            
                        }else {
                            
                            vc.condition = ""
                            
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                        
                    //}
                    
                    
                }else {
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
            }
            
        }
        
        
        
    }
    
}



