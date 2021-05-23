//
//  ViewController.swift
//  Trendy
//
//  Created by developer on 17/04/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit


protocol HomeTBLCollectionTapProtocol: class {
    func didTapCollectionCell(section:Int,row:Int)
    
}



class BrandTabVC: UIViewController {


    @IBOutlet weak var viwNoRecord: UIView!
    @IBOutlet weak var collectionSlider: UICollectionView!
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var tblBottomCategory: UITableView!
    @IBOutlet weak var heightbl:NSLayoutConstraint?
    @IBOutlet weak var heightblBottomCategory:NSLayoutConstraint?
    @IBOutlet weak var topSliderIndicator_pageController: UIPageControl!
  //  @IBOutlet weak var viwEnter: UIView!
  //  @IBOutlet weak var viwShoping: UIView!
  //  @IBOutlet weak var viwLifeStyle: UIView!
    
    var arySlider:NSArray = NSArray()
    var aryBrand:NSArray = NSArray()
    var aryBottomCategory:NSArray = NSArray()
    var brandOffersData: UnilifeBrandModel?
    var typeLoad:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTable()
        self.navigationController?.navigationBar.prefersLargeTitles = false
       // Connection_getBtandData()
        viwNoRecord.isHidden = true
        connection_BrandList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viwNoRecord.isHidden = true
       // connection_BrandList()
        self.tabBarController?.tabBar.isHidden = false
        //self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        self.addNavigationBar(left: .Profile, titleType: .Normal, title: "Unilife Brands", titlePosition: .Middle, right: .Icon, rightButtonIconOrTitle: "notification_Icon", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationListingViewController") as! NotificationListingViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    
    func setTable()
          {
              tbl?.tableFooterView = UIView()
              tbl?.estimatedRowHeight = 44.0
              tbl?.rowHeight = UITableView.automaticDimension
              self.tbl?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
            self.tblBottomCategory?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
            
//            viwEnter.layer.cornerRadius = 5
//            viwShoping.layer.cornerRadius = 5
//            viwLifeStyle.layer.cornerRadius = 5
//            viwEnter.layer.masksToBounds = true
//            viwShoping.layer.masksToBounds = true
//            viwLifeStyle.layer.masksToBounds = true
            
       }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(typeLoad == 0)
        {
                tbl?.layer.removeAllAnimations()
                heightbl?.constant = self.tbl?.contentSize.height ?? 0.0
                UIView.animate(withDuration: 0.5) {
                    self.loadViewIfNeeded()
                }
        }else
        {
            tblBottomCategory?.layer.removeAllAnimations()
                          heightblBottomCategory?.constant = self.tblBottomCategory?.contentSize.height ?? 0.0
                          UIView.animate(withDuration: 0.5) {
                              self.loadViewIfNeeded()
                          }
        }
          }
    
    @IBAction func click_View_Section(sender:UIButton)
    {
        let getOBJ:NSDictionary = self.aryBrand.object(at: sender.tag) as? NSDictionary ?? NSDictionary()
       // print(getOBJ)
        let getName = getOBJ.value(forKey: "category") as? String ?? ""
        let getid = getOBJ.value(forKey: "categories_id") as? String ?? ""
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBrandsViewController") as! ViewAllBrandsViewController
        vc.condition = "offers"
        vc.categories_id = getid
        vc.navigationTitle = getName
        self.navigationController?.pushViewController(vc, animated: true)
        /*
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBrandsViewController") as! ViewAllBrandsViewController
        vc.condition = "offers"
        vc.categories_id = String(self.brandOffersData?.offer?[sender.tag].id ?? 0)
        vc.navigationTitle = self.brandOffersData?.offer?[sender.tag].name ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
        */
    }
    
    ////.. click view all category 
    @IBAction func click_ViewALL(sender:UIButton)
    {
       let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBrandsAccordingToCategoryViewController") as! ViewAllBrandsAccordingToCategoryViewController
        
        //vc.allOfferData = self.brandOffersData?.offer
        vc.allOfferData2 = self.aryBrand
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func tapCategories_btn(_ sender: Any) {
        
        guard let popoverContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewAllProductViewController") as? ViewAllProductViewController else {return}
        
        
        popoverContent.condition = "Brand"
        
        popoverContent.brandCategoriesDetail = self.brandOffersData?.offer
        popoverContent.brandCategoriesDetail2 = self.aryBrand
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
        
        var popoverHeight: Int = 0
        
        //let count = self.brandOffersData?.offer?.count ?? 0
        let count = self.aryBrand.count ?? 0
        
        if count > 10 {
            
        popoverHeight = 11 * 50
            
        }else {
        
        popoverHeight = (count + 1) * 50
            
        }
        
        popoverContent.preferredContentSize = CGSize(width: 200, height: popoverHeight)
        
        //        popoverContent.delegate = self
        //
        //        popoverContent.privacyFor = .story
        
        popoverContent.controller = self
        
        let popOver = popoverContent.popoverPresentationController
        
        popOver?.delegate = self
        
        popOver?.sourceView = sender as! UIView
        
        popOver?.sourceRect = (sender as AnyObject).bounds
        
        popOver?.permittedArrowDirections = [.up]
        
        self.present(popoverContent, animated: true, completion: nil)
        
    }
      
    
    func tblViewALL(tag:Int) {
            
            // vc.condition = "offers"
            if tag == 0 {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBrandsViewController") as! ViewAllBrandsViewController
                
              //  vc.brandArray = self.trendingOffers
                
                vc.navigationTitle = self.brandOffersData?.offer?[tag].name ?? ""
                
                self.navigationController?.pushViewController(vc, animated: true)
                
                
            }else if tag == 1 {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBrandsViewController") as! ViewAllBrandsViewController
                
             //   vc.brandArray = self.newlyAddedOffers
                
                vc.navigationTitle = self.brandOffersData?.offer?[tag].name ?? ""
                
                self.navigationController?.pushViewController(vc, animated: true)
                
                
            }else if tag == 2 {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBrandsViewController") as! ViewAllBrandsViewController
                
                vc.navigationTitle = self.brandOffersData?.offer?[tag].name ?? ""
                
               // vc.brandArray = self.brandRealtedOffers
                
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if tag == 3 {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBlogViewController") as! ViewAllBlogViewController
                
                vc.navigationTitle = self.brandOffersData?.blogs?.first?.categoriesName ?? ""
                
            //  vc.brandBlogData = self.brandOffersData?.blogs
                
                vc.isUserFromCategory = true
                
                vc.categoryId = self.brandOffersData?.blogs?.first?.id ?? 0
                
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBrandsAccordingToCategoryViewController") as! ViewAllBrandsAccordingToCategoryViewController
                
                vc.allOfferData = self.brandOffersData?.offer
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
            
            
            
        }
    
    
    @IBAction func click_BottomCategory(sender:UIButton)
       {
           let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBrandsViewController") as! ViewAllBrandsViewController
                  vc.condition = "offers"
                  vc.categories_id = String(self.brandOffersData?.offer?[sender.tag].id ?? 0)
                  vc.navigationTitle = self.brandOffersData?.offer?[sender.tag].name ?? ""
                  self.navigationController?.pushViewController(vc, animated: true)

       }
   
}

extension BrandTabVC:HomeTBLCollectionTapProtocol
{
    func didTapCollectionCell(section:Int,row:Int)
    {
        let getOBJ:NSDictionary = self.aryBrand.object(at: section) as? NSDictionary ?? NSDictionary()
        let getData:NSArray = getOBJ.value(forKey: "categories_brand") as? NSArray ?? NSArray()
        if(getData.count > 0)
        {
           
            let getBrandDetail:NSDictionary = getData.object(at: row) as? NSDictionary ?? NSDictionary()
            let getID:String = getBrandDetail.value(forKey: "id") as? String ?? ""
            let getName:String = getBrandDetail.value(forKey: "brand_name") as? String ?? ""
                             
            let vc = kPhase2toryBoard.instantiateViewController(withIdentifier: "BrandDetails") as! BrandDetails
            vc.getID = Int(getID) ?? 0
            vc.getTitle = getName
            self.navigationController?.pushViewController(vc, animated: true)
            
            /*
            let getBrandOffer:NSArray = getBrandDetail.value(forKey: "brand_offer") as? NSArray ?? NSArray()
                  if(getBrandOffer.count > 0)
                  {/*
                      let getofferIBJ:NSDictionary = getBrandOffer.object(at: 0) as? NSDictionary ?? NSDictionary()
                    let getID:Int = getofferIBJ.value(forKey: "id") as? Int ?? 0
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "RedeemCouponViewController") as! RedeemCouponViewController
                    vc.offer_id = getID
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    */
                    let getofferIBJ:NSDictionary = getBrandOffer.object(at: 0) as? NSDictionary ?? NSDictionary()
                    let brand_name_data:NSDictionary = getofferIBJ.value(forKey: "brand_name_data") as? NSDictionary ?? NSDictionary()
                    let getID:Int = getofferIBJ.value(forKey: "brand_id") as? Int ?? 0
                    let getName:String = brand_name_data.value(forKey: "brand_name") as? String ?? ""
                    
                    let vc = kPhase2toryBoard.instantiateViewController(withIdentifier: "BrandDetails") as! BrandDetails
                    vc.getID = getID
                    vc.getTitle = getName
                    self.navigationController?.pushViewController(vc, animated: true)

            }
            
            */
            
          
        }
        
    }
}

extension BrandTabVC: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}

