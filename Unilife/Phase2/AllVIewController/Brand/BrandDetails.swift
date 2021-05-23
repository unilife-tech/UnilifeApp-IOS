//
//  ViewController.swift
//  Trendy
//
//  Created by developer on 17/04/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit

class BrandDetails: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionHeader: UICollectionView!
    @IBOutlet weak var pageContr: UIPageControl!
    var timer:Timer!
    
    @IBOutlet weak var imgBrand: UIImageView!
    @IBOutlet weak var lbldes1: UILabel!
    @IBOutlet weak var lbldes2: UILabel!
    @IBOutlet weak var viwSegmentOuter: UIView!
    @IBOutlet weak var btnOnline: UIButton!
    @IBOutlet weak var btnStore: UIButton!
    
    @IBOutlet weak var viwOnline: UIView!
    @IBOutlet weak var viwStore: UIView!
    var aryOnline:NSArray = NSArray()
    var aryInstore:NSArray = NSArray()
    @IBOutlet weak var tblOnline: UITableView!
    @IBOutlet weak var tblInStore: UITableView!
    @IBOutlet weak var heightOFtblOnline: NSLayoutConstraint!
    @IBOutlet weak var heightOFtblInStore: NSLayoutConstraint!
    
    var aryData:[String] = [String]()//["1 Splash","Background2","background3","Background4","Background5","Background6"]
    var getTitle:String = ""
    var getID:Int = 0
    var currentindex:Int = 0
    
    var currentSEgmentIndex:Int = 0
    var typeTbl:Int = 0
    var selectdTBLIndex:Int = -1
    
    var fb:String = ""
    var insta:String = ""
    var tw:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = self.getTitle
            //    self.timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(timeaction), userInfo: nil, repeats: true)
        
        viwSegmentOuter.layer.borderColor = UIColor.unilifeblueDark.cgColor
        viwSegmentOuter.layer.borderWidth = 0.5
        updateUIofSegment()
        
        
        tblOnline?.tableFooterView = UIView()
        tblOnline?.estimatedRowHeight = 44.0
        tblOnline?.rowHeight = UITableView.automaticDimension
        self.tblOnline?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        tblInStore?.tableFooterView = UIView()
        tblInStore?.estimatedRowHeight = 44.0
        tblInStore?.rowHeight = UITableView.automaticDimension
        self.tblInStore?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        connection_BrandDetails()
        self.tabBarController?.tabBar.isHidden = true
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.pageContr.numberOfPages = aryData.count
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
           if(typeTbl == 0)
           {
           tblOnline?.layer.removeAllAnimations()
           heightOFtblOnline?.constant = self.tblOnline?.contentSize.height ?? 0.0
           UIView.animate(withDuration: 0.5) {
               self.loadViewIfNeeded()
               
           }
        }else
           {
            tblInStore?.layer.removeAllAnimations()
                      heightOFtblInStore?.constant = self.tblInStore?.contentSize.height ?? 0.0
                      UIView.animate(withDuration: 0.5) {
                          self.loadViewIfNeeded()
                          
                      }
        }
       }
       
    
    @objc func timeaction(){
        var isanimation:Bool = true
        if(currentindex == self.aryData.count - 1)
        {
            currentindex = 0
          isanimation = false
        }else
        {
             currentindex = currentindex + 1
        }
        
        let getindex = IndexPath(row: currentindex, section: 0)
        self.collectionHeader.scrollToItem(at: getindex, at: .left, animated: isanimation)
    }
    
    @IBAction func click_Back()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func click_Social(sender:UIButton)
    {
        var openURL:String = ""
        if(sender.tag == 0) ////... fb
        {
            openURL = self.fb
        }else if(sender.tag == 1)  ////... insta
        {
            openURL = self.insta
        }else   ///.... twir
        {
            openURL = self.tw
        }
        
        if(openURL.count > 0)
        {
            if(!openURL.isValidForUrl())
            {
                  openURL = "http://" + openURL
            }
            print(openURL)
           if let url = NSURL(string:openURL)
           {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }else
           {
           // self.localAlert(getMSG: msgInvalid)
            }
        }
        
    }
    @IBAction func click_Segment(sender:UIButton)
    {
        currentSEgmentIndex = sender.tag
        updateUIofSegment()
    }
    
    func updateUIofSegment()
    {
        
        
        if(currentSEgmentIndex == 0)
        {
            self.btnOnline.setTitleColor( UIColor.white, for: .normal)
            self.btnOnline.backgroundColor = UIColor.unilifeblueDark
            self.btnStore.setTitleColor(UIColor.unilifeblueDark, for: .normal)
            self.btnStore.backgroundColor = UIColor.white
            self.viwOnline.isHidden = false
            self.viwStore.isHidden = true

            self.btnOnline.setImage(UIImage.init(named: "dis_online"), for: .normal)
            self.btnStore.setImage(UIImage.init(named: "able_store"), for: .normal)
            self.tblOnline.reloadData()
        }else
        {
            self.btnOnline.setTitleColor( UIColor.unilifeblueDark, for: .normal)
            self.btnOnline.backgroundColor = UIColor.white
            self.btnStore.setTitleColor( UIColor.white, for: .normal)
            self.btnStore.backgroundColor = UIColor.unilifeblueDark
            self.viwOnline.isHidden = true
            self.viwStore.isHidden = false
            
            self.btnOnline.setImage(UIImage.init(named: "able_online"), for: .normal)
            self.btnStore.setImage(UIImage.init(named: "dis_store"), for: .normal)
            self.tblInStore.reloadData()
            
        }
        
        
    }
    
    
    ///... click section
    @IBAction func click_online_Section(sender:UIButton)
    {
        if(selectdTBLIndex == sender.tag)
        {
            selectdTBLIndex = -1
        }else
        {
            selectdTBLIndex = sender.tag
        }
        self.tblOnline.reloadData()
    }
   @IBAction func click_Store_Section(sender:UIButton)
    {
          if(selectdTBLIndex == sender.tag)
          {
              selectdTBLIndex = -1
          }else
          {
              selectdTBLIndex = sender.tag
          }
          self.tblInStore.reloadData()
    }

    ///...click button
    @IBAction func click_online_Redeem(sender:UIButton)
    {
        let getDic = self.aryOnline.object(at: sender.tag) as? NSDictionary ?? NSDictionary()
        
        let used_voucher = getDic.value(forKey: "used_voucher") as? String ?? ""
        if(used_voucher == "no")
        {
            let vc = kPhase2toryBoard.instantiateViewController(withIdentifier: "BrandRedeemVC") as! BrandRedeemVC
            vc.getID = getID
            vc.getTitle = getTitle
            vc.getDic = getDic
            self.navigationController?.pushViewController(vc, animated: true)
        }else
        {
            Singleton.sharedInstance.customAlert(getMSG: "Already Used")
        }
    }
    
    
    @IBAction func click_Store_Redeem(sender:UIButton)
    {
        let getDic = self.aryInstore.object(at: sender.tag) as? NSDictionary ?? NSDictionary()
        let used_voucher = getDic.value(forKey: "used_voucher") as? String ?? ""
        if(used_voucher == "no")
        {
            let vc = kPhase2toryBoard.instantiateViewController(withIdentifier: "SubmitInStoreRedeemVC") as! SubmitInStoreRedeemVC
            vc.getID = getID
            vc.getTitle = getTitle
            vc.getDic = getDic
            self.navigationController?.pushViewController(vc, animated: true)
        }else
        {
            Singleton.sharedInstance.customAlert(getMSG: "Already Used")
        }
    }
}




