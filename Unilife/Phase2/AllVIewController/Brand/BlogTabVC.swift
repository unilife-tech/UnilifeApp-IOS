//
//  ViewController.swift
//  Trendy
//
//  Created by developer on 17/04/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit





class BlogTabVC: UIViewController {

  var blogsData : Blogs?
    @IBOutlet weak var viwNoRecord: UIView!
    @IBOutlet weak var collectionSlider: UICollectionView!
    @IBOutlet weak var collectionTeam: UICollectionView!
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var heightbl:NSLayoutConstraint?
    @IBOutlet weak var heighCollection:NSLayoutConstraint?
    @IBOutlet weak var topSliderIndicator_pageController: UIPageControl!
    @IBOutlet weak var viwEnter: UIView!
    @IBOutlet weak var viwShoping: UIView!
    @IBOutlet weak var viwLifeStyle: UIView!
    
    var arySlider:NSArray = NSArray()
   // var aryBrand:NSArray = NSArray()
    var aryTeam:NSArray = NSArray()
    var brandOffersData: UnilifeBrandModel?
    var type:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viwNoRecord.isHidden = true
        setTable()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        Connection_geBlogs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viwNoRecord.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        self.addNavigationBar(left: .Profile, titleType: .Normal, title: "Unilife Blogs", titlePosition: .Middle, right: .Icon, rightButtonIconOrTitle: "notification_Icon", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {
            
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
            self.collectionTeam?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
            
            viwEnter.layer.cornerRadius = 5
            viwShoping.layer.cornerRadius = 5
            viwLifeStyle.layer.cornerRadius = 5
            viwEnter.layer.masksToBounds = true
            viwShoping.layer.masksToBounds = true
            viwLifeStyle.layer.masksToBounds = true
            
       }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if(type == 0)
        {
                tbl?.layer.removeAllAnimations()
                heightbl?.constant = self.tbl?.contentSize.height ?? 0.0
                UIView.animate(withDuration: 0.5) {
                    self.loadViewIfNeeded()
                }
        }else
        {
            collectionTeam?.layer.removeAllAnimations()
            heighCollection?.constant = self.collectionTeam?.contentSize.height ?? 0.0
            UIView.animate(withDuration: 0.5) {
                self.loadViewIfNeeded()
            }
            
        }
          }
    
    @IBAction func click_View_Section(sender:UIButton)
      {
          
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBlogViewController") as! ViewAllBlogViewController
        vc.categoryId = self.blogsData?.blogs?[sender.tag].id ?? 0
        vc.isUserFromCategory = true
        vc.navigationTitle = self.blogsData?.blogs?[sender.tag].categoriesName ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
      }
      
      
      @IBAction func click_ViewALL(sender:UIButton)
      {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBlogViewController") as! ViewAllBlogViewController
        vc.condition = "viewAllCategory"
        vc.viewallblogs = self.blogsData?.blogs
        self.navigationController?.pushViewController(vc, animated: true)
        
      }
    
    @IBAction func tapCategories_btn(_ sender: Any) {
        
        guard let popoverContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewAllProductViewController") as? ViewAllProductViewController else {return}
        
        popoverContent.condition = ""
        
        popoverContent.blogCategoriesDetail = self.blogsData?.blogs
        
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
        
        let count = self.blogsData?.blogs?.count ?? 0
        
        var popoverHeight:Int = 0
        
        
        if count > 10 {
            
            popoverHeight = 11 * 50
            
        }else {
            
            popoverHeight = (count + 1) * 50
            
        }
        
        //let popoverHeight = (count - 1) * 50
        
        popoverContent.preferredContentSize = CGSize(width: 200, height: popoverHeight)
        
        let popOver = popoverContent.popoverPresentationController
        
        popoverContent.controller = self
        
        popOver?.delegate = self
        
        popOver?.sourceView = sender as! UIView
        
        popOver?.sourceRect = (sender as AnyObject).bounds
        
        popOver?.permittedArrowDirections = [.up]
        
        self.present(popoverContent, animated: true, completion: nil)
        
    }
      
    
    func tblViewALL(tag:Int)
    {
        
    }
    
    
    @IBAction func click_BottomCategory(sender:UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBlogViewController") as! ViewAllBlogViewController
        vc.categoryId = self.blogsData?.blogs?[sender.tag].id ?? 0
        vc.isUserFromCategory = true
        vc.navigationTitle = self.blogsData?.blogs?[sender.tag].categoriesName ?? ""
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
   
   
}

extension BlogTabVC:HomeTBLCollectionTapProtocol
{
    func didTapCollectionCell(section:Int,row:Int)
    {
        
        let getd:[Slider] = self.blogsData?.blogs?[section].categoriesBlog ?? [Slider]()
        let oneOBJ:Slider = getd[row]
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlogDetailViewController") as! BlogDetailViewController
        vc.condition = "blogs"
        vc.blogsData = oneOBJ
        self.navigationController?.pushViewController(vc, animated: true)
            
       
     
    }
}

extension BlogTabVC: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}