//------------------------------------------------------
// MARK: UIScrollViewDelegate   ------------------------------------------------------
//------------------------------------------------------

extension BrandTabVC:UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.tag == 1000)
        {
            let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
            if let ip = self.collectionSlider.indexPathForItem(at: center) {
                self.topSliderIndicator_pageController.currentPage = ip.row
                
            }
        }
        
    }
}


//------------------------------------------------------
// MARK: UICollectionView   ------------------------------------------------------
//------------------------------------------------------



extension BrandTabVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arySlider.count
        
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandImageSliderCollectionCell", for: indexPath as IndexPath) as! BrandImageSliderCollectionCell
        let getDic:NSDictionary = self.arySlider.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
        
        let getURL:String = getDic.value(forKey: "image") as? String ?? ""
        if(getURL.count > 0)
        {
            //cell.img.sd_setImage(with: URL(string: offerImageUrl + getURL), placeholderImage: UIImage(named: "noimage"))
              cell.img.sd_setImage(with: URL(string: getURL), placeholderImage: UIImage(named: "noimage"))
        }else
        {
            cell.img.image = nil
        }
              
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           
          
               return CGSize(width: self.view.frame.width , height: collectionView.frame.height)
               
           
       }
       

  
}

//------------------------------------------------------
// MARK: Table Function     ------
//------------------------------------------------------