extension BrandDetails:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
         if(tableView == tblOnline)
                {
                    self.typeTbl = 0
                  return self.aryOnline.count
                }else
                {
                    self.typeTbl = 1
                    return self.aryInstore.count
                }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(tableView == tblOnline)
        {
            self.typeTbl = 0
            if(selectdTBLIndex == section)
            {
                 return 1
            }else
            {
                return 0
            }
        }else
        {
            self.typeTbl = 1
            if(selectdTBLIndex == section)
            {
                 return 1
            }else
            {
                return 0
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        var getDic:NSDictionary = NSDictionary()
           if(tableView == tblOnline)
           {
                    getDic = self.aryOnline.object(at: indexPath.section) as? NSDictionary ?? NSDictionary()
           }else
           {
                    getDic = self.aryInstore.object(at: indexPath.section) as? NSDictionary ?? NSDictionary()
           }
             
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrandOnlineStoreCell") as! BrandOnlineStoreCell
       print(getDic)
        let discount_message:String = getDic.value(forKey: "discount_message") as? String ?? ""
        let terms_condition:String = getDic.value(forKey: "terms_condition") as? String ?? ""
        let discountTExt:String = getDic.value(forKey: "description") as? String ?? ""
        cell.lblTitle.text = discount_message
        cell.lblDiscount.text = discountTExt.html2String
        
        cell.lblTerms.text = terms_condition.html2String
        cell.btnRedeem.tag = indexPath.section
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrandOnlineStoreSection") as! BrandOnlineStoreSection
        
        if section % 2 == 0 {
            cell.imgTitle.image = UIImage.init(named: "1as")
        } else {
            cell.imgTitle.image = UIImage.init(named: "2sq")
        }
        
        
        
        var getDic:NSDictionary = NSDictionary()
        if(tableView == tblOnline)
        {
            getDic = self.aryOnline.object(at: section) as? NSDictionary ?? NSDictionary()
        }else
        {
            getDic = self.aryInstore.object(at: section) as? NSDictionary ?? NSDictionary()
        }
      if(selectdTBLIndex == section)
      {
        cell.imgArrow.image = UIImage.init(named: "recordUpArrow")
        
      }else{
        
        cell.imgArrow.image = UIImage.init(named: "recordDownArrow")
        }
        
        cell.lblTitle.text = getDic.value(forKey: "heading") as? String ?? ""
        cell.btnSection.tag = section
        cell.selectionStyle = .none
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70//UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    
    
    
}









//------------------------------------------------------
// MARK: Collection View   ------
//------------------------------------------------------


extension BrandDetails:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.aryData.count
        
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandImageSliderCollectionCell", for: indexPath as IndexPath) as! BrandImageSliderCollectionCell
        let getnameimg:String = self.aryData[indexPath.row]
        cell.img.image = UIImage.init(named: getnameimg)
    
              
              /*
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
              
              */
              return cell
        
        
                
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: self.view.frame.width , height: collectionView.frame.height)
        
    
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//    }
}

