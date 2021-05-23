//
//  EventAndPostViewController.swift
//  Unilife
//
//  Created by promatics on 23/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


protocol PollTapProtocol: class {
    func didTapCollectionCell(section:Int,row:Int)
    
}

protocol imgPopupProtocol: class {
    func gotobackDelegate()
}


protocol deletePressPostProtocol: class {
    func didTapDelete(getID:String,getIndex:Int)
    
}


class EventAndPostViewController: UIViewController { // , UISearchBarDelegate, UISearchControllerDelegate
    
    // MARK: - Outlet
    
    @IBOutlet weak var eventAndPost_TableView: UITableView!
    
    @IBOutlet weak var addPost_btn: SetButton!
    @IBOutlet weak var viwWhatOpini: UIView!
    @IBOutlet weak var viwNoRecord: UIView!
    
    
    
    // MARK: - Variable
    var spinner = UIActivityIndicatorView()
    var stop_loader_myFeed:Bool = false
    var isLoadingMore:Bool = false
    var pageNO:Int = 0
    
    var brandImageArray = [UIImage(named: "brand-3"), UIImage(named: "brand-4"), UIImage(named: "brand-5"), UIImage(named: "brand-6"), UIImage(named: "brand-7")]
    
    var brandDiscount = ["10% OFF", "20% OFF","30% OFF","10% OFF","20% OFF"]
    
    var postListingArray = [[String: AnyObject]]()
    
    var eventPostData: EventAndPostModel?
    
    var getPostSizes: [GetPostImageSize]?
    
    var aryHomeData:NSMutableArray =  NSMutableArray()
    // MARK: - Default View
    
    var isVideoPlay:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventAndPost_TableView?.tableFooterView = UIView()
        eventAndPost_TableView?.estimatedRowHeight = 44.0
        eventAndPost_TableView?.rowHeight = UITableView.automaticDimension
        viwWhatOpini.layer.cornerRadius = 4
        
