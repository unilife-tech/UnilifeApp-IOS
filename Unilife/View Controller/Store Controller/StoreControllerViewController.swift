//
//  StoreControllerViewController.swift
//  Unilife
//
//  Created by Apple on 03/09/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class StoreControllerViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var brandType_lbl: UILabel!
    
    @IBOutlet weak var instore_View: UIViewShadow!
    
    @IBOutlet weak var online_View: UIViewShadow!
    
    @IBOutlet weak var online_btn: UIButton!
    
    @IBOutlet weak var inStore_btn: UIButton!
    
    @IBOutlet weak var online_ImageView: UIImageView!
    
    @IBOutlet weak var inStore_ImageView: UIImageView!
    
    @IBOutlet weak var saveDeal_btn: SetButton!
    
    @IBOutlet weak var instoreProduct_ImageView: CircleImage!
    
    @IBOutlet weak var instoreUserName_lbl: UILabel!
    
    @IBOutlet weak var instoreUserEmail_lbl: UILabel!
    
    @IBOutlet weak var instoreProductDescription_lbl: UILabel!
    
    @IBOutlet weak var useManullay_btn: SetButton!
    
    @IBOutlet weak var share_btn: SetButton!
    
    @IBOutlet weak var coupon_label: UILabel!
    
    @IBOutlet weak var couponDescription_lbl: UILabel!
    
    @IBOutlet weak var instoreBrandId_lbl: UILabel!
    
    
    @IBOutlet weak var showCouponCode_lbl: UILabel!
    
    
    @IBOutlet weak var productDescriptionOnline_WebView: UIWebView!
    
    @IBOutlet weak var productDescriptionInStore_WebView: UIWebView!
    
    
    //do you
    
    // MARK: - Variable
    
    var offerData: Offers?
    
    var brandOfferData: Brand?
    
    var indexToBeView: Int = 0
    
    var condition = ""
    
    var navigationTitle = ""
    
    var offer_id = ""
    
    var buttonTypeCondition = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.online_View.isHidden = false
        
        self.saveDeal_btn.isHidden = false
        
        self.instoreProduct_ImageView.sd_setImage(with: URL(string: profileImageUrl + ( UserData().image)), placeholderImage: UIImage(named: "noimage_icon"))
        
        if condition == "online" {
            
            self.brandType_lbl.text! = self.brandOfferData?.brandName ?? ""
            
            self.brandType_lbl.isHidden = false
            
            self.instoreUserName_lbl.text! = UserData().name
            
            self.instoreUserEmail_lbl.text! = UserData().email
            
            self.instoreBrandId_lbl.text! = String(self.offerData?.discountPercent ?? 0) + "%"
            
            self.instoreProductDescription_lbl.text! = self.offerData?.offersDescription ?? ""
            
            self.productDescriptionInStore_WebView.loadHTMLString((self.offerData?.offersDescription ?? ""), baseURL: nil)
            
            self.saveDeal_btn.isHidden = true
            
            self.instore_View.isHidden = false
            self.online_View.isHidden = true
            self.inStore_btn.backgroundColor = UIColor.appSkyBlue
            //            self.inStore_btn.titleLabel?.textColor = UIColor.white
            self.inStore_btn.setTitleColor(UIColor.white, for: .normal)
            
            //  self.online_btn.titleLabel?.textColor = UIColor.appDarKGray
            
            
            self.online_btn.setTitleColor(UIColor.appDarKGray, for: .normal)
            
            self.inStore_ImageView.image = UIImage(named: "in-store-30")
            
            self.online_ImageView.image = UIImage(named: "online-gray-30")
            
            self.online_btn.backgroundColor = UIColor.white
            
            self.coupon_label.text = self.offerData?.discountCode
            
            
            self.couponDescription_lbl.text = self.offerData?.offersDescription ?? ""
            
            
            self.useManullay_btn.setTitle("Use in Store(Manually)", for: .normal)
            
            self.useManullay_btn.titleLabel?.numberOfLines = 2
            
            
        }else {
            
            self.saveDeal_btn.isHidden = false
            self.instore_View.isHidden = true
            
            self.online_View.isHidden = false
            
            self.online_btn.titleLabel?.textColor = UIColor.white
            self.inStore_btn.titleLabel?.textColor = UIColor.appDarKGray
            
            self.online_btn.backgroundColor = UIColor.appSkyBlue
            
            self.online_ImageView.image = UIImage(named: "online-60")
            
            self.inStore_btn.backgroundColor = UIColor.white
            self.inStore_ImageView.image = UIImage(named: "in-store-gray-30")
            
            self.coupon_label.text = self.offerData?.discountCode
            
            self.couponDescription_lbl.text = self.offerData?.offersDescription ?? ""
            
            self.productDescriptionOnline_WebView.loadHTMLString((self.offerData?.offersDescription ?? ""), baseURL: nil)
            
            self.brandType_lbl.isHidden = true
            
            if self.offerData?.offerSaved  != nil {
                
                self.saveDeal_btn.setTitle("Discard", for: .normal)
            }else {
                
                self.saveDeal_btn.setTitle("Save", for: .normal)
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addNavigationBar(left: .Back, titleType: .Normal, title: navigationTitle, titlePosition: .Middle, right: .Icon, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    deinit {
        print(#file)
    }
    
    // MARK: - button Action
    
    
    
    @IBAction func tapOnline_btn(_ sender: Any) {
        
        //
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OnlineControllerViewController") as! OnlineControllerViewController
        //
        //        vc.controller = self
        //        self.presentedViewController?.definesPresentationContext = true
        //        self.presentedViewController?.providesPresentationContextTransitionStyle = true
        
        self.saveDeal_btn.isHidden = false
        self.instore_View.isHidden = true
        
        self.online_View.isHidden = false
        
        self.online_btn.titleLabel?.textColor = UIColor.white
        self.inStore_btn.titleLabel?.textColor = UIColor.appDarKGray
        
        self.online_btn.backgroundColor = UIColor.appSkyBlue
        
        self.online_ImageView.image = UIImage(named: "online-60")
        
        self.inStore_btn.backgroundColor = UIColor.white
        self.inStore_ImageView.image = UIImage(named: "in-store-gray-30")
        
        
        // self.present(vc, animated: true, completion: nil)
        
    }
    
    
    @IBAction func tapInStore_btn(_ sender: Any) {
        
        //        self.dismiss(animated: true, completion: nil)
        //
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InStoreControllerViewController") as! InStoreControllerViewController
        //        vc.controller = self
        
        
        //        self.presentedViewController?.definesPresentationContext = true
        //        self.presentedViewController?.providesPresentationContextTransitionStyle = true
        
        self.saveDeal_btn.isHidden = true
        
        self.instore_View.isHidden = false
        self.online_View.isHidden = true
        self.inStore_btn.backgroundColor = UIColor.appSkyBlue
        self.inStore_btn.titleLabel?.textColor = UIColor.white
        self.online_btn.titleLabel?.textColor = UIColor.appDarKGray
        self.inStore_ImageView.image = UIImage(named: "in-store-30")
        
        self.online_ImageView.image = UIImage(named: "online-gray-30")
        
        self.online_btn.backgroundColor = UIColor.white
        
        //self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func tapSaveDeal_btn(_ sender: Any) {
        
        saveDeal()
    }
    
    @IBAction func tapShare_btn(_ sender: Any) {
        
        var text = ""
        
        if self.condition == "online" {
            
            text = self.offerData?.discountCode ?? ""
            
        }else {
            
             text = self.offerData?.link ?? ""
            
        }
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                
                self.sharedOffer(offer_id: String(self.offerData?.id ?? 0))
                
                
            }
        }
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func tapOpenWebsite_btn(_ sender: Any) {
        
        self.redeemOnlineCoupon(coupon_id: String(self.offerData?.id ?? 0))
        
    }
    
    
    
    @IBAction func tapRedeemCoupon_btn(_ sender: Any) {
        
        
        UIApplication.shared.openURL(NSURL(string: (self.offerData?.link ?? ""))! as URL)
        
        //self.redeemOnlineCoupon(coupon_id: String(self.offerData?.id ?? 0))
    }
}

extension StoreControllerViewController {
    
    // MARK: - Save Deal Service
    
    func saveDeal() {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId,"offer_id": String(self.offerData?.id ?? 0)] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "user_offer_saved", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    if ((receviedData as? [String: AnyObject])?["action"] as? String ?? "lauda") == "saved" {
                        
                        self?.saveDeal_btn.setTitle("Discard", for: .normal)
                    }else{
                        self?.saveDeal_btn.setTitle("Save", for: .normal)
                    }
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "")
                }
                
            }else {
                
                self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "")
                
            }
            
            
        }
        
    }
    
    // MARK: - Shared Coupon Listing
    
    func sharedOffer(offer_id: String) {
        
        let param = ["user_id": UserData().userId,"offer_id": offer_id] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "user_shared_offer", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            
            print(receviedData)
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self?.showAlertWithAction(Title: "Unilife", Message: "Offer shared successfully", ButtonTitle: "Ok"){
                        
                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "SharedCouponViewController") as! SharedCouponViewController

                        self?.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["message"] as? String ?? "No Data Found")
                }
                
            }else {
                
                self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["Error"] as? String ?? "No Data Found")
                
            }
            
        }
    }
    
    // MARK: Redeeem Coupon
    func redeemOnlineCoupon(coupon_id: String){
        
        Indicator.shared.showProgressView(self.view)
        let param = ["user_id": UserData().userId,"type": "online","coupon_id": coupon_id] as [String: AnyObject]
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "redeem_coupon", params: param as [String: AnyObject]){[weak self] (receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    //                    self.showAlertWithAction(Title: "Unilife", Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found", ButtonTitle: "Ok"){
                    
                    if self?.condition == "online" {
                        
                        self?.showCouponCode_lbl.text! = self?.offerData?.discountCode ?? ""
                        
                    }else {
                        UIApplication.shared.openURL(NSURL(string: (self?.offerData?.link ?? ""))! as URL)
                        
                    }
                    
                    //}
                    
                    
                }else {
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                
                self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
            }
            
        }
        
    }
    
}
