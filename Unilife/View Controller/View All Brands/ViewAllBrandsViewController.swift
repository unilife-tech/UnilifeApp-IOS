//
//  ViewAllBrandsViewController.swift
//  Unilife
//
//  Created by Apple on 28/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class ViewAllBrandsViewController: UIViewController {
    
    // MARK: - outlet
    
    @IBOutlet weak var viewAllBrands_CollectionView: UICollectionView!
    
    // MARK: - Variable
    
    var navigationTitle = ""
    
    var brandImageArray = [UIImage(named: "brand-3"), UIImage(named: "brand-4"), UIImage(named: "brand-5"), UIImage(named: "brand-6"), UIImage(named: "brand-7")]
    
    var brandDiscount = ["10% OFF", "20% OFF","30% OFF","10% OFF","20% OFF"]
    
    var brandArray : [BrandOffer]?
    
    var brandArrayFromBlog : [BrandOffer]?
    
    var condition = ""
    
    var categories_id = ""
    
    var searchBrandData: SearchBrandModel?
    
    var search = ""
    
    var aryData:NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        if self.condition == "offers" {
            
           // self.viewAllBrand(categories_id: self.categories_id)
            self.connection_BrandList()
        }else if self.condition == "search" {
            
            self.searchBrand()
        }
        
        self.viewAllBrands_CollectionView.delegate = self
        
        self.viewAllBrands_CollectionView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        if self.condition == "search" {
            
            self.addNavigationBar(left: .Back, titleType: .Normal, title: "Search Brands Result", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
            
        }else {
            
            self.addNavigationBar(left: .Back, titleType: .Normal, title: navigationTitle, titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
            
        }
    }
    
    deinit {
        print(#file)
    }
    
}

extension ViewAllBrandsViewController: UICollectionViewDelegate,  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.condition == "offers" {
            
            //return brandArray?.count ?? 0
            return self.aryData.count ?? 0
            
            
        }else if self.condition == "ComingFromBlogPage" {
            
            return brandArrayFromBlog?.count ?? 0
        }else if self.condition == "search" {
            
            return self.searchBrandData?.count ?? 0
        }
        else {
            
            return brandArray?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.viewAllBrands_CollectionView.dequeueReusableCell(withReuseIdentifier: "ViewAllBrandsCollectionViewCell", for: indexPath) as! ViewAllBrandsCollectionViewCell
        
         //cell.brandName_lbl.isHidden = true 
        
        if self.condition == "offers" {
            let getDic:NSDictionary = self.aryData.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
            
            let getURL:String = getDic.value(forKey: "image") as? String ?? ""
                  if(getURL.count > 0)
                  {
                      //cell.img.sd_setImage(with: URL(string: offerImageUrl + getURL), placeholderImage: UIImage(named: "noimage"))
                        cell.brand_ImageView.sd_setImage(with: URL(string: getURL), placeholderImage: UIImage(named: "noimage"))
                  }else
                  {
                      cell.brand_ImageView.image = UIImage(named: "noimage")
                  }
            /*
            cell.brand_ImageView.sd_setImage(with: URL(string: offerImageUrl + (self.brandArray?[indexPath.row].image ?? ""))!, placeholderImage: UIImage(named: "noimage_icon"))
            
            
            if self.brandArray?[indexPath.row].discountPercent != nil  {
                
                cell.brandDiscount_lbl.text! = ""
                
                
            }else {
                
                cell.brandDiscount_lbl.text! = ""
                
                //        cell.productDiscount_lbl.text! = String(describing: (self.brandArray[indexPath.row])["discount_percent"]!) + " % OFF"
                
                
            }
            
            */
            
        }else if self.condition == "ComingFromBlogPage" {
            
            cell.brand_ImageView.sd_setImage(with: URL(string: offerImageUrl + (self.brandArrayFromBlog?[indexPath.row].image ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
            
            
            //            cell.blogName_lbl.text = self.offerData?[indexPath.row].title ?? ""
            
            
        } else if self.condition == "search" {
            
            
            cell.brand_ImageView.sd_setImage(with: URL(string: offerImageUrl + (self.searchBrandData?[indexPath.row].image ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
            
            
        }
            
        else {
            
            cell.brand_ImageView.sd_setImage(with: URL(string: offerImageUrl + (self.brandArray?[indexPath.row].image ?? ""))!, placeholderImage: UIImage(named: "noimage_icon"))
            
            
            if self.brandArray?[indexPath.row].discountPercent != nil  {
                
                cell.brandDiscount_lbl.text! = ""
                
                
            }else {
                
                cell.brandDiscount_lbl.text! = ""
                
                //        cell.productDiscount_lbl.text! = String(describing: (self.brandArray[indexPath.row])["discount_percent"]!) + " % OFF"
                
                
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RedeemCouponViewController") as! RedeemCouponViewController
        
        
        if self.condition == "offers" {
            
            let getDic:NSDictionary = self.aryData.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
            
            let id:String = getDic.value(forKey: "id") as? String ?? ""
            let brand_name:String = getDic.value(forKey: "brand_name") as? String ?? ""
            
           // vc.offer_id = self.brandArray?[indexPath.row].id ?? 0
            let vc = kPhase2toryBoard.instantiateViewController(withIdentifier: "BrandDetails") as! BrandDetails
            vc.getID = Int(id) ?? 0 //self.brandArray?[indexPath.row].brandID ?? 0
            vc.getTitle = brand_name//self.brandArray?[indexPath.row].brandNameData?.brandName ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
            
            
            
        }else if self.condition == "ComingFromBlogPage" {
            
            
            //            cell.brand_ImageView.sd_setImage(with: URL(string: offerImageUrl + (self.brandArrayFromBlog?[indexPath.row].image ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
            
            vc.offer_id = self.brandArrayFromBlog?[indexPath.row].id ?? 0
            
            //            cell.blogName_lbl.text = self.offerData?[indexPath.row].title ?? ""
             self.navigationController?.pushViewController(vc, animated: true)
        }else if self.condition == "search" {
            
            
            vc.offer_id = self.searchBrandData?[indexPath.row].id ?? 0
             self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else {
            
            vc.offer_id = self.brandArray?[indexPath.row].id ?? 0
             self.navigationController?.pushViewController(vc, animated: true)
        }
        
     //   self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width : self.viewAllBrands_CollectionView.bounds.width / 2 - 10, height:  self.viewAllBrands_CollectionView.bounds.width / 2)
    } 
    
    
    
}

extension ViewAllBrandsViewController {
    
    // MARK: - View All Brand According to category Id
    /*
    func viewAllBrand(categories_id: String) {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId,"categories_id": categories_id] as [String: AnyObject]
        
        print(param)
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "show_offer_categories", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            
            print(receviedData)
            
            guard let self = self else {
                return
            }
            
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true  {
                    
                    do {
                        
                        let jsondata = try? JSONSerialization.data(withJSONObject: receviedData["data"] as! [[String : AnyObject]], options: .prettyPrinted)
                        
                        let data = try? JSONDecoder().decode([BrandOffer].self, from: jsondata!)
                        
                        self.brandArray = data
                        
                        self.viewAllBrands_CollectionView.reloadData()
                        
                        self.viewAllBrands_CollectionView.delegate = self
                        
                        self.viewAllBrands_CollectionView.dataSource = self
                        
                        
                    }
                }else {
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
                
            }else {
                
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
            }
            
        }
    }
    */
    
    
    func connection_BrandList()
    {
        //.... check inter net
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            //print("Not connected")
            
            Singleton.sharedInstance.customAlert(getMSG: FAILED_INTERNET)
            
            return
        case .online(.wwan):
            print("")
        case .online(.wiFi):
            print("")
        }
        
        let params = [
            "category_id":self.categories_id
        ]
        //  Indicator.shared.showProgressView(self.view)
        
        // print(params)
        //      print(ConstantsHelper.select_poll_option)
        WebServiceManager.shared.callWebService_Home(ConstantsHelper.categories_wise_offers_data, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
            
            
            
            if(response is NSDictionary)
            {
                
                   print(response)
                let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                if(status == true)
                {
                   // banner
                    let listcat:NSArray  = (response as! NSDictionary).value(forKey: "categories") as? NSArray ?? NSArray()
                    if(listcat.count > 0)
                    {
                        let catDic:NSDictionary = listcat.object(at: 0) as? NSDictionary ?? NSDictionary()
                        self.aryData = catDic.value(forKey: "offers") as? NSArray ?? NSArray()
                    }
                   // self.aryData = (response as! NSDictionary).value(forKey: "banner") as? NSArray ?? NSArray()
                                 self.viewAllBrands_CollectionView.reloadData()
                                 
                                 self.viewAllBrands_CollectionView.delegate = self
                                 
                                 self.viewAllBrands_CollectionView.dataSource = self
                    
                    
                   // categories
                }else
                {
                    let getMessage = (response as! NSDictionary).value(forKey: "message") as? String ?? ""
                    Singleton.sharedInstance.customAlert(getMSG: getMessage)
                    
                }
                
                
            }else
            {
                //  Indicator.shared.hideProgressView()
                Singleton.sharedInstance.customAlert(getMSG: API_FAILED)
            }
            
            
        }
        
    }
    
    // MARK: - View Brand Data According To Search
    
    func searchBrand() {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId,"search": search] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "send_search_brand", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            print(receviedData)
            
            guard let self = self else {
                return
            }
            
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    guard let data = receviedData["data"] as? [[String: AnyObject]] else{
                        return
                        
                    }
                    
                    do {
                        
                        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        
                        self.searchBrandData = try? JSONDecoder().decode(SearchBrandModel.self, from: jsonData!)
                        
                        self.viewAllBrands_CollectionView.reloadData()
                        
                    }catch{
                        
                        print(error.localizedDescription)
                    }
                    
                    
                    
                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "")
                    
                    
                }
                
                
            }else {
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "")
                
            }
            
            
        }
        
    }
    
    
    
}