        spinner =  UIActivityIndicatorView(style: .white)
             spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: eventAndPost_TableView?.bounds.width ?? 0.0, height: CGFloat(44))
            eventAndPost_TableView?.tableFooterView = spinner
            eventAndPost_TableView?.tableFooterView?.isHidden = true
        
        /*
        self.eventAndPost_TableView.delegate = self
        
        self.eventAndPost_TableView.dataSource = self
        
        self.eventAndPost_TableView.register(UINib(nibName: "TrendingOfferTableViewCell", bundle: nil), forCellReuseIdentifier: "TrendingTableViewCell")
        
        self.eventAndPost_TableView.register(UINib(nibName: "LatestBlogsTableViewCell", bundle: nil), forCellReuseIdentifier: "LatestBlogTableViewCell")
        
        */
        
        
        //        self.navigationController?.navigationBar.prefersLargeTitles = true
        //
        //        self.navigationItem.largeTitleDisplayMode = .automatic
        
        //        navigationItem.searchController = UISearchController(searchResultsController: nil)
        //        navigationItem.hidesSearchBarWhenScrolling = false
        
        //        self.addNavigationBar(left: .Profile, title: "Unlife", titlePosition: .Middle, right: .Icon, rightButtonIconOrTitle: "notification_Icon", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
        
        defaultSearchBar()
        
        
        let getHeading:String = UserDefaults.standard.value(forKey: "_heading") as? String ?? ""
        if(getHeading.count == 0)
        {
            self.connection_ProfileHeader()
        }
        
    }
    
    
    deinit {
        
        print("destructure")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viwNoRecord.isHidden = true
        //        self.navigationController?.navigationBar.prefersLargeTitles = true
        //
        //        self.navigationItem.largeTitleDisplayMode = .automatic
        
        self.addNavigationBar(left: .Profile, titleType: .Normal, title: "Unilife", titlePosition: .Middle, right: .Icon, rightButtonIconOrTitle: "notification_Icon", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: { [weak self] in
            
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "NotificationListingViewController") as! NotificationListingViewController
            
            self?.navigationController?.pushViewController(vc, animated: true)
        })
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        if(isVideoPlay == false)
        {
           postListing()
            
        }
        isVideoPlay = false
        self.tabBarController?.tabBar.isHidden = false
        
        //self.navigationController?.navigationBar.backgroundColor = UIColor.appSkyBlue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        //        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appSkyBlue]
    }
    
    
    
    @IBAction func click_TopSection(_ sender: UIButton) {
        
        if(sender.tag == 0)  ////.. media
        {
            let vc = kHomeStoryBoard.instantiateViewController(withIdentifier: "MediaVC") as! MediaVC
             self.navigationController?.pushViewController(vc, animated: true)
        }else if(sender.tag == 1) ////.. Event
        {
            let vc = kHomeStoryBoard.instantiateViewController(withIdentifier: "EventVC") as! EventVC
             self.navigationController?.pushViewController(vc, animated: true)
        }else if(sender.tag == 2) ////.. Poll
        {
            let vc = kHomeStoryBoard.instantiateViewController(withIdentifier: "PollVC") as! PollVC
             self.navigationController?.pushViewController(vc, animated: true)
        }else if(sender.tag == 3)   ////.. opininen share
        {
            let vc = kHomeStoryBoard.instantiateViewController(withIdentifier: "OpinionShareVC") as! OpinionShareVC
             self.navigationController?.pushViewController(vc, animated: true)
        }
                 
    }
    
    @IBAction func ClickComment(sender:UIButton)
    {
        print(sender.tag)
         let getDic:NSDictionary = self.aryHomeData.object(at: sender.tag) as? NSDictionary ?? NSDictionary()
        print(getDic)
        let vc = kHomeStoryBoard.instantiateViewController(withIdentifier: "CommentVC") as! CommentVC
        vc.getDetail = getDic
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func ClickRegis(sender:UIButton)
    {
        
           let getDic:NSDictionary = self.aryHomeData.object(at: sender.tag) as? NSDictionary ?? NSDictionary()
        
           var event_link:String = getDic.value(forKey: "event_link") as? String ?? ""
        let event_id:String = getDic.value(forKey: "id") as? String ?? "0"
        
         
        
        let alreadyHit:String = getDic.value(forKey: "already_hit_button") as? String ?? "no"
        if(alreadyHit == "no")
        {
        self.connection_RegisCountSend(getEventID: Int(event_id) ?? 0,getIndex: sender.tag)
        
        let event_register_count:String = getDic.value(forKey: "event_register_count") as? String ?? ""
        var getlike:Int = Int(event_register_count) as? Int ?? 0
            getlike = getlike + 1
               
               let getDicChange:NSMutableDictionary = getDic.mutableCopy() as? NSMutableDictionary ?? NSMutableDictionary()
               getDicChange.setValue("\(getlike)", forKey: "event_register_count")
            getDicChange.setValue("yes", forKey: "already_hit_button")
               self.aryHomeData.replaceObject(at: sender.tag, with: getDicChange)
        let indexPath = IndexPath(row: sender.tag, section: 0)
          let cell = self.eventAndPost_TableView.cellForRow(at: indexPath) as! HomeEventCell
        cell.btnRegisCount.setTitle(" \(getlike)", for: .normal)
        }
        
        
        if(event_link.count > 0)
                 {
                  if(event_link.contains("http") || event_link.contains("Http") || event_link.contains("https") || event_link.contains("Https")){
                    guard let url = URL(string: event_link) else { return }
                    UIApplication.shared.open(url)
                    }else
                  {
                    event_link = "http://" + event_link
                    guard let url = URL(string: event_link) else { return }
                                       UIApplication.shared.open(url)
                    }
                 }
        
    }
    
    @IBAction func ClickLike(sender:UIButton)
    {
        let getDic:NSDictionary = self.aryHomeData.object(at: sender.tag) as? NSDictionary ?? NSDictionary()
       // print(getDic)
        
        let getid:String = getDic.value(forKey: "id") as? String ?? ""
        
        self.likePost(post_id:getid, user_id:UserData().userId , index: sender.tag)
        var getlike:Int = getDic.value(forKey: "is_like") as? Int ?? 0
        var post_like_count:Int = getDic.value(forKey: "post_like_count") as? Int ?? 0
        if(getlike == 0)
        {
            getlike = 1
            post_like_count = post_like_count + 1
        }else
        {
            getlike = 0
            post_like_count = post_like_count - 1
        }
        let getDicChange:NSMutableDictionary = getDic.mutableCopy() as? NSMutableDictionary ?? NSMutableDictionary()
        getDicChange.setValue(getlike, forKey: "is_like")
        getDicChange.setValue(post_like_count, forKey: "post_like_count")
        self.aryHomeData.replaceObject(at: sender.tag, with: getDicChange)
        
        if(sender.imageView?.image == UIImage.init(named: "hrtRed_Icon2"))
        {
            sender.setImage(UIImage.init(named: "like_Dark"), for: .normal)
        }else
        {
            sender.setImage(UIImage.init(named: "hrtRed_Icon2"), for: .normal)
        }
        
        ///... like button count change
        let getType:String = getDic.value(forKey: "type") as? String ?? ""
        let indexPath = IndexPath(row: sender.tag, section: 0)

        if(getType == "event")
           {
              let cell = self.eventAndPost_TableView.cellForRow(at: indexPath) as! HomeEventCell
            cell.btnfav.setTitle(" \(post_like_count)", for: .normal)
           }else if (getType == "opinion")
           {
             let cell = self.eventAndPost_TableView.cellForRow(at: indexPath) as! HomeImageCell
            cell.btnfav.setTitle(" \(post_like_count)", for: .normal)
           }else if (getType == "normal")
           {
             let cell = self.eventAndPost_TableView.cellForRow(at: indexPath) as! HomeVideoCell
            cell.btnfav.setTitle(" \(post_like_count)", for: .normal)
           }
        
    }
    
    @IBAction func ClickVideo(sender:UIButton)
    {
        var _videoURl:String = ""
        let getDic:NSDictionary = self.aryHomeData.object(at: sender.tag) as? NSDictionary ?? NSDictionary()
        
        let post_attachments:NSArray = getDic.value(forKey: "post_attachments") as? NSArray ?? NSArray()
        if(post_attachments.count > 0)
        {
            let getFirstEventDic:NSDictionary = post_attachments.object(at: 0) as? NSDictionary ?? NSDictionary()
            let videoR:String = getFirstEventDic.value(forKey: "attachment") as? String ?? ""
            
            let attachment_type:String = getFirstEventDic.value(forKey: "attachment_type") as? String ?? ""
            if(attachment_type == "video")
            {
                _videoURl = videoR
            }
        }
        
        if(_videoURl.count > 0)
        {
            isVideoPlay = true
            let videoURL = URL(string: _videoURl)
            let player = AVPlayer(url: videoURL!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
        
    }
    
    
    @IBAction func ClickShare(sender:UIButton)
    {
        var getShareText:String = ""
        let getDic:NSDictionary = self.aryHomeData.object(at: sender.tag) as? NSDictionary ?? NSDictionary()
        let getType:String = getDic.value(forKey: "type") as? String ?? ""
        
        
        if(getType == "event")
        {
            getShareText = getDic.value(forKey: "event_description") as? String ?? ""
        }else if (getType == "opinion") || (getType == "normal")
        {
            getShareText = getDic.value(forKey: "caption") as? String ?? ""
        }else if (getType == "poll")
        {
            getShareText = getDic.value(forKey: "question") as? String ?? ""
        }
        
        if(getShareText.count > 0)
        {
            let viewController = UIActivityViewController(activityItems: [getShareText], applicationActivities: nil)
            viewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
           self.present(viewController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func click_imageZoom(sender:UIButton)
    {
        let getDic:NSDictionary = self.aryHomeData.object(at: sender.tag) as? NSDictionary ?? NSDictionary()
        let getType:String = getDic.value(forKey: "type") as? String ?? ""
        let index = IndexPath(row: sender.tag, section: 0)
        if(getType == "event")
        {
            // let cell = self.eventAndPost_TableView.cellForRow(at: index) as? HomeEventCell ?? HomeEventCell()
            guard let cell = self.eventAndPost_TableView.cellForRow(at: index) as? HomeEventCell else {
                return // or fatalError() or whatever
            }
            isVideoPlay = true
            blurViewX()
            let popupVC = kPhase2toryBoard.instantiateViewController(withIdentifier: "HomeImageZoomVC") as! HomeImageZoomVC
            popupVC.getimg = cell.imgEvent.image
            popupVC.modalPresentationStyle = .overFullScreen
            popupVC.delegate = self
            self.present(popupVC, animated: true, completion: nil)
            
            
        }else if(getType == "opinion")
        {
            guard let cell = self.eventAndPost_TableView.cellForRow(at: index) as? HomeImageCell else {
                return // or fatalError() or whatever
            }
            isVideoPlay = true
           // blurViewX()
            let popupVC = kPhase2toryBoard.instantiateViewController(withIdentifier: "HomeImageZoomVC") as! HomeImageZoomVC
            
            popupVC.getimg = cell.imgEvent.image
            popupVC.modalPresentationStyle = .overFullScreen
            popupVC.delegate = self
            self.present(popupVC, animated: true, completion: nil)
        }else if(getType == "normal")
        {
            guard let cell = self.eventAndPost_TableView.cellForRow(at: index) as? HomeVideoCell else {
                return // or fatalError() or whatever
            }
            isVideoPlay = true
            blurViewX()
            let popupVC = kPhase2toryBoard.instantiateViewController(withIdentifier: "HomeImageZoomVC") as! HomeImageZoomVC
            
            popupVC.getimg = cell.imgEvent.image
            popupVC.modalPresentationStyle = .overFullScreen
            popupVC.delegate = self
            self.present(popupVC, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func tapThreeDot_btn(_ sender: UIButton){
        
        let getDic:NSDictionary = self.aryHomeData.object(at: sender.tag) as? NSDictionary ?? NSDictionary()
       // print(getDic)
        let userid:String = getDic.value(forKey: "user_id") as? String ?? ""
       // print(userid)
        let postid:String = getDic.value(forKey: "id") as? String ?? ""
        //print(postid)
      //         let getType:String = getDic.value(forKey: "type") as? String ?? ""
        
        guard let popoverContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReportPostOrUserViewController") as? ReportPostOrUserViewController else {return}
        
        popoverContent.controller = self
        popoverContent.delegate = self
        popoverContent.postUserId = userid//String(self.eventPostData?[sender.tag].userID ?? 0)
        popoverContent.getIndex = sender.tag
        popoverContent.postId = postid//String(self.eventPostData?[sender.tag].id ?? 0)
        
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
        
        
        if(userid == UserData().userId)
        {
            popoverContent.preferredContentSize = CGSize(width: 200, height: 90)
        }else
        {
            popoverContent.preferredContentSize = CGSize(width: 200, height: 60)
        }
        let popOver = popoverContent.popoverPresentationController
        
        popOver?.delegate = self
        //
        popOver?.sourceView = sender
        //
        
        // popOver?.sourceView = sender
        popOver?.sourceRect = sender.bounds
        //
        popOver?.permittedArrowDirections = [.up]
        
        
        self.present(popoverContent, animated: true, completion: nil)
    }
    
    
    // MARK: - Serach Bar Function
    
    func defaultSearchBar() {
        
        //        if #available(iOS 11.0, *) {
        //            let sc = UISearchController(searchResultsController: nil)
        //            sc.delegate = self
        //            let scb = sc.searchBar
        //            scb.tintColor = UIColor.appDarKGray
        //            scb.barTintColor = UIColor.white
        //            scb.placeholder = "Search for Coupons & More"
        //
        //            if let textfield = scb.value(forKey: "searchField") as? UITextField {
        //                textfield.textColor = UIColor.blue
        //                if let backgroundview = textfield.subviews.first {
        //
        //                    // Background color
        //                    backgroundview.backgroundColor = UIColor.white
        //
        //                    // Rounded corner
        //                    backgroundview.layer.cornerRadius = 10;
        //                    backgroundview.clipsToBounds = true;
        //                }
        //            }
        //
        //            if let navigationbar = self.navigationController?.navigationBar {
        //                navigationbar.barTintColor = UIColor.appSkyBlue
        //            }
        //            navigationItem.searchController = sc
        //            navigationItem.hidesSearchBarWhenScrolling = false
        //        }
    }
    
    
    // MARK: - Button Action
    
    
    
    @IBAction func tapAddPost_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPostViewController") as! AddPostViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func tapCategories_btn(_ sender: Any) {
        
        
        guard let popoverContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewAllProductViewController") as? ViewAllProductViewController else {return}
        
        
        popoverContent.controller = self
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
        
        popoverContent.preferredContentSize = CGSize(width: 200, height: 1000)
        
        
        
        //        popoverContent.delegate = self
        //
        //        popoverContent.privacyFor = .story
        
        
        
        let popOver = popoverContent.popoverPresentationController
        
        popOver?.delegate = self
        
        popOver?.sourceView = sender as! UIView
        
        popOver?.sourceRect = (sender as AnyObject).bounds
        
        popOver?.permittedArrowDirections = [.up]
        
        self.present(popoverContent, animated: true, completion: nil)
        
        
    }
    
}



extension EventAndPostViewController:PollTapProtocol
{
    func didTapCollectionCell(section:Int,row:Int)
    {
        let getDic:NSDictionary = self.aryHomeData.object(at: section) as? NSDictionary ?? NSDictionary()
        let post_options:NSArray = getDic.value(forKey: "post_options") as? NSArray ?? NSArray()
        let getpollDic:NSDictionary = post_options.object(at: row) as? NSDictionary ?? NSDictionary()
        var isAlreadyDone:Bool = false
        for i in 0..<post_options.count
        {
           
                let getOBJ:NSDictionary = post_options.object(at: i) as? NSDictionary ?? NSDictionary()
                let changingDic:NSMutableDictionary = getOBJ.mutableCopy() as? NSMutableDictionary ?? NSMutableDictionary()
                let lastType:String = changingDic.value(forKey: "selected") as? String ?? "no"
                if(lastType == "yes")
                {
                    isAlreadyDone = true
                }
               
            
        }
        if(isAlreadyDone == true)
        {
            return
        }
        
        let getId:String  = getpollDic.value(forKey: "id") as? String ?? ""
        let lastType:String = getpollDic.value(forKey: "selected") as? String ?? "no"
        if(lastType == "yes")
        {
            return
        }
        self.connection_selectPoll(post_id: getId, getindex: 0)
        
        let mainDic:NSMutableDictionary = getDic.mutableCopy() as? NSMutableDictionary ?? NSMutableDictionary()
        let getMainPostArray:NSMutableArray = post_options.mutableCopy() as? NSMutableArray ?? NSMutableArray()
        
      //  let changingDic:NSMutableDictionary = getpollDic.mutableCopy() as? NSMutableDictionary ?? NSMutableDictionary()
     //   changingDic.setValue("yes", forKey: "selected")
        for i in 0..<getMainPostArray.count
        {
            if(i == row)
            {
                let getOBJ:NSDictionary = getMainPostArray.object(at: i) as? NSDictionary ?? NSDictionary()
                let changingDic:NSMutableDictionary = getOBJ.mutableCopy() as? NSMutableDictionary ?? NSMutableDictionary()
                let lastType:String = changingDic.value(forKey: "selected") as? String ?? "no"
                var selected_count:Int = changingDic.value(forKey: "selected_count") as? Int ?? 0
                
                if(lastType == "no")
                {
                    selected_count = selected_count + 1
                    changingDic.setValue(selected_count, forKey: "selected_count")
                }
                
                changingDic.setValue("yes", forKey: "selected")
                
                getMainPostArray.replaceObject(at: i, with: changingDic)
            }else
            {
                let getOBJ:NSDictionary = getMainPostArray.object(at: i) as? NSDictionary ?? NSDictionary()
                let changingDic:NSMutableDictionary = getOBJ.mutableCopy() as? NSMutableDictionary ?? NSMutableDictionary()
                
                let lastType:String = changingDic.value(forKey: "selected") as? String ?? "no"
                var selected_count:Int = changingDic.value(forKey: "selected_count") as? Int ?? 0
                               
                if(lastType == "yes")
                {
                   selected_count = selected_count - 1
                   changingDic.setValue(selected_count, forKey: "selected_count")
                }
                changingDic.setValue("no", forKey: "selected")
                getMainPostArray.replaceObject(at: i, with: changingDic)
            }
        }
        
        mainDic.setValue(getMainPostArray, forKey: "post_options")
      //  print(mainDic)
        self.aryHomeData.replaceObject(at: section, with: mainDic)
        self.eventAndPost_TableView.reloadData()
    }
}

extension EventAndPostViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           
          // return 4
           return aryHomeData.count
           
       }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let getDic:NSDictionary = self.aryHomeData.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
        let getType:String = getDic.value(forKey: "type") as? String ?? ""
      //  print("--------->",indexPath.row,getType)
        
        if(getType == "event")
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeEventCell") as! HomeEventCell
            cell.imgUserProfile.layer.cornerRadius = 50/2
            cell.imgUserProfile.layer.borderColor = UIColor.unilifeblueDark.cgColor
            cell.imgUserProfile.layer.borderWidth = 2.0
            cell.btnfavClick.tag = indexPath.row
            cell.btnCommentClick.tag = indexPath.row
            cell.btnShare.tag = indexPath.row
            cell.btnfav.tag = indexPath.row
            cell.btnComment.tag = indexPath.row
            cell.btnImageZoom.tag = indexPath.row
            cell.btnThreeDot.tag = indexPath.row
            let event_description:String = getDic.value(forKey: "event_description") as? String ?? ""
            let event_title:String = getDic.value(forKey: "event_title") as? String ?? ""
            let comemntCount:Int = getDic.value(forKey: "post_comments_count") as? Int ?? 0
            let likeCount:Int = getDic.value(forKey: "post_like_count") as? Int ?? 0
            let event_register_count:String = getDic.value(forKey: "event_register_count") as? String ?? "0"
            cell.btnComment.setTitle(" \(comemntCount)", for: .normal)
            cell.btnfav.setTitle(" \(likeCount)", for: .normal)
            cell.btnRegisCount.setTitle(" \(event_register_count)", for: .normal)
            cell.lblDes.text = event_description
            cell.lblMemberRegis.text = "22 Members Registered"
            cell.lblTitle.text = event_title
            
            let getuserArray:NSArray = getDic.value(forKey: "user_uploading_post") as? NSArray ?? NSArray()
            if(getuserArray.count > 0)
            {
                let getUserDetail:NSDictionary = getuserArray.object(at: 0) as? NSDictionary ?? NSDictionary()
               // print(getUserDetail)
                cell.lblName.text = getUserDetail.value(forKey: "username") as? String ?? ""
                let getuserImg:String = getUserDetail.value(forKey: "profile_image") as? String ?? ""
                cell.imgUserProfile.sd_setImage(with: URL(string: getuserImg), placeholderImage: UIImage(named: "userProfile_ImageView"))
                
            }else
            {
                cell.imgUserProfile.image = UIImage(named: "userProfile_ImageView")
            }
            let getDate:String = getDic.value(forKey: "created_at") as? String ?? ""
            cell.lblTime.text = ApplicationManager.instance.dateCalculator(createdDate: getDate)

            let post_attachments:NSArray = getDic.value(forKey: "post_attachments") as? NSArray ?? NSArray()
            if(post_attachments.count > 0)
            {
                 let getFirstEventDic:NSDictionary = post_attachments.object(at: 0) as? NSDictionary ?? NSDictionary()
                
                let imgEvent:String = getFirstEventDic.value(forKey: "attachment") as? String ?? ""
                
                 cell.imgEvent.sd_setImage(with: URL(string: imgEvent), placeholderImage: UIImage(named: "noimage_icon"))
                //let attachment_type:String = getUserDetail.value(forKey: "attachment_type") as? String ?? ""
            }else
            {
                cell.imgEvent.image = UIImage(named: "noimage_icon")
            }
            
            
            
            let islike:Bool = getDic.value(forKey: "is_like") as? Bool ?? false
            if(islike == true)
            {
                cell.btnfavClick.setImage(UIImage.init(named: "hrtRed_Icon2"), for: .normal)
            }else
            {
                cell.btnfavClick.setImage(UIImage.init(named: "like_Dark"), for: .normal)
            }
            cell.selectionStyle = .none
            return cell
            
        }else if (getType == "poll")
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomePollCell") as! HomePollCell
            cell.imgUserProfile.layer.cornerRadius = 50/2
            cell.imgUserProfile.layer.borderColor = UIColor.unilifeblueDark.cgColor
            cell.imgUserProfile.layer.borderWidth = 2.0
            cell.btnfavClick.tag = indexPath.row
            cell.btnCommentClick.tag = indexPath.row
            cell.btnShare.tag = indexPath.row
            cell.btnfav.tag = indexPath.row
            cell.btnComment.tag = indexPath.row
            cell.btnThreeDot.tag = indexPath.row
            
            let question:String = getDic.value(forKey: "question") as? String ?? ""
            cell.lblTitle.text = question
      
            let comemntCount:Int = getDic.value(forKey: "post_comments_count") as? Int ?? 0
            let likeCount:Int = getDic.value(forKey: "post_like_count") as? Int ?? 0
            cell.btnComment.setTitle(" \(comemntCount)", for: .normal)
            cell.btnfav.setTitle(" \(likeCount)", for: .normal)
            
            
            let getuserArray:NSArray = getDic.value(forKey: "user_uploading_post") as? NSArray ?? NSArray()
            if(getuserArray.count > 0)
            {
                let getUserDetail:NSDictionary = getuserArray.object(at: 0) as? NSDictionary ?? NSDictionary()
               // print(getUserDetail)
                cell.lblName.text = getUserDetail.value(forKey: "username") as? String ?? ""
                let getuserImg:String = getUserDetail.value(forKey: "profile_image") as? String ?? ""
                cell.imgUserProfile.sd_setImage(with: URL(string: getuserImg), placeholderImage: UIImage(named: "userProfile_ImageView"))
                
            }else
            {
                cell.imgUserProfile.image = UIImage(named: "userProfile_ImageView")
            }
            
            let getDate:String = getDic.value(forKey: "created_at") as? String ?? ""
            cell.lblTime.text = ApplicationManager.instance.dateCalculator(createdDate: getDate)
            let post_options:NSArray = getDic.value(forKey: "post_options") as? NSArray ?? NSArray()
          
            cell.DataForCollection = post_options
            cell.collectionAccess.tag = indexPath.row
            cell.delegate = self
            
            if(post_options.count > 0)
            {
                var height:CGFloat = 0.0
                let getC:Int = (post_options.count) % 2
                var getCount:Int = post_options.count/2
                if(getC == 0)
                {
                    if(getCount == 0)
                    {
                        getCount = 1
                    }
                    height = CGFloat(60 * getCount)
                }else
                {
                    height = CGFloat((60 * getCount) + 60)
                }
                
                cell.heightOFPollCollection.constant = height
            }else
            {
                cell.heightOFPollCollection.constant = 0
            }
            
            cell.collectionAccess.reloadData()
            cell.selectionStyle = .none
            return cell
            
        }else if (getType == "opinion")
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeImageCell") as! HomeImageCell
            cell.imgUserProfile.layer.cornerRadius = 50/2
            cell.imgUserProfile.layer.borderColor = UIColor.unilifeblueDark.cgColor
            cell.imgUserProfile.layer.borderWidth = 2.0
            cell.viwImage.layer.borderColor = UIColor(red: 220.0/255, green: 220.0/255, blue: 220.0/255, alpha: 1.0).cgColor
            cell.viwImage.layer.borderWidth = 0.5
            cell.viwImage.layer.cornerRadius = 4
            cell.viwImage.layer.masksToBounds = true;
            
            cell.btnfavClick.tag = indexPath.row
            cell.btnCommentClick.tag = indexPath.row
            cell.btnShare.tag = indexPath.row
            cell.btnfav.tag = indexPath.row
            cell.btnComment.tag = indexPath.row
            cell.btnThreeDot.tag = indexPath.row
            cell.btnPlayVideo.tag = indexPath.row
            cell.btnImageZoom.tag = indexPath.row
            
            let caption:String = getDic.value(forKey: "caption") as? String ?? ""
            cell.lblDes.text = caption
            let comemntCount:Int = getDic.value(forKey: "post_comments_count") as? Int ?? 0
            let likeCount:Int = getDic.value(forKey: "post_like_count") as? Int ?? 0
            cell.btnComment.setTitle(" \(comemntCount)", for: .normal)
            cell.btnfav.setTitle(" \(likeCount)", for: .normal)
            
            
            let getuserArray:NSArray = getDic.value(forKey: "user_uploading_post") as? NSArray ?? NSArray()
            if(getuserArray.count > 0)
            {
                let getUserDetail:NSDictionary = getuserArray.object(at: 0) as? NSDictionary ?? NSDictionary()
               // print(getUserDetail)
                cell.lblName.text = getUserDetail.value(forKey: "username") as? String ?? ""
                let getuserImg:String = getUserDetail.value(forKey: "profile_image") as? String ?? ""
                cell.imgUserProfile.sd_setImage(with: URL(string: getuserImg), placeholderImage: UIImage(named: "userProfile_ImageView"))
                

            }else
            {
                cell.imgUserProfile.image = UIImage(named: "userProfile_ImageView")
            }
            let getDate:String = getDic.value(forKey: "created_at") as? String ?? ""
            cell.lblTime.text = ApplicationManager.instance.dateCalculator(createdDate: getDate)

            
            let post_attachments:NSArray = getDic.value(forKey: "post_attachments") as? NSArray ?? NSArray()
            if(post_attachments.count > 0)
            {
                cell.hightOFImage.constant = 150
                let getFirstEventDic:NSDictionary = post_attachments.object(at: 0) as? NSDictionary ?? NSDictionary()
                
                let imgEvent:String = getFirstEventDic.value(forKey: "attachment") as? String ?? ""
                let imgThumbnail:String = getFirstEventDic.value(forKey: "thumbnail") as? String ?? ""
                
                let attachment_type:String = getFirstEventDic.value(forKey: "attachment_type") as? String ?? ""
                if(attachment_type == "video")
                {
                    cell.btnPlayVideo.isHidden = false
                    
                    if(imgThumbnail.count > 0)
                    {
                        cell.imgEvent.sd_setImage(with: URL(string: postImageUrl + imgThumbnail), placeholderImage: UIImage(named: "noimage_icon"))
                    }
                }else
                {
                    cell.btnPlayVideo.isHidden = true
                    cell.imgEvent.sd_setImage(with: URL(string: imgEvent), placeholderImage: UIImage(named: "noimage_icon"))
                }
                
            }else
            {
                cell.hightOFImage.constant = 0
                   cell.btnPlayVideo.isHidden = true
                cell.imgEvent.image = nil
            }
            let islike:Bool = getDic.value(forKey: "is_like") as? Bool ?? false
                      if(islike == true)
                      {
                          cell.btnfavClick.setImage(UIImage.init(named: "hrtRed_Icon2"), for: .normal)
                      }else
                      {
                          cell.btnfavClick.setImage(UIImage.init(named: "like_Dark"), for: .normal)
                      }
            cell.selectionStyle = .none
            return cell

        }else if (getType == "normal")
        {
             let cell = tableView.dequeueReusableCell(withIdentifier: "HomeVideoCell") as! HomeVideoCell
             cell.imgUserProfile.layer.cornerRadius = 50/2
             cell.imgUserProfile.layer.borderColor = UIColor.unilifeblueDark.cgColor
             cell.imgUserProfile.layer.borderWidth = 2.0
             cell.btnfavClick.tag = indexPath.row
             cell.btnCommentClick.tag = indexPath.row
             cell.btnShare.tag = indexPath.row
             cell.btnfav.tag = indexPath.row
             cell.btnComment.tag = indexPath.row
             cell.btnPlayVideo.tag = indexPath.row
            cell.btnImageZoom.tag = indexPath.row
            cell.btnThreeDot.tag = indexPath.row
            
            let caption:String = getDic.value(forKey: "caption") as? String ?? ""
            cell.lblDes.text = caption
            let comemntCount:Int = getDic.value(forKey: "post_comments_count") as? Int ?? 0
            let likeCount:Int = getDic.value(forKey: "post_like_count") as? Int ?? 0
            cell.btnComment.setTitle(" \(comemntCount)", for: .normal)
            cell.btnfav.setTitle(" \(likeCount)", for: .normal)

            
            let getuserArray:NSArray = getDic.value(forKey: "user_uploading_post") as? NSArray ?? NSArray()
            if(getuserArray.count > 0)
            {
                let getUserDetail:NSDictionary = getuserArray.object(at: 0) as? NSDictionary ?? NSDictionary()
               // print(getUserDetail)
                cell.lblName.text = getUserDetail.value(forKey: "username") as? String ?? ""
                let getuserImg:String = getUserDetail.value(forKey: "profile_image") as? String ?? ""
                cell.imgUserProfile.sd_setImage(with: URL(string: getuserImg), placeholderImage: UIImage(named: "userProfile_ImageView"))
            }else
            {
                cell.imgUserProfile.image = UIImage(named: "userProfile_ImageView")
            }
            
            let getDate:String = getDic.value(forKey: "created_at") as? String ?? ""
            cell.lblTime.text = ApplicationManager.instance.dateCalculator(createdDate: getDate)

            let post_attachments:NSArray = getDic.value(forKey: "post_attachments") as? NSArray ?? NSArray()
            if(post_attachments.count > 0)
            {
                let getFirstEventDic:NSDictionary = post_attachments.object(at: 0) as? NSDictionary ?? NSDictionary()
                
                let imgEvent:String = getFirstEventDic.value(forKey: "attachment") as? String ?? ""
                let imgThumbnail:String = getFirstEventDic.value(forKey: "thumbnail") as? String ?? ""
                
              
                let attachment_type:String = getFirstEventDic.value(forKey: "attachment_type") as? String ?? ""
                if(attachment_type == "video")
                {
                    cell.btnPlayVideo.isHidden = false
                    if(imgThumbnail.count > 0)
                    {
                      cell.imgEvent.sd_setImage(with: URL(string: postImageUrl + imgThumbnail), placeholderImage: UIImage(named: "noimage_icon"))
                    }
                }else
                {
                    cell.btnPlayVideo.isHidden = true
                      cell.imgEvent.sd_setImage(with: URL(string: imgEvent), placeholderImage: UIImage(named: "noimage_icon"))
                }
            }else
            {
                cell.btnPlayVideo.isHidden = true
                cell.imgEvent.image = nil
            }
            let islike:Bool = getDic.value(forKey: "is_like") as? Bool ?? false
                      if(islike == true)
                      {
                          cell.btnfavClick.setImage(UIImage.init(named: "hrtRed_Icon2"), for: .normal)
                      }else
                      {
                          cell.btnfavClick.setImage(UIImage.init(named: "like_Dark"), for: .normal)
                      }
            cell.selectionStyle = .none
            return cell
            
        }else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeVideoCell") as! HomeVideoCell
            cell.imgUserProfile.layer.cornerRadius = 50/2
            cell.imgUserProfile.layer.borderColor = UIColor.unilifeblueDark.cgColor
            cell.imgUserProfile.layer.borderWidth = 2.0
            cell.btnfavClick.tag = indexPath.row
            cell.btnCommentClick.tag = indexPath.row
            cell.btnShare.tag = indexPath.row
            cell.btnfav.tag = indexPath.row
            cell.btnComment.tag = indexPath.row
            cell.btnPlayVideo.tag = indexPath.row
            cell.btnImageZoom.tag = indexPath.row
            cell.btnThreeDot.tag = indexPath.row
            
            let caption:String = getDic.value(forKey: "caption") as? String ?? ""
            cell.lblDes.text = caption
            let comemntCount:Int = getDic.value(forKey: "post_comments_count") as? Int ?? 0
            let likeCount:Int = getDic.value(forKey: "post_like_count") as? Int ?? 0
            cell.btnComment.setTitle(" \(comemntCount)", for: .normal)
            cell.btnfav.setTitle(" \(likeCount)", for: .normal)

            let getuserArray:NSArray = getDic.value(forKey: "user_uploading_post") as? NSArray ?? NSArray()
            if(getuserArray.count > 0)
            {
                let getUserDetail:NSDictionary = getuserArray.object(at: 0) as? NSDictionary ?? NSDictionary()
               // print(getUserDetail)
                cell.lblName.text = getUserDetail.value(forKey: "username") as? String ?? ""
                let getuserImg:String = getUserDetail.value(forKey: "profile_image") as? String ?? ""
                cell.imgUserProfile.sd_setImage(with: URL(string: getuserImg), placeholderImage: UIImage(named: "userProfile_ImageView"))
            }
            
            let getDate:String = getDic.value(forKey: "created_at") as? String ?? ""
            cell.lblTime.text = ApplicationManager.instance.dateCalculator(createdDate: getDate)
            
            let islike:Bool = getDic.value(forKey: "is_like") as? Bool ?? false
                      if(islike == true)
                      {
                          cell.btnfavClick.setImage(UIImage.init(named: "hrtRed_Icon2"), for: .normal)
                      }else
                      {
                          cell.btnfavClick.setImage(UIImage.init(named: "like_Dark"), for: .normal)
                      }
            cell.selectionStyle = .none
            return cell
        }
        
        /*
        if(indexPath.row == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeEventCell") as! HomeEventCell
            cell.imgUserProfile.layer.cornerRadius = 50/2
            cell.imgUserProfile.layer.borderColor = UIColor.unilifeblueDark.cgColor
            cell.imgUserProfile.layer.borderWidth = 2.0
            return cell
        }else if (indexPath.row == 1)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeImageCell") as! HomeImageCell
            cell.imgUserProfile.layer.cornerRadius = 50/2
            cell.imgUserProfile.layer.borderColor = UIColor.unilifeblueDark.cgColor
            cell.imgUserProfile.layer.borderWidth = 2.0

            cell.viwImage.layer.borderColor = UIColor(red: 220.0/255, green: 220.0/255, blue: 220.0/255, alpha: 1.0).cgColor
            cell.viwImage.layer.borderWidth = 0.5
            cell.viwImage.layer.cornerRadius = 4
            cell.viwImage.layer.masksToBounds = true;


            return cell
        }else if (indexPath.row == 2)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomePollCell") as! HomePollCell
            cell.imgUserProfile.layer.cornerRadius = 50/2
            cell.imgUserProfile.layer.borderColor = UIColor.unilifeblueDark.cgColor
            cell.imgUserProfile.layer.borderWidth = 2.0

            cell.btnNo.tag = indexPath.row
            cell.btnYes.tag = indexPath.row
            cell.btnYes.layer.borderColor = UIColor.unilifeYesColor.cgColor
            cell.btnYes.layer.borderWidth = 2.0
            cell.btnYes.layer.cornerRadius = 4
            cell.btnNo.layer.borderColor = UIColor.unilifeNoColor.cgColor
            cell.btnNo.layer.borderWidth = 2.0
            cell.btnNo.layer.cornerRadius = 4
            return cell
        }else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeVideoCell") as! HomeVideoCell
            cell.imgUserProfile.layer.cornerRadius = 50/2
            cell.imgUserProfile.layer.borderColor = UIColor.unilifeblueDark.cgColor
            cell.imgUserProfile.layer.borderWidth = 2.0

           return cell
        }
        
        */
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return UITableView.automaticDimension
           
       }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        /*
        if(self.aryHomeData.count != 0)
        {
            
        if indexPath.row == self.aryHomeData.count - 1 { // last cell
            if(isLoadingMore == false)
            {
                isLoadingMore = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // Change `2.0` to the
                    
                
                if(self.stop_loader_myFeed == false){
                    self.spinner.startAnimating()
                    self.spinner.isHidden = false
                    self.eventAndPost_TableView?.tableFooterView?.isHidden = false
                  //  self.postListing_loadMore()
                }else
                {
                    self.isLoadingMore = false
                 }
              }
                
                
            }
        }
        }
        
        */
    }
}
/*
extension EventAndPostViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postListingArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if !(self.postListingArray[indexPath.row].isEmpty) {
            
            if indexPath.row == 3 {
                
                guard let cell = self.eventAndPost_TableView.dequeueReusableCell(withIdentifier: "TrendingTableViewCell") as? TrendingTableViewCell else {
                    return UITableViewCell()
                }
                
                let brandData = self.eventPostData?[indexPath.row].offers?.categoriesBrand
                
                var brandOffer : [BrandOffer]?
                
                //                brandOffer?.append(brandData?.filter(
                //                    { $0.brandOffer?.filter({($0 as? BrandOffer) != nil}) as? BrandOffer != nil ? true : false
                //
                //                }))
                
                //                brandOffer?.append(
                //                    ((brandData?.filter(
                //                        {
                //                            $0.brandOffer?.filter(
                //                                {
                //                                    ($0 as? BrandOffer)  != nil
                //
                //                                }
                //                                ) as? BrandOffer != nil
                //
                //                        }
                //                        )
                //                        ) as? BrandOffer)!)
                
                let newData = brandData?.filter({$0.brandOffer?.filter({$0 != nil}) != nil })
                
                
                
                var brandOffear = [[BrandOffer]]()
                
                for i in 0..<(newData?.count ?? 0) {
                    
                    brandOffear.append((newData?[i].brandOffer!)! as [BrandOffer])
                    
                }
                
                let kllaKllaIndexOfBrandOffer = brandOffear.flatMap({$0})
                
                print(brandOffear)
                
                if kllaKllaIndexOfBrandOffer.count == 0 {
                    
                    cell.offerView_height.constant = 0
                    
                    cell.offer_View.isHidden = true
                    
                    
                }else {
                    
                    cell.brandArray = kllaKllaIndexOfBrandOffer
                    cell.offerView_height.constant = 230.5
                    
                    cell.offer_View.isHidden = false
                    
                    
                }
                
                
                
                //                cell.brandArray = ((((self.postListingArray[indexPath.row])["offers"] as! [String: AnyObject])["categories_brand"] as! [[String: AnyObject]])[0]["brand_offer"] as! [[String: AnyObject]])
                //
                // cell.offerTitle_lbl.text! = String(describing: ((self.postListingArray[indexPath.row])["offers"] as! [String: AnyObject])["name"]!)
                
                cell.offers_CollectionView.reloadData()
                
                cell.viewAll_btn.tag = indexPath.row
                cell.viewAll_btn.addTarget(self, action: #selector(viewAllProduct(_:)), for: .touchUpInside)
                
                return cell
                
            }else if indexPath.row == 7{
                
                let cell = self.eventAndPost_TableView.dequeueReusableCell(withIdentifier: "LatestBlogTableViewCell") as! LatestBlogTableViewCell
                
                cell.blogViewAll_btn.tag = indexPath.row
                
                cell.condition = "blogs"
                
                if ((self.postListingArray[indexPath.row])["blogs"] as? [String: AnyObject]) == nil {
                    
                    cell.latestBlogView_height.constant = 0
                    
                    cell.blogViewAll_btn.isHidden = true
                    
                    cell.latestBlogsValue_lbl.isHidden = true
                    
                    cell.point_ImageView.isHidden = true
                    
                }else {
                    
                    
                    cell.latestBlogView_height.constant = 176
                    
                    cell.blogViewAll_btn.isHidden = false
                    
                    cell.latestBlogsValue_lbl.isHidden = false
                    
                    cell.point_ImageView.isHidden = false
                    
                    
                    do {
                        
                        let data = [
                            "id": 1,
                            "categories_name": "",
                            "categories_image": "",
                            "status": "active",
                            "created_at": "2019-09-13T04:59:39.000Z",
                            "updated_at": "2019-10-11T06:56:27.000Z",
                            "categories_blog": (((self.postListingArray[indexPath.row])["blogs"] as! [String: AnyObject])["categories_blog"] as! [[String: AnyObject]])
                            ] as [String : AnyObject]
                        
                        let bd = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        
                        cell.blogsData = try newJSONDecoder().decode(Blog.self, from: bd)
                        
                        cell.latestBlogsValue_lbl.text! = String(describing: ((self.postListingArray[indexPath.row])["blogs"] as! [String: AnyObject])["categories_name"]!)
                        
                        cell.latestBlogView_height.constant = 176
                        
                    }catch {
                        
                    }
                    
                }
                
                cell.blogs_CollectionView.reloadData()
                
                cell.blogViewAll_btn.addTarget(self, action: #selector(tapViewAllBlog_btn(_:)), for: .touchUpInside)
                
                return cell
            }
                
            else {
                
                let cell = self.eventAndPost_TableView.dequeueReusableCell(withIdentifier: "SeePostsTableViewCell") as! SeePostsTableViewCell
                
                if String(describing:((self.postListingArray[indexPath.row])["user_uploading_post"]!)) != "<null>" {
                    
                    if String(describing: (self.postListingArray[indexPath.row])["caption"]!) == "" {
                        
                        cell.postDescription_lbl.text! = ""
                        
                    }else {
                        
                        cell.postDescription_lbl.text! = String(describing: (self.postListingArray[indexPath.row])["caption"]!)
                        
                    }
                    
                }else {
                    
                    if String(describing: (self.postListingArray[indexPath.row])["caption"]!) == "" {
                        
                        cell.postDescription_lbl.text! = ""
                        
                    }else {
                        
                        cell.postDescription_lbl.text! = String(describing: (self.postListingArray[indexPath.row])["caption"]!)
                        
                    }
                }
                
                
                cell.nav = self.navigationController
                cell.postTime_lbl.text! = dateCalculator(createdDate: String(describing: (self.postListingArray[indexPath.row])["created_at"]!))
                
                if self.eventPostData?[indexPath.row].userUploadingPost != nil {
                    cell.education_View.isHidden = false
                    cell.educationView_height.constant = 20
                    
                    cell.educationLabel_top.constant = 4
                    
                    cell.educationbottom_down.constant = 4
                    
                    if (self.eventPostData?[indexPath.row].postThroughGroup ??  "") == "no"{
                        
                        cell.group_View.isHidden = true
                        
                        //                        cell.groupImageView_Width.constant = 0
                        //                        cell.groupNameImageView_Height.constant = 0
                        
                        cell.userName_lbl.text! = self.eventPostData?[indexPath.row].userUploadingPost?.username ?? ""
                        
                        cell.userEducation_lbl.text! = "Studying at " +  (self.eventPostData?[indexPath.row].userUploadingPost?.userUniversitySchool?.name ?? "")
                        
                        cell.userProfile_ImageView.sd_setImage(with: URL(string: profileImageUrl + (self.eventPostData?[indexPath.row].userUploadingPost?.profileImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                        
                    }else {
                        
                        
                        cell.group_View.isHidden = false
                        //                        cell.groupImageView_Width.constant = 20
                        //                        cell.groupNameImageView_Height.constant = 20
                        
                        cell.userName_lbl.text! = self.eventPostData?[indexPath.row].postTagGroup?.first?.postgroup?.groupName ?? ""
                        
                        
                        cell.userEducation_lbl.text! = "Studying at " + (self.eventPostData?[indexPath.row].userUploadingPost?.userUniversitySchool?.name ?? "")
                        
                        
                        cell.userProfile_ImageView.sd_setImage(with: URL(string: profileImageUrl + (self.eventPostData?[indexPath.row].postTagGroup?.first?.postgroup?.groupImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                        
                        cell.groupName_lbl.text! = self.eventPostData?[indexPath.row].userUploadingPost?.username ?? ""
                        
                    }
                    
                }else {
                    
                    cell.userEducation_lbl.text! = ""
                    
                    cell.education_View.isHidden = true
                    cell.educationView_height.constant = 0
                    
                    cell.educationLabel_top.constant = 0
                    
                    cell.educationbottom_down.constant = 0
                    
                    
                    if (self.eventPostData?[indexPath.row].postThroughGroup ??  "") == "no"{
                        
                        cell.group_View.isHidden = true
                        
                        //                        cell.groupImageView_Width.constant = 0
                        //                        cell.groupNameImageView_Height.constant = 0
                        
                        cell.userName_lbl.text! = self.eventPostData?[indexPath.row].adminUploadingPost?.username ?? ""
                        
                        cell.userProfile_ImageView.sd_setImage(with: URL(string: profileImageUrl + (self.eventPostData?[indexPath.row].adminUploadingPost?.image ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                        
                    }else {
                        
                        cell.group_View.isHidden = false
                        
                        //                         cell.groupImageView_Width.constant = 20
                        //                        cell.groupNameImageView_Height.constant = 20
                        
                        cell.userName_lbl.text! = self.eventPostData?[indexPath.row].postTagGroup?.first?.postgroup?.groupName ?? ""
                        
                        cell.userProfile_ImageView.sd_setImage(with: URL(string: profileImageUrl + (self.eventPostData?[indexPath.row].postTagGroup?.first?.postgroup?.groupImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                        
                        cell.groupName_lbl.text! = self.eventPostData?[indexPath.row].adminUploadingPost?.username ?? ""
                        
                    }
                    
                    
                }
                
                cell.profileName_btn.tag = indexPath.row
                cell.profileName_btn.addTarget(self, action: #selector(tapProfile_btn(_:)), for: .touchUpInside)
                
                cell.comment_btn.tag = indexPath.row
                cell.showComment_btn.tag = indexPath.row
                
                cell.viewAllComment_btn.tag = indexPath.row
                
                cell.viewAllComment_btn.addTarget(self
                    , action: #selector(tapComment_btn(_:)), for: .touchUpInside)
                
                cell.showComment_btn.addTarget(self
                    , action: #selector(tapComment_btn(_:)) , for: .touchUpInside)
                
                cell.comment_btn.addTarget(self, action: #selector(tapComment_btn(_:)), for: .touchUpInside)
                
                if ((self.postListingArray[indexPath.row])["post_attachments"] as! [[String: AnyObject]]).count == 0 {
                    
                    cell.postSlider_Height.constant = 0
                    cell.postImage_Slider.isHidden = true
                    cell.postCountPageControl_Width.constant = 0
                    
                    cell.postCountPageControl_height.constant = 0
                    cell.postCount_PageControl.isHidden = true
                    cell.postImage_Slider.reloadData()
                    cell.seeAllPost_CollectionView.reloadData()
                    cell.postCount_PageControl.numberOfPages = 0
                    //print("empty Array 0")
                    cell.postImage_Slider.reloadData()
                    cell.seeAllPost_CollectionView.reloadData()
                    
                }else if ((self.postListingArray[indexPath.row])["post_attachments"] as! [[String: AnyObject]]).count == 1 {
                    
                    cell.postSlider_Height.constant = 288
                    
                    //                    cell.postImage_Slider.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    //                    cell.postImage_Slider.translatesAutoresizingMaskIntoConstraints = true
                    cell.postImage_Slider.isHidden = false
                    
                    cell.postCountPageControl_height.constant = 0
                    
                    cell.postCount_PageControl.isHidden = true
                    
                    cell.postCountPageControl_Width.constant = 0
                    
                    cell.postImageData = ((self.postListingArray[indexPath.row])["post_attachments"] as! [[String: AnyObject]])
                    print(((self.postListingArray[indexPath.row])["post_attachments"] as! [[String: AnyObject]]))
                    
                    cell.postCount_PageControl.numberOfPages = ((self.postListingArray[indexPath.row])["post_attachments"] as! [[String: AnyObject]]).count
                    
                    cell.postImage_Slider.reloadData()
                    
                    cell.seeAllPost_CollectionView.reloadData()
                    
                }else {
                    
                    cell.postSlider_Height.constant = 288
                    cell.postImage_Slider.isHidden = false
                    //                    cell.postImage_Slider.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    //                    cell.postImage_Slider.translatesAutoresizingMaskIntoConstraints = true
                    cell.postCountPageControl_height.constant = 30
                    
                    cell.postCount_PageControl.isHidden = false
                    
                    cell.postCountPageControl_Width.constant = 100
                    
                    cell.postImageData = ((self.postListingArray[indexPath.row])["post_attachments"] as! [[String: AnyObject]])
                    print(((self.postListingArray[indexPath.row])["post_attachments"] as! [[String: AnyObject]]))
                    
                    cell.postCount_PageControl.numberOfPages = ((self.postListingArray[indexPath.row])["post_attachments"] as! [[String: AnyObject]]).count
                    
                    cell.postImage_Slider.reloadData()
                    
                    cell.seeAllPost_CollectionView.reloadData()
                    
                }
                
                //cell.seeAllPost_CollectionView.reloadData()
                
                //            cell.postImage_Slider.reloadData()
                
                if  ((self.postListingArray[indexPath.row])["post_comments"] as! [[String: AnyObject]]).count == 0 {
                    
                    cell.viewAllComment_btn.setTitle(String(describing: ((self.postListingArray[indexPath.row])["post_comments"] as! [[String: AnyObject]]).count) + " Comment  ", for: .normal)
                    
                    
                }else {
                    
                    cell.viewAllComment_btn.setTitle("View All " + String(describing: ((self.postListingArray[indexPath.row])["post_comments"] as! [[String: AnyObject]]).count) + " Comments", for: .normal)
                    
                }
                
                if   ((self.postListingArray[indexPath.row])["post_likes"] as! [[String: AnyObject]]).count == 0 {
                    
                    cell.likesCount_lbl.text! = "Like"
                    
                }else {
                    
                    cell.likesCount_lbl.text! = String(describing: ((self.postListingArray[indexPath.row])["post_likes"] as! [[String: AnyObject]]).count)  + " Likes"
                    
                }
                
                cell.commentUserName_lbl.text! = UserData().name
                cell.commentUserTag_lbl.text! =  "@" + UserData().name
                
                if (UserData().userId) ==  String(self.eventPostData?[indexPath.row].userID ?? -1) {
                    cell.delete_btn.isHidden = false
                    cell.threeDot_btn.isHidden = true
                    cell.send_btn.isHidden = true
                    cell.deleteButton_Width.constant = 20
                    
                }else {
                    
                    cell.send_btn.isHidden = false
                    cell.threeDot_btn.isHidden = false
                    
                    cell.delete_btn.isHidden = true
                    cell.deleteButton_Width.constant = 0
                    
                }
                
                if UserData().image == "" {
                    
                    cell.commentUserprofile_Image.image = UIImage(named: "noimage_icon")
                }else {
                    
                    cell.commentUserprofile_Image.sd_setImage(with: URL(string: profileImageUrl + UserData().image), placeholderImage: UIImage(named: "noimage_icon"))
                    
                }
                
                cell.like_btn.tag = indexPath.row
                
                //                cell.send_btn.tag = indexPath.row
                //
                //                cell.send_btn.addTarget(self, action: #selector(tapSharePost_btn(_:)), for: .touchUpInside)
                
                cell.like_btn.addTarget(self, action: #selector(self.tapLike_btn(_:)), for: .touchUpInside)
                
                cell.viewLikes_btn.tag = indexPath.row
                cell.viewLikes_btn.addTarget(self, action: #selector(viewAllLike(_:)), for: .touchUpInside)
                cell.description_btn.tag = indexPath.row
                
                cell.description_btn.addTarget(self, action: #selector(tapOpenUrl_btn(_:)), for: .touchUpInside)
                cell.send_btn.tag = indexPath.row
                
                cell.send_btn.addTarget(self, action: #selector(tapSharePost(_:)), for: .touchUpInside)
                
                if ((self.postListingArray[indexPath.row])["user_post_like"] as! [[String: AnyObject]]).count == 0 {
                    
                    cell.like_btn.setImage(UIImage(named: "hrt-30"), for: .normal)
                    
                    
                }else {
                    
                    cell.like_btn.setImage(UIImage(named: "hrtRed_Icon"), for: .normal)
                    
                }
                
                cell.threeDot_btn.tag = indexPath.row
                
                cell.threeDot_btn.addTarget(self, action: #selector(tapThreeDot_btn(_:)), for: .touchUpInside)
                
                cell.delete_btn.tag = indexPath.row
                
                cell.delete_btn.addTarget(self, action: #selector(deletePost_btn(_:)), for: .touchUpInside)
                
                return cell
                
            }
            
        }else {
            
            if indexPath.row == 3 {
                
                guard let cell = self.eventAndPost_TableView.dequeueReusableCell(withIdentifier: "TrendingTableViewCell") as? TrendingTableViewCell else {
                    return UITableViewCell()
                }
                
                
                let brandData = self.eventPostData?[indexPath.row].offers?.categoriesBrand
                
                var brandOffer : [BrandOffer]?
                
                //                brandOffer?.append(brandData?.filter(
                //                    { $0.brandOffer?.filter({($0 as? BrandOffer) != nil}) as? BrandOffer != nil ? true : false
                //
                //                }))
                
                //                brandOffer?.append(
                //                    ((brandData?.filter(
                //                        {
                //                            $0.brandOffer?.filter(
                //                                {
                //                                    ($0 as? BrandOffer)  != nil
                //
                //                                }
                //                                ) as? BrandOffer != nil
                //
                //                        }
                //                        )
                //                        ) as? BrandOffer)!)
                
                let newData = brandData?.filter({$0.brandOffer?.filter({$0 != nil}) != nil })
                var brandOffear = [[BrandOffer]]()
                
                for i in 0..<(newData?.count)! {
                    
                    brandOffear.append((newData?[i].brandOffer!)! as [BrandOffer])
                    
                }
                
                let kllaKllaIndexOfBrandOffer = brandOffear.flatMap({$0})
                
                print(brandOffear)
                
                cell.brandArray = kllaKllaIndexOfBrandOffer
                
                cell.offerTitle_lbl.text! = String(describing: ((self.postListingArray[indexPath.row])["offers"] as! [String: AnyObject])["name"]!)
                
                cell.viewAll_btn.tag = indexPath.row
                cell.viewAll_btn.addTarget(self, action: #selector(viewAllProduct(_:)), for: .touchUpInside)
                
                return cell
                
            }else if indexPath.row == 7{
                
                let cell = self.eventAndPost_TableView.dequeueReusableCell(withIdentifier: "LatestBlogTableViewCell") as! LatestBlogTableViewCell
                
                cell.condition = "blogs"
                
                do {
                    
                    let data = [
                        "id": 1,
                        "categories_name": "",
                        "categories_image": "",
                        "status": "active",
                        "created_at": "2019-09-13T04:59:39.000Z",
                        "updated_at": "2019-10-11T06:56:27.000Z",
                        "categories_blog": ((self.postListingArray[indexPath.row])["blogs"] as! [[String: AnyObject]])
                        ] as [String : AnyObject]
                    
                    let bd = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    
                    cell.blogsData = try newJSONDecoder().decode(Blog.self, from: bd)
                    
                    cell.latestBlogsValue_lbl.text! = String(describing: ((self.postListingArray[indexPath.row])["blogs"] as! [String: AnyObject])["categories_name"]!)
                    
                    
                }catch {
                    
                    
                }
                
                cell.blogViewAll_btn.tag = indexPath.row
                
                cell.blogViewAll_btn.addTarget(self, action: #selector(tapViewAllBlog_btn(_:)), for: .touchUpInside)
                
                return cell
                
            }else {
                
                return UITableViewCell()
            }
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // if indexPath.row ==  count {
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
    // MARK: Cell Button Action
    @objc func tapComment_btn(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CoomentsViewController") as! CoomentsViewController
        
        vc.postId = String(describing: (self.postListingArray[sender.tag])["id"]!)
        
        print(String(describing: (self.postListingArray[sender.tag])["id"]!))
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func tapThreeDot_btn(_ sender: UIButton){
        
        guard let popoverContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReportPostOrUserViewController") as? ReportPostOrUserViewController else {return}
        
        popoverContent.controller = self
        
        popoverContent.postUserId = String(self.eventPostData?[sender.tag].userID ?? 0)
        
        popoverContent.postId = String(self.eventPostData?[sender.tag].id ?? 0)
        
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
        
        popoverContent.preferredContentSize = CGSize(width: 200, height: 60)
        
        let popOver = popoverContent.popoverPresentationController
        
        popOver?.delegate = self
        //
        popOver?.sourceView = sender
        //
        
        // popOver?.sourceView = sender
        popOver?.sourceRect = sender.bounds
        //
        popOver?.permittedArrowDirections = [.up]
        
        
        self.present(popoverContent, animated: true, completion: nil)
    }
    
    @objc func viewAllProduct(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBrandsViewController") as! ViewAllBrandsViewController
        
        
        let brandData = self.eventPostData?[sender.tag].offers?.categoriesBrand
        
        var brandOffer : [BrandOffer]?
        
        //                brandOffer?.append(brandData?.filter(
        //                    { $0.brandOffer?.filter({($0 as? BrandOffer) != nil}) as? BrandOffer != nil ? true : false
        //
        //                }))
        
        //                brandOffer?.append(
        //                    ((brandData?.filter(
        //                        {
        //                            $0.brandOffer?.filter(
        //                                {
        //                                    ($0 as? BrandOffer)  != nil
        //
        //                                }
        //                                ) as? BrandOffer != nil
        //
        //                        }
        //                        )
        //                        ) as? BrandOffer)!)
        
        let newData = brandData?.filter({$0.brandOffer?.filter({$0 != nil}) != nil })
        var brandOffear = [[BrandOffer]]()
        
        for i in 0..<(newData?.count)! {
            
            brandOffear.append((newData?[i].brandOffer!)! as [BrandOffer])
            
        }
        
        let kllaKllaIndexOfBrandOffer = brandOffear.flatMap({$0})
        
        print(brandOffear)
        
        vc.brandArray = kllaKllaIndexOfBrandOffer
        
        vc.navigationTitle = String(describing: ((self.postListingArray[sender.tag])["offers"] as! [String: AnyObject])["name"]!)
        
        vc.condition = ""
        
        // self.dismiss(animated: true, completion: nil)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @objc func tapViewAllBlog_btn(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBlogViewController") as! ViewAllBlogViewController
        
        vc.isUserFromCategory = true
        
        vc.navigationTitle = String(describing: ((self.postListingArray[sender.tag])["blogs"] as! [String: AnyObject])["categories_name"]!)
        
        vc.categoryId = Int(String(describing: ((self.postListingArray[sender.tag])["blogs"] as! [String: AnyObject])["id"]!)) ?? 0
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapProfile_btn(_ sender: UIButton) {
        
        if  String(((self.postListingArray[sender.tag])["user_id"] as? Int ?? 0)) == UserData().userId {
            
        }else if ((self.postListingArray[sender.tag])["post_through_group"] as? String ?? "") == "yes" {
            
        }else if String(describing:((self.postListingArray[sender.tag])["user_uploading_post"]!)) == "<null>"{
            
        }else {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewProfileViewController") as! ViewProfileViewController
            
            vc.post_id = String(((self.postListingArray[sender.tag])["user_id"] as? Int ?? 0))
            
            vc.postUser_id = String(((self.postListingArray[sender.tag])["user_id"] as? Int ?? 0))
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    @objc func tapLike_btn(_ sender: UIButton) {
        
        self.likePost(post_id: String(describing: (self.postListingArray[sender.tag])["id"]!), user_id: UserData().userId, index: sender.tag)
        
    }
    
    
    @objc func viewAllLike(_ sender: UIButton) {
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LikesViewController") as! LikesViewController
        
        vc.Id = String(describing: (self.postListingArray[sender.tag])["id"]!)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapSharePost_btn(_ sender: UIButton){
        
        let text =  ""
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    @objc func tapOpenUrl_btn(_ sender: UIButton) {
        
        if (self.eventPostData?[sender.tag].caption ?? "").hasPrefix("https://") {
            UIApplication.shared.open(URL(string: self.eventPostData?[sender.tag].caption ?? "")! , options: [:], completionHandler: nil)
            
        }else {
            
        }
    }
    
    @objc func tapSharePost(_ sender: UIButton){
        
        self.showAlertWithActionOkandCancel(Title: "Unilife", Message: "Would you like to share this post", OkButtonTitle: "Ok", CancelButtonTitle: "Cancel"){
            
            self.sharePostToUsers(post_id: String(describing: (self.postListingArray[sender.tag])["id"]!), user_id: UserData().userId)
        }
        
    }
    
}
*/