extension BrandTabVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == tbl)
        {
            self.typeLoad = 0
        return self.aryBrand.count
        }else
        {
            self.typeLoad = 1
            return self.aryBottomCategory.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == tbl)
               {
         let cell = tableView.dequeueReusableCell(withIdentifier: "BrandTblCell") as! BrandTblCell
        
        let getOBJ:NSDictionary = self.aryBrand.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
        cell.lblTitle.text = getOBJ.value(forKey: "category") as? String ?? ""
        cell.btnViewAll.tag = indexPath.row
        cell.collectionAccess.reloadData()
        cell.DataForCollection = getOBJ.value(forKey: "categories_brand") as? NSArray ?? NSArray()
        cell.collectionAccess.tag = indexPath.row
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
        }else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BlogTblCategoryCell") as! BlogTblCategoryCell
            
            let getOBJ:NSDictionary = self.aryBottomCategory.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
         //   print(getOBJ)
            let getimageURl:String = getOBJ.value(forKey: "image") as? String ?? ""
            let getName:String = getOBJ.value(forKey: "name") as? String ?? ""
            cell.lblTitle.text = getName
            if(getimageURl.count > 0)
            {
                // let fileUrl = URL(string: getImageURL)
                
                cell.imgBackground.sd_setImage(with: URL(string:getimageURl), placeholderImage: UIImage(named: "noimage"))
            }else
            {
                cell.imgBackground.image = UIImage.init(named: "noImage")
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == tblBottomCategory)
        {
            let getOBJ:NSDictionary = self.aryBottomCategory.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
            let id:String = getOBJ.value(forKey: "id") as? String ?? ""
            let getName:String = getOBJ.value(forKey: "name") as? String ?? ""
           // print(id)
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBrandsViewController") as! ViewAllBrandsViewController
            vc.condition = "offers"
            vc.categories_id = id//String(id ?? 0)
            vc.navigationTitle = getName
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
   
    
}