//------------------------------------------------------
// MARK: UIScrollViewDelegate   ------------------------------------------------------
//------------------------------------------------------

extension BlogTabVC:UIScrollViewDelegate
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



extension BlogTabVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == collectionTeam)
        {
            self.type = 1
            
            return self.blogsData?.team?.count ?? 0
        }
        return arySlider.count
        //return self.blogsData?.slider?.count ?? 0
        
        
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        if(collectionView == collectionTeam)
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandTeamCollectionCell", for: indexPath as IndexPath) as! BrandTeamCollectionCell
            
            cell.imgProduct.layer.cornerRadius = 98/2
            cell.imgProduct.layer.borderColor = UIColor.unilifeblueDark.cgColor
             cell.imgProduct.layer.borderWidth = 2.0
            
            cell.imgProduct.sd_setImage(with: URL(string: profileImageUrl + (self.blogsData?.team?[indexPath.row].image ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
            
            cell.lblName.text = self.blogsData?.team?[indexPath.row].name ?? ""
            
            return cell
        }else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandImageSliderCollectionCell", for: indexPath as IndexPath) as! BrandImageSliderCollectionCell
            
          //  cell.img.sd_setImage(with: URL(string: blogImageUrl + (self.blogsData?.slider?[indexPath.row].image ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
            
            
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
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView == collectionTeam)
        {
            return CGSize(width: (self.view.frame.width / 2) - 20 , height: 146)
        }else
        {
               return CGSize(width: self.view.frame.width , height: collectionView.frame.height)
        }
       }
       

  
}

//------------------------------------------------------
// MARK: Table Function     ------
//------------------------------------------------------


extension BlogTabVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.type = 0
        return self.blogsData?.blogs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "BlogTblCell") as! BlogTblCell
        
//        let getOBJ:NSDictionary = self.aryBrand.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
        cell.lblTitle.text = self.blogsData?.blogs?[indexPath.row].categoriesName ?? ""
        cell.btnViewAll.tag = indexPath.row
        cell.collectionAccess.reloadData()
        cell.DataForCollection = self.blogsData?.blogs?[indexPath.row].categoriesBlog ?? [Slider]()
        cell.collectionAccess.tag = indexPath.row
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
   
    
}






//MARK:- Web Services

extension BlogTabVC {
    
    func Connection_geBlogs() {
        
        Indicator.shared.showProgressView(self.view)
        
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "show_blog/\(UserData().userId)"){ [weak self](receviedData) in
            
            Indicator.shared.hideProgressView()
            print(receviedData)
            if Singleton.sharedInstance.connection.responseCode == 1 {
              
                if receviedData["response"] as? Bool == true {
                    
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: receviedData, options: .prettyPrinted)
                        
                        let unilifeBlogsData = try JSONDecoder().decode(Blogs.self , from: jsonData)
                        
                        self?.blogsData = unilifeBlogsData
                        self?.tbl.reloadData()
                        self?.collectionSlider.reloadData()
                        self?.topSliderIndicator_pageController.numberOfPages = self?.blogsData?.slider?.count ?? 0
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            self?.collectionTeam.reloadData()
                        }
                        
                        
                        if(self?.blogsData?.blogs?.count == 0)
                        {
                            self?.viwNoRecord.isHidden = false
                        }else
                        {
                            self?.viwNoRecord.isHidden = true
                        }
                        
                    } catch {
                        self?.showDefaultAlert(Message: error.localizedDescription)
                    }
                    
                    
                }else {
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No blogs found")
                }
                
                
                self?.connection_Header()
            }else {
                self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No blogs found")
                
            }
            
        }
    }
    
    
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
            "type":"blog"
        ]
        //  Indicator.shared.showProgressView(self.view)
        
        // print(params)
        //      print(ConstantsHelper.select_poll_option)
        WebServiceManager.shared.callWebService_Home(ConstantsHelper.HeaderImageBrandBlog, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
            
            
            
            if(response is NSDictionary)
            {
                
                //   print(response)
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
    
    
}