extension EventAndPostViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}

// MARK: - Service Response

extension EventAndPostViewController{
    
    
    func getAspectRatioAccordingToiPhones(cellImageFrame:CGSize,downloadedImage: UIImage)->CGFloat {
        let widthOffset = downloadedImage.size.width - cellImageFrame.width
        
        let widthOffsetPercentage = (widthOffset*100)/downloadedImage.size.width
        
        let heightOffset = (widthOffsetPercentage * downloadedImage.size.height)/100
        
        let effectiveHeight = downloadedImage.size.height - heightOffset
        return(effectiveHeight)
    }
    // MARK: - Post Listing Service
    
    func postListing() {
        /*
        Indicator.shared.showProgressView(self.view)
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "show_post/\(UserData().userId)") {[weak self] (receviedData) in
            
              print(receviedData)
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self?.postListingArray = receviedData["data"] as! [[String: AnyObject]]
                    
                    
                    guard let data = receviedData["data"] as? [[String: AnyObject]]else {
                        
                        return
                    }
                    
                    do {
                        
                        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        
                        self?.eventPostData = try JSONDecoder().decode(EventAndPostModel.self, from: jsonData!)
                        
                        let arrayData = (self?.eventPostData?.count ?? 0)
                        
                        
                        
                        for i in 0..<arrayData  {
                            
                            let getImagesArray = self?.eventPostData?[i].postAttachments?.count ?? 0
                            
                            
                            for i in 0..<getImagesArray {
                                
                                //self?.getPostSizes?[i].imgSize.append(self.get)
                                
                            }
                            
                            
                        }
                        
                    }catch{
                        
                        print(error.localizedDescription)
                        
                    }
                    
                    self?.eventAndPost_TableView.reloadData()
                    
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                }
                
            }else {
                
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
        }
        */
        
        

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
                  "pagination":"1",
                  "source":"ios",
                  "version":ConstantsHelper.version
              ]
              Indicator.shared.showProgressView(self.view)
          //ApplicationManager.instance.startloading()
            print(params)
              print(ConstantsHelper.HomeURL)
              WebServiceManager.shared.callWebService_Home(ConstantsHelper.HomeURL, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
                  
                 
                  if(response is NSDictionary)
                  {
                     print(response)
                      let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                      if(status == true)
                      {
                        self.aryHomeData.removeAllObjects()
                        let getData = (response as! NSDictionary).value(forKey: "data") as? NSArray ?? NSArray()
                        self.aryHomeData = getData.mutableCopy() as? NSMutableArray ?? NSMutableArray()
                        if(self.aryHomeData.count == 0)
                        {
                            self.viwNoRecord.isHidden = false
                        }else
                        {
                            self.viwNoRecord.isHidden = true
                        }
                       // print(self.aryHomeData.count)
                        self.eventAndPost_TableView.reloadData()
                        if(self.aryHomeData.count > 0)
                        {
                            self.pageNO = 2
                            self.stop_loader_myFeed = false
                        }else
                        {
                            self.stop_loader_myFeed = true
                        }
                        self.isLoadingMore = false
                      }else
                      {
                          let getMessage = (response as! NSDictionary).value(forKey: "message") as? String ?? ""
                        if(getMessage == kExpireVersion)
                        {
                            showExpireVersionAlert()
                        }else
                        {
                         Singleton.sharedInstance.customAlert(getMSG: getMessage)
                        }
                          
                      }
                  }else
                  {
                      Indicator.shared.hideProgressView()
                      
                    
                      Singleton.sharedInstance.customAlert(getMSG: API_FAILED)
                  }
                
                
                  
                  
              }
        
