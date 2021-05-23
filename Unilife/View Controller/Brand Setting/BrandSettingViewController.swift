//
//  BrandSettingViewController.swift
//  Unilife
//
//  Created by Apple on 28/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class BrandSettingViewController: UIViewController {
    
    
    // MARK: - Outlet
    
    @IBOutlet weak var viewBrandCoupons_btn: UIButton!
    
    @IBOutlet weak var savedBrandCoupons_btn: UIButton!
    
    @IBOutlet weak var redeemedBrandCoupons_btn: UIButton!
    
    
    @IBOutlet weak var sharedBrandCoupons_btn: UIButton!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = UIColor.appSkyBlue
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        
        self.navigationItem.largeTitleDisplayMode = .automatic
        
          self.navigationItem.largeTitleDisplayMode = .automatic
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Brand Settings", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
        
         self.tabBarController?.tabBar.isHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK: - Button Action
    
    
    @IBAction func tapViewBrandCoupons_btn(_ sender: Any) {
        
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "BrandCouponsViewController") as! BrandCouponsViewController
        
    self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBAction func savedBrandsCoupons_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SavedBrandCouponsViewController") as! SavedBrandCouponsViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBAction func redeemedBrandCoupons_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RedemeedBrandCouponViewController") as! RedemeedBrandCouponViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    @IBAction func sharedBasedCoupons_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SharedCouponViewController") as! SharedCouponViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    

    

}