// MARK: - Service Response

extension BrandTabVC {
    
    // MARK: - Get Brand Data
    ///... not using this api
    func Connection_getBtandData() {
        
        Indicator.shared.showProgressView(self.view)
        
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "show_offers/\(UserData().userId)") {[weak self] (receviedData) in
            
            
            guard let self = self else {
                return
            }
            print(receviedData)
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    
                    if(receviedData is NSDictionary)
                    {
                      //  print(receviedData)
                        
                        //self.arySlider = receviedData["slider"] as? NSArray ?? NSArray()
                        self.aryBrand = receviedData["offer"] as? NSArray ?? NSArray()
                      //  print(self.aryBrand)
                      //  print(self.aryBrand.count)
                      //  self.collectionSlider.reloadData()
                        self.tbl.reloadData()
                        
                        if(self.aryBrand.count == 0)
                        {
                            self.viwNoRecord.isHidden = false
                        }else
                        {
                            self.viwNoRecord.isHidden = true
                        }
                        
                    }else
                    {
                          Singleton.sharedInstance.customAlert(getMSG: API_FAILED)
                    }
                    
                    Indicator.shared.hideProgressView()
                    
                    guard let data = receviedData as? [String: AnyObject]else {

                        return
                    }

                    do
                    {
                        let jsonData = try?JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                         self.brandOffersData = try JSONDecoder().decode(UnilifeBrandModel.self, from: jsonData!)
                    }catch {

                        print(error.localizedDescription)
                        Indicator.shared.hideProgressView()
                    }
                    
                }else {
                    
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["message"] as? String ?? "No Data Found ")
                    
                    Indicator.shared.hideProgressView()
                    
                }
                
                
                self.connection_Header()
            }else {
                
                
                
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["Error"] as? String ?? "No Data Found ")
                
                Indicator.shared.hideProgressView()
                
            }
            
        }
        
    }
    
    ///... not using this api
   func connection_Header()
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
           "type":"brand"
       ]
       //  Indicator.shared.showProgressView(self.view)
       
        print(params)
             print(ConstantsHelper.HeaderImageBrandBlog)
       WebServiceManager.shared.callWebService_Home(ConstantsHelper.HeaderImageBrandBlog, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
           
           
           
           if(response is NSDictionary)
           {
               
                  print(response)
               let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
               if(status == true)
               {
                   
                self.arySlider = (response as! NSDictionary).value(forKey: "data") as? NSArray ?? NSArray()
                self.collectionSlider.reloadData()
                self.topSliderIndicator_pageController.numberOfPages = self.arySlider.count
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
            "":""
        ]
        //  Indicator.shared.showProgressView(self.view)
        
        // print(params)
              print(ConstantsHelper.brand_dataList)
        WebServiceManager.shared.callWebService_Home(ConstantsHelper.brand_dataList, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
            
            
            
            if(response is NSDictionary)
            {
                
                   print(response)
                let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                if(status == true)
                {
                   // banner
                
                    self.arySlider = (response as! NSDictionary).value(forKey: "banner") as? NSArray ?? NSArray()
                    self.collectionSlider.reloadData()
                    self.topSliderIndicator_pageController.numberOfPages = self.arySlider.count
                  
                    // offer
                    self.aryBrand = (response as! NSDictionary).value(forKey: "offer") as? NSArray ?? NSArray()
                  self.aryBottomCategory = (response as! NSDictionary).value(forKey: "categories") as? NSArray ?? NSArray()
                    self.tbl.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.tblBottomCategory.reloadData()
                    }
                    if(self.aryBrand.count == 0)
                    {
                        self.viwNoRecord.isHidden = false
                    }else
                    {
                        self.viwNoRecord.isHidden = true
                    }
                    
                    
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
    
}