        func showExpireVersionAlert() {
               
               let alert = UIAlertController(title: VERSION_EX_TITLE, message: VERSION_EX_MSG, preferredStyle: UIAlertController.Style.alert)
               //         alert.setValue(NSAttributedString(title: ""!, attributes: [NSAttributedStringKey.font : UIFont(name: "Montserrat-Regular", size: 14) as Any,NSAttributedStringKey.foregroundColor : UIColor(red: 168/255, green: 12/255, blue: 94/255, alpha: 1.0)]), forKey: "attributedTitle")
               let galleryAction: UIAlertAction = UIAlertAction(title: "UPDATE NOW", style: .default) { action -> Void in
                         let url = NSURL(string:appURL)! as URL
                                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                         
                      }
            alert.addAction(galleryAction)
               alert.view.tintColor = UIColor.appSkyBlue
               self.present(alert, animated: true, completion: nil)
               
           }
        
    }
    
    
    func postListing_loadMore() {
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
                "pagination":"\(self.pageNO)"
              ]
              Indicator.shared.showProgressView(self.view)
          //ApplicationManager.instance.startloading()
            print(params)
              print(ConstantsHelper.HomeURL)
              WebServiceManager.shared.callWebService_Home(ConstantsHelper.HomeURL, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
                  
                 
                  if(response is NSDictionary)
                  {
                      
                     print(response)
                      let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                      if(status == true)
                      {
                       
                        let getData = (response as! NSDictionary).value(forKey: "data") as? NSArray ?? NSArray()
                        self.aryHomeData.addObjects(from: getData as [AnyObject])
                        self.eventAndPost_TableView.reloadData()
                        
                        
                        if(self.aryHomeData.count > 0)
                        {
                            self.pageNO = self.pageNO + 1
                            self.stop_loader_myFeed = false
                        }else
                        {
                            self.stop_loader_myFeed = true
                        }
                        self.isLoadingMore = false
                        self.spinner.isHidden = true
                        self.spinner.hidesWhenStopped = true
                        self.eventAndPost_TableView?.tableFooterView?.isHidden = true
                        self.eventAndPost_TableView?.reloadData()
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
    
    // MARK: - Like Post Service Response 
    
    
    func likePost(post_id: String, user_id: String, index: Int) {
        
       // Indicator.shared.showProgressView(self.view)
        
        let param = ["post_id": post_id, "user_id": user_id] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "like_unlike_post", params: param as [String: AnyObject]) { [weak self] (receviedData) in
            
            //guard let self = self else {return}
            
            print(receviedData)
            
           // Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    //                (((receviedData as? [String: AnyObject])? ["data"] as? [String: AnyObject])? ["rows"] as? [[String: AnyObject]])
                    
                    // (((((receviedData as? [String: AnyObject])? ["data"] as? [String: AnyObject])? ["rows"] as? [[String: AnyObject]])?[0])?["user_id"] as? Int ?? -1)
                    
                    //                    if self?.eventPostData?[index].userPostLike?.count == 0 {
                    //
                    //                        let likeData = PostLike(id: (((((receviedData as? [String: AnyObject])? ["data"] as? [String: AnyObject])? ["rows"] as? [[String: AnyObject]])?[0])?["user_id"] as? Int ?? -1), postCommentID: (((((receviedData as? [String: AnyObject])? ["data"] as? [String: AnyObject])? ["rows"] as? [[String: AnyObject]])?[0])?["post_comment_id"] as? Int ?? -1), userID: Int(UserData().userId), type: (TypeEnum(rawValue: ((((receviedData as? [String: AnyObject])? ["data"] as? [String: AnyObject])? ["rows"] as? [[String: AnyObject]])?[0])?["type"] as? String ?? "")), createdAt: (((((receviedData as? [String: AnyObject])? ["data"] as? [String: AnyObject])? ["rows"] as? [[String: AnyObject]])?[0])?["created_at"] as? String ?? ""), updatedAt: (((((receviedData as? [String: AnyObject])? ["data"] as? [String: AnyObject])? ["rows"] as? [[String: AnyObject]])?[0])?["updated_at"] as? String ?? ""))
                    //                        self?.eventPostData?[index].userPostLike?.append(likeData)
                    //                    }else {
                    //                        self?.eventPostData?[index].userPostLike?.remove(at: 0)
                    //                    }
                    //                    self?.eventAndPost_TableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                    
                  //  self?.postListing()
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
        }
        
    }
    
    // MARK: - Share Post
    
    func sharePostToUsers(post_id: String,user_id: String ) {
        /*
        Indicator.shared.showProgressView(self.view)
        
        let param = ["post_id": post_id, "user_id": user_id] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "shareUserPost", params: param as [String: AnyObject]) { [weak self] (receviedData) in
            
            //guard let self = self else {return}
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    //                (((receviedData as? [String: AnyObject])? ["data"] as? [String: AnyObject])? ["rows"] as? [[String: AnyObject]])
                    
                    // (((((receviedData as? [String: AnyObject])? ["data"] as? [String: AnyObject])? ["rows"] as? [[String: AnyObject]])?[0])?["user_id"] as? Int ?? -1)
                    
                    
                    //self?.postListing()
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
        }
        
        */
        
    }
    
    // MARK: - Delete Post Service Response
    
    func deletePost(user_id: String,post_id: String, tableViewIndex: Int){
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": user_id,"post_id": post_id] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "delete-user-post", params: param as [String: AnyObject]){ [weak self] (receviedData) in
            Indicator.shared.hideProgressView()
            
            guard let self = self else {return}
            
            print(receviedData)
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    //                    self.eventPostData?.remove(at: tableViewIndex)
                    //                    self.eventAndPost_TableView.reloadRows(at: [IndexPath(row: tableViewIndex, section: 0)], with: .none)
                    
                    self.postListing()
                }else {
                    self.showDefaultAlert(Message: receviedData["message"] as! String)
                    
                }
                
            }else {
                
                self.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
        }
        
    }
    
    
    // MARK: - Delete Button Action
    
    @objc func deletePost_btn(_ sender: UIButton){
        
        
        self.showAlertWithActionOkandCancel(Title: "Unilife", Message: "Would you like to delete this post", OkButtonTitle: "Ok", CancelButtonTitle: "Cancel"){
            
            self.deletePost(user_id: UserData().userId, post_id: String(self.eventPostData?[sender.tag].id ?? -2), tableViewIndex: sender.tag)
            
        }
        
    }
    
    
    
    func connection_selectPoll(post_id: String,getindex:Int)
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
            "option_id":post_id
        ]
        //  Indicator.shared.showProgressView(self.view)
        
        // print(params)
        //      print(ConstantsHelper.select_poll_option)
        WebServiceManager.shared.callWebService_Home(ConstantsHelper.select_poll_option, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
            
            
            
            if(response is NSDictionary)
            {
                
                //   print(response)
                let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                if(status == true)
                {
                    
                    
                    
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
    
    func connection_DeletePost(post_id: String,getIndex:Int)
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
               "post_id":post_id
           ]
              Indicator.shared.showProgressView(self.view)
           //ApplicationManager.instance.startloading()
          // print(params)
          //      print(ConstantsHelper.select_poll_option)
           WebServiceManager.shared.callWebService_Home(ConstantsHelper.delete_post, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
               
             
               
               if(response is NSDictionary)
               {
                   
                //  print(response)
                   let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                   if(status == true)
                   {
                     let getMessage = (response as! NSDictionary).value(forKey: "message") as? String ?? ""
                     Singleton.sharedInstance.customAlert(getMSG: getMessage)
                    print(self.aryHomeData.count)
                      self.aryHomeData.removeObject(at: getIndex)
                      self.eventAndPost_TableView.reloadData()
                    print(self.aryHomeData.count)
                    /*
                    let getindex = IndexPath(row: getIndex, section: 0)
                    self.eventAndPost_TableView.beginUpdates()
                    self.eventAndPost_TableView.deleteRows(at: [getindex], with: .automatic)
                    self.eventAndPost_TableView.endUpdates()
                    */
                   }else
                   {
                       let getMessage = (response as! NSDictionary).value(forKey: "message") as? String ?? ""
                      Singleton.sharedInstance.customAlert(getMSG: getMessage)
                       
                   }
                   Indicator.shared.hideProgressView()
               }else
               {
                   Indicator.shared.hideProgressView()
                   
                 
                   Singleton.sharedInstance.customAlert(getMSG: API_FAILED)
               }
               
               
           }
           
       }
}