//------------------------------------------------------
// MARK: UIScrollViewDelegate   ------------------------------------------------------
//------------------------------------------------------

extension BrandDetails:UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.tag == 1000)
        {
            let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
            if let ip = self.collectionHeader.indexPathForItem(at: center) {
                self.pageContr.currentPage = ip.row
                //self.currentPage = ip.row
            }
        }
        
    }
}
//------------------------------------------------------
// MARK: API     ------------------------------------------------------
//------------------------------------------------------

extension BrandDetails
{
    func connection_BrandDetails()
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
                "brand_id":self.getID//"51" // 48
            ]
            Indicator.shared.showProgressView(self.view)
        //ApplicationManager.instance.startloading()
      print(params)
            print(ConstantsHelper.brand_detail)
            WebServiceManager.shared.callWebService_Home(ConstantsHelper.brand_detail, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
                
              
                
                if(response is NSDictionary)
                {
                    
                   print(response)
                    let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                    if(status == true)
                    {
                        
                        let respoonseInside = (response as! NSDictionary).value(forKey: "data") as? NSArray ?? NSArray()
                        if(respoonseInside.count > 0)
                        {
                            
                            
                            let getData:NSDictionary = respoonseInside.object(at: 0) as? NSDictionary ?? NSDictionary()
                            
                            self.fb = getData.value(forKey: "facebook") as? String ?? ""
                            self.insta = getData.value(forKey: "instagram") as? String ?? ""
                            self.tw = getData.value(forKey: "twitter") as? String ?? ""
                            
                           // let name:String = getData.value(forKey: "brand_name") as? String ?? ""
                            let description:String = getData.value(forKey: "description") as? String ?? ""
                           // self.lbldes1.text = name
                            self.lbldes2.text = description.html2String
                            
                            let getimg:String = getData.value(forKey: "image") as? String ?? ""
                            if(getimg.count > 0)
                            {
                                self.imgBrand.sd_setImage(with: URL(string: getimg), placeholderImage: UIImage(named: "noimage_icon"))
                            }else
                            {
                                self.imgBrand.image = UIImage.init(named: "noimage_icon")
                            }
                            
                            self.aryOnline = getData.value(forKey: "online") as? NSArray ?? NSArray()
                            self.aryInstore = getData.value(forKey: "store") as? NSArray ?? NSArray()
                            self.selectdTBLIndex = -1
                            self.tblOnline.reloadData()
                              DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.tblInStore.reloadData()
                            }
                        }
                        
                      
                        
                    }else
                    {
                        let getMessage = (response as! NSDictionary).value(forKey: "message") as? String ?? ""
                       Singleton.sharedInstance.customAlert(getMSG: getMessage)
                        
                    }
                }else
                {
                    Indicator.shared.hideProgressView()
                    
                  
                    Singleton.sharedInstance.customAlert(getMSG: API_FAILED)
                }
                
                
            }
            
        }
}






