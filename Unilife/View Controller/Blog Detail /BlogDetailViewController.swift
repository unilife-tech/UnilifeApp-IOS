//
//  BlogDetailViewController.swift
//  Unilife
//
//  Created by Apple on 28/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class BlogDetailViewController: UIViewController, UIWebViewDelegate {
    
    // MARK: - Outlet
    
    @IBOutlet weak var save_btn: SetButton!
    
    @IBOutlet weak var blog_ImageView: UIImageView!
    
    @IBOutlet weak var blogTitle_lbl: UILabel!
    
    @IBOutlet weak var blogFull_ImageView: UIImageView!
    
    @IBOutlet weak var blogDescription_lbl: UILabel!
    
    @IBOutlet weak var blogSave_btn: SetButton!
    
    @IBOutlet weak var blogLike_btn: SetButton!
    
    @IBOutlet weak var blogLink_lbl: UILabel!
    
    @IBOutlet weak var blogTime_lbl: UILabel!
    
    @IBOutlet weak var blogDetail_WebView: UIWebView!
    @IBOutlet weak var heightOFWeb: NSLayoutConstraint!
    
    // MARK: - Variable
    
    var nav: UINavigationController!
    
    var condition = "blogs"
    
    var blogsData : Slider?
    
    var newOfferData : CategoriesBlog?
    
    var viewSearchBlogData: SearchBlog?
    
    var viewBlogFromBrand: CategoriesBlog1?
    
    var navigationTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        if(self.condition == "blogs"){
            
            self.addNavigationBar(left: .Back, titleType: .Normal, title: self.blogsData?.title ?? "", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
            
            self.setData()
            
        }else if(self.condition == "viewallBlogs") {
            
            self.addNavigationBar(left: .Back, titleType: .Normal, title: self.newOfferData?.title ?? "", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
            self.setData()
            
        }else {
            
            self.addNavigationBar(left: .Back, titleType: .Normal, title: navigationTitle, titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
            self.setData()
        }
        
        
    }
    
    // MARK: - Set Data
    
    func setData() {
        
        if(self.condition == "blogs"){
            
            self.blogFull_ImageView.sd_setImage(with: URL(string: blogImageUrl + (self.blogsData?.image ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
            
            self.blog_ImageView.sd_setImage(with: URL(string: blogImageUrl + (self.blogsData?.image ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
            
//            let myURL = URL(string: (self.blogsData?.sliderDescription ?? ""))
//            let myRequest = URLRequest(url: myURL!)
        self.blogDetail_WebView.loadHTMLString(((self.blogsData?.sliderDescription ?? "")), baseURL: nil)
            self.blogTitle_lbl.text! = self.blogsData?.title ?? ""
            self.blogLink_lbl.text! = self.blogsData?.videoLink ?? ""
            self.blogDescription_lbl.text! = (self.blogsData?.sliderDescription ?? "")
            self.blogTime_lbl.text! = ((self.blogsData?.sharedBy ?? "") + " , " +  (timeFormatChange(date: self.blogsData?.createdAt ?? "")))
            
            if (self.blogsData?.userBlogLike?.count == 0) {
                
                self.blogLike_btn.setTitle("Like", for: .normal)
                
            }else {
                
                self.blogLike_btn.setTitle("Unlike", for: .normal)
                
            }
            
            if (self.blogsData?.userBlogSaved?.count == 0 ){
                
                self.blogSave_btn.setTitle("Save", for: .normal)
                
            }else {
                
                self.blogSave_btn.setTitle("Discard", for: .normal)
            }
            
            self.connection_getInstraDetail(getOldHtml:(self.blogsData?.sliderDescription ?? ""))
            
        }else if(self.condition == "viewallBlogs") {
            //newOfferData
            self.blogFull_ImageView.sd_setImage(with: URL(string: blogImageUrl + (self.newOfferData?.image ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
            
            self.blog_ImageView.sd_setImage(with: URL(string: blogImageUrl + (self.newOfferData?.image ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
            
            self.blogTitle_lbl.text! = self.newOfferData?.title ?? ""
            
            self.blogLink_lbl.text! = self.newOfferData?.videoLink ?? ""
            
            self.blogDescription_lbl.text! = (self.newOfferData?.categoriesBlogDescription ?? "")
            
            self.blogDetail_WebView.loadHTMLString((self.newOfferData?.categoriesBlogDescription ?? ""), baseURL: nil)
            
            self.blogTime_lbl.text! = ((self.newOfferData?.sharedBy ?? "") + " , " +  (timeFormatChange(date: self.newOfferData?.createdAt ?? "")))
            
            if (self.blogsData?.userBlogLike?.count == 0) {
                
                self.blogLike_btn.setTitle("Like", for: .normal)
                
            }else {
                
                self.blogLike_btn.setTitle("Unlike", for: .normal)
                
            }
            
            if (self.blogsData?.userBlogSaved?.count == 0 ){
                
                self.blogSave_btn.setTitle("Save", for: .normal)
                
            }else {
                
                self.blogSave_btn.setTitle("Discard", for: .normal)
            }
            
            
        }else if self.condition == "SearchBlog" {
            
            self.blog_ImageView.sd_setImage(with: URL(string: blogImageUrl +  (self.viewSearchBlogData?.image ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
            
            
            self.blogFull_ImageView.sd_setImage(with: URL(string: blogImageUrl +  (self.viewSearchBlogData?.image ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
            
            self.blogTitle_lbl.text! = self.viewSearchBlogData?.title ?? ""
            
            self.blogLink_lbl.text! = self.viewSearchBlogData?.videoLink ?? ""
            
            self.blogDescription_lbl.text! = (self.viewSearchBlogData?.searchBlogDescription ?? "")
            
            self.blogDetail_WebView.loadHTMLString((self.viewSearchBlogData?.searchBlogDescription ?? ""), baseURL: nil)
            
            self.blogTime_lbl.text! = ((self.viewSearchBlogData?.sharedBy ?? "") + " , " +  (timeFormatChange(date: self.viewSearchBlogData?.createdAt ?? "")))
            
            if (self.viewSearchBlogData?.userBlogLike?.count == 0) {
                
                self.blogLike_btn.setTitle("Like", for: .normal)
                
            }else {
                
                self.blogLike_btn.setTitle("Unlike", for: .normal)
                
            }
            
            if (self.viewSearchBlogData?.userBlogSaved?.count == 0 ){
                
                self.blogSave_btn.setTitle("Save", for: .normal)
                
            }else {
                
                self.blogSave_btn.setTitle("Discard", for: .normal)
                
            }
            
            
        }else {
            
            self.blogFull_ImageView.sd_setImage(with: URL(string: blogImageUrl + (self.viewBlogFromBrand?.image ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
            
            self.blog_ImageView.sd_setImage(with: URL(string: blogImageUrl + (self.viewBlogFromBrand?.image ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
            
            self.blogTitle_lbl.text! = self.viewBlogFromBrand?.title ?? ""
            
            self.blogLink_lbl.text! = self.viewBlogFromBrand?.videoLink ?? ""
            
            self.blogDescription_lbl.text! = (self.viewBlogFromBrand?.categoriesBlogDescription ?? "")
            
            self.blogDetail_WebView.loadHTMLString((self.viewBlogFromBrand?.categoriesBlogDescription ?? ""), baseURL: nil)
            
            self.blogTime_lbl.text! = ((self.viewBlogFromBrand?.sharedBy ?? "") + " , " +  (timeFormatChange(date: self.blogsData?.createdAt ?? "")))
            
            if (self.viewBlogFromBrand?.userBlogLike?.count == 0) {
                
                self.blogLike_btn.setTitle("Like", for: .normal)
                
            }else {
                
                self.blogLike_btn.setTitle("Unlike", for: .normal)
                
            }
            
            if (self.viewBlogFromBrand?.userBlogSaved?.count == 0 ){
                
                self.blogSave_btn.setTitle("Save", for: .normal)
                
            }else {
                
                self.blogSave_btn.setTitle("Discard", for: .normal)
            }
            
            
            
        }
        
        userReadBlog()
        
    }
    
    func timeFormatChange(date : String) ->  String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let appointmentDate = date
        let dateString = dateFormatter.date(from: appointmentDate)
        //dateFormatter.dateFormat = "E MMM dd, yyyy HH:mm a"
        dateFormatter.dateFormat = "d MMMM, yyyy"
        
        if let str = dateString {
            
            let dateStringToSet = dateFormatter.string(from: str)
            return dateStringToSet
            
        }else{
            return ""
        }
        
    }
    
    // MARK: - WebView Delegate
    
      func webViewDidStartLoad(_ webView: UIWebView) {
        Indicator.shared.showProgressView(self.view)
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        Indicator.shared.hideProgressView()
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(CGSize.zero)
        
        webView.scrollView.isScrollEnabled=false;
        heightOFWeb.constant = webView.scrollView.contentSize.height
        webView.scalesPageToFit = true
    }
    
    // NARK: - Button Action
    
    
    
    @IBAction func tapOpenUrl_btn(_ sender: Any) {
        
        UIApplication.shared.open(URL(string: self.blogLink_lbl.text!)!, options: [:], completionHandler: nil)
    }
    
    
    @IBAction func tapSave_btn(_ sender: Any) {
        
        self.saveBlog(user_id: UserData().userId, blog_id: "\(self.blogsData?.id ?? -11)")
    }
    
    
    @IBAction func tapLike_btn(_ sender: Any) {
        
        self.likeBlog(user_id: UserData().userId, blog_id: "\(self.blogsData?.id ?? -11)")
        
    }
    
    @IBAction func tapOpenImage_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OpenFullImageViewController") as! OpenFullImageViewController
        
        if(self.condition == "blogs"){
        vc.productImageUrl =  (blogImageUrl + (self.blogsData?.image ?? ""))
            
        }else if(self.condition == "viewallBlogs") {
            //newOfferData
            vc.productImageUrl = (blogImageUrl + (self.newOfferData?.image ?? ""))
            
        }else if self.condition == "SearchBlog" {
            
           vc.productImageUrl = (blogImageUrl +  (self.viewSearchBlogData?.image ?? ""))
            
        }else {
            
             vc.productImageUrl =  ( blogImageUrl + (self.viewBlogFromBrand?.image ?? ""))
        }
      //  vc.productImageUrl = (blogImageUrl + "\((self.blogsData?.image ?? ""))")
        self.presentedViewController?.definesPresentationContext = true
        self.presentedViewController?.providesPresentationContextTransitionStyle = true
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
}

// MARK: - Service Response


extension BlogDetailViewController {
    
    // MARK: - Save Blog Service
    
    func saveBlog(user_id:String, blog_id: String) {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": user_id,"blog_id": blog_id] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "user_blog_saved", params: param as [String: AnyObject]) { (receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    if String(describing: (receviedData as! [String: AnyObject])["action"]!) == "unsaved" {
                        
                        self.save_btn.setTitle("Save", for: .normal)
                        
                    }else {
                        
                        self.save_btn.setTitle("Discard", for: .normal)
                        
                    }
                    
                    
                }else {
                    self.showDefaultAlert(Message: receviedData["messge"] as! String)
                    
                }
                
                
            }else {
                
                self.showDefaultAlert(Message: receviedData["Error"] as! String)
            }
            
            
            
        }
        
        
    }
    
    // MARK: - Liked Blog Service
    
    func likeBlog(user_id:String,blog_id: String) {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": user_id, "blog_id": blog_id] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "like_unlike_blog", params: param as [String: AnyObject]) { (receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    
                    if String(describing: (receviedData as! [String: AnyObject])["action"]!) == "like" {
                        
                        self.blogLike_btn.setTitle("Unlike", for: .normal)
                        
                    }else {
                        
                        self.blogLike_btn.setTitle("Like", for: .normal)
                        
                    }
                    
                }else {
                    self.showDefaultAlert(Message: receviedData["messge"] as! String)
                    
                }
                
            }else {
                
                self.showDefaultAlert(Message: receviedData["Error"] as! String)
            }
            
        }
        
    }
    
    // MARK: - User read blog
    
    func userReadBlog() {
        
        var param = [String: AnyObject]()
        
        if self.condition == "blogs" {
            
            param = ["user_id": UserData().userId,"blog_id": self.blogsData?.id ?? 0] as [String: AnyObject]
            
        }else if(self.condition == "offers") {
            
            param = ["user_id": UserData().userId,"blog_id": self.newOfferData?.id ?? 0] as [String: AnyObject]
            
            
        }else if self.condition == "SearchBlog" {
            
            param = ["user_id": UserData().userId,"blog_id": self.viewSearchBlogData?.id ?? 0] as [String: AnyObject]
            
            
        }else {
            
            param = ["user_id": UserData().userId,"blog_id": self.viewBlogFromBrand?.id ?? 0] as [String: AnyObject]
            
        }
         Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "user_blog_read", params: param as [String: AnyObject]) { (receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    
                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as?[String: AnyObject])? ["message"] as? String ?? "")
                    
                }
                
            }else {
                
                self.showDefaultAlert(Message: (receviedData as?[String: AnyObject])? ["Error"] as? String ?? "")
                
            }
            
        }
        
    }
}




extension BlogDetailViewController
{
    
    func connection_getInstraDetail(getOldHtml:String)
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
            "category_id":self.blogsData?.categoriesID ?? 0
          ]
          Indicator.shared.showProgressView(self.view)
      
        //   print(params)
       //   print(ConstantsHelper.get_all_profile_data)
          WebServiceManager.shared.callWebService_Home(ConstantsHelper.get_social_media_post, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
              
            
              
              if(response is NSDictionary)
              {
                  
         //        print(response)
                  let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                  if(status == true)
                  {
                    let data = (response as! NSDictionary).value(forKey: "data") as? NSArray ?? NSArray()
                    if(data.count > 0)
                    {
                        let getFirstOBj:NSDictionary = data.object(at: 0) as? NSDictionary ?? NSDictionary()
                        let getPost:String = getFirstOBj.value(forKey: "post") as? String ?? ""
                        print(getPost)
                        if(getPost.count > 0)
                        {
                            let Oldhtml:String = getOldHtml + getPost
                            self.blogDetail_WebView.loadHTMLString(Oldhtml, baseURL: nil)
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