//------------------------------------------------------
// MARK: Protocol for image popup     ------
//------------------------------------------------------

extension EventAndPostViewController:imgPopupProtocol
{
    func gotobackDelegate()
    {
         unblurViewX()
    }
}

//------------------------------------------------------
// MARK: Protocol for image popup     ------
//------------------------------------------------------

extension EventAndPostViewController:deletePressPostProtocol
{
    func didTapDelete(getID:String,getIndex:Int)
    {
        print("------->Get Index",getIndex)
        connection_DeletePost(post_id: getID, getIndex: getIndex)
       
    }
}



extension EventAndPostViewController
{
func connection_ProfileHeader()
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
        Indicator.shared.showProgressView(self.view)
    //ApplicationManager.instance.startloading()
  
        print(ConstantsHelper.get_all_profile_data)
        WebServiceManager.shared.callWebService_Home(ConstantsHelper.get_all_profile_data, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
            
          
            
            if(response is NSDictionary)
            {
                
               print(response)
                let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                if(status == true)
                {
                    
                    let respoonseInside = (response as! NSDictionary).value(forKey: "respoonse") as? NSDictionary ?? NSDictionary()
                  
                    let self_intoduction = (response as! NSDictionary).value(forKey: "self_intoduction") as? NSDictionary ?? NSDictionary()
                   let getStatus:String = self_intoduction.value(forKey: "designation") as? String ?? ""
                   let getOrgani:String = self_intoduction.value(forKey: "organisation") as? String ?? ""
                    
                    UserDefaults.standard.set(getStatus + " at " + getOrgani, forKey: "_heading")
                        //.value(forKey: "_heading") as? String ?? ""
                    
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
    
    
    func connection_RegisCountSend(getEventID:Int,getIndex:Int)
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
              "event_id":getEventID
          ] as [String : Any]
          Indicator.shared.showProgressView(self.view)
      //ApplicationManager.instance.startloading()
      print(params)
          print(ConstantsHelper.event_link_counter_hit)
          WebServiceManager.shared.callWebService_Home(ConstantsHelper.event_link_counter_hit, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
              
            
              
              if(response is NSDictionary)
              {
                  
                 print(response)
                  let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                  if(status == true)
                  {
                      
                     
                      
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
