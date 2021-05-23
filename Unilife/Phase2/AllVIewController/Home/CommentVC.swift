//
//  ViewController.swift
//  Trendy
//
//  Created by developer on 17/04/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SDWebImage
import AVKit
import AVFoundation

extension CommentVC: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}


class CommentVC: UIViewController{

    var keyBoardHeight = 0.0
    
    @IBOutlet weak var imgUserProfileEvent: UIImageView!
    @IBOutlet weak var imgUserProfileMedia: UIImageView!
    @IBOutlet weak var imgUserProfileOpinion: UIImageView!
    @IBOutlet weak var lblnameEvent: UILabel!
    @IBOutlet weak var lblnameMedia: UILabel!
    @IBOutlet weak var lblnameOpinion: UILabel!
    @IBOutlet weak var heightOFtbl: NSLayoutConstraint!
    @IBOutlet weak var viwEvent: UIView!
    @IBOutlet weak var viwMedia: UIView!
    @IBOutlet weak var viwOpinion: UIView!
    @IBOutlet weak var viwPoll: UIView!
    
   @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var txtComment: UITextField!
    @IBOutlet weak var botoomSpaceContent: NSLayoutConstraint!
    
    ///....Event
    @IBOutlet weak var lblTimeEvent:UILabel!
       @IBOutlet weak var lblMemberRegisEvent:UILabel!
       @IBOutlet weak var lblDesEvent:UILabel!
       @IBOutlet weak var lblTitleEvent:UILabel!
       @IBOutlet weak var imgEventEvent: UIImageView!
       @IBOutlet weak var btnfavEvent: UIButton!
       @IBOutlet weak var btnCommentEvent: UIButton!
      @IBOutlet weak var btnRegisCount: UIButton!
      @IBOutlet weak var btnfavClickEvent: UIButton!
    
    
    ////... Media
       @IBOutlet weak var lblTimeMedia:UILabel!
       @IBOutlet weak var imgEventMedia: UIImageView!
       @IBOutlet weak var lblDesMedia:UILabel!
       @IBOutlet weak var btnfavMedia: UIButton!
       @IBOutlet weak var btnCommentMedia: UIButton!
       @IBOutlet weak var btnfavClickMedia: UIButton!
      @IBOutlet weak var btnPlayVideoMedia: UIButton!
    
    ////.... opinion
    @IBOutlet weak var lblTimeopinion:UILabel!
      @IBOutlet weak var lblDesopinion:UILabel!
      @IBOutlet weak var imgEventopinion: UIImageView!
      @IBOutlet weak var btnfavopinion: UIButton!
      @IBOutlet weak var btnCommentopinion: UIButton!
    @IBOutlet weak var btnfavClickopinion: UIButton!
    @IBOutlet weak var viwImageopinion: UIView!
    @IBOutlet weak var btnPlayVideoopinion: UIButton!
    
    
    @IBOutlet weak var collectionAccess:UICollectionView!
       @IBOutlet weak var heightOFPollCollection:NSLayoutConstraint!
       
       @IBOutlet weak var lblTitlePoll:UILabel!
       @IBOutlet weak var imgUserProfilePoll: UIImageView!
       @IBOutlet weak var lblNamePoll:UILabel!
       @IBOutlet weak var lblTimePoll:UILabel!
       
       
       @IBOutlet weak var btnfavClickPoll: UIButton!
       @IBOutlet weak var btnCommentClickPoll: UIButton!
       @IBOutlet weak var btnSharePoll: UIButton!
       @IBOutlet weak var btnfavPoll: UIButton!
       @IBOutlet weak var btnCommentPoll: UIButton!
       
    
    @IBOutlet weak var hightOFImage: NSLayoutConstraint!
    
    
     //  @IBOutlet weak var btnYes:UIButton!
     //  @IBOutlet weak var btnNo:UIButton!
       var DataForCollection:NSArray = NSArray()
    var already_hit_button:Bool = false
    
    var getDetail:NSDictionary = NSDictionary()
    var aryComments:NSArray = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdatUI()
        imgUserProfileEvent.sd_setImage(with: URL(string: profileImageUrl + UserData().image), placeholderImage: UIImage(named: "noimage_icon"))
        self.lblnameEvent.text = UserData().name
        self.connection_getComment()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

    }
    override func viewWillAppear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = true
           //self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
                   let crossHome    = UIImage(named: "crossHome")!

                   let backButton   = UIBarButtonItem(image: crossHome,  style: .plain, target: self, action: #selector(CancelBack(sender:)))
                   backButton.tintColor = UIColor.red
                   navigationItem.leftBarButtonItem = backButton
                   
//                    let rightButton   = UIBarButtonItem(title: "Done",  style: .done, target: self, action: #selector(PostButton(sender:)))
//                   rightButton.tintColor = UIColor.unilifeButtonBlueColor
//                   navigationItem.rightBarButtonItem = rightButton
                   navigationItem.title = "Comments"
          
       }

    
    @objc func CancelBack(sender: AnyObject){
              self.navigationController?.popViewController(animated: true)
         }

       

//    @IBAction func click_Back()
//       {
//           self.navigationController?.popViewController(animated: true)
//       }
    
    func UpdatUI()
    {
        
        imgUserProfileEvent.layer.cornerRadius = 78/2
        imgUserProfileEvent.layer.borderColor = UIColor.unilifeblueDark.cgColor
        imgUserProfileEvent.layer.borderWidth = 2.0
        
        tbl?.tableFooterView = UIView()
        tbl?.estimatedRowHeight = 44.0
        tbl?.rowHeight = UITableView.automaticDimension
        self.tbl?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        
        let getType:String = getDetail.value(forKey: "type") as? String ?? ""
          
        
        if(getType == "event")
        {
            self.viwEvent.isHidden = false
            self.viwMedia.isHidden = true
            self.viwOpinion.isHidden = true
            self.viwPoll.isHidden = true
            
            self.imgUserProfileEvent.layer.cornerRadius = 50/2
                       self.imgUserProfileEvent.layer.borderColor = UIColor.unilifeblueDark.cgColor
                       self.imgUserProfileEvent.layer.borderWidth = 2.0
                     
                       let event_description:String = getDetail.value(forKey: "event_description") as? String ?? ""
                       let event_title:String = getDetail.value(forKey: "event_title") as? String ?? ""
                       let comemntCount:Int = getDetail.value(forKey: "post_comments_count") as? Int ?? 0
                       let likeCount:Int = getDetail.value(forKey: "post_like_count") as? Int ?? 0
                        let event_register_count:String = getDetail.value(forKey: "event_register_count") as? String ?? "0"
            let alreadyHit:String = getDetail.value(forKey: "already_hit_button") as? String ?? "no"
            if(alreadyHit == "no")
            {
                self.already_hit_button = false
            }else
            {
                self.already_hit_button = true
            }
                        self.btnRegisCount.setTitle(" \(event_register_count)", for: .normal)
                       self.btnCommentEvent.setTitle(" \(comemntCount)", for: .normal)
                       self.btnfavEvent.setTitle(" \(likeCount)", for: .normal)
                       self.lblDesEvent.text = event_description
                       self.lblMemberRegisEvent.text = "22 Members Registered"
                       self.lblTitleEvent.text = event_title
                       
                       let getuserArray:NSArray = getDetail.value(forKey: "user_uploading_post") as? NSArray ?? NSArray()
                       if(getuserArray.count > 0)
                       {
                           let getUserDetail:NSDictionary = getuserArray.object(at: 0) as? NSDictionary ?? NSDictionary()
                          // print(getUserDetail)
                           self.lblnameEvent.text = getUserDetail.value(forKey: "username") as? String ?? ""
                           let getuserImg:String = getUserDetail.value(forKey: "profile_image") as? String ?? ""
                           self.imgUserProfileEvent.sd_setImage(with: URL(string: getuserImg), placeholderImage: UIImage(named: "userProfile_ImageView"))
                           
                           let getDate:String = getUserDetail.value(forKey: "created_at") as? String ?? ""
                           self.lblTimeEvent.text = ApplicationManager.instance.dateCalculator(createdDate: getDate)
                       }
                       let post_attachments:NSArray = getDetail.value(forKey: "post_attachments") as? NSArray ?? NSArray()
                       if(post_attachments.count > 0)
                       {
                            let getFirstEventDic:NSDictionary = post_attachments.object(at: 0) as? NSDictionary ?? NSDictionary()
                           
                           let imgEvent:String = getFirstEventDic.value(forKey: "attachment") as? String ?? ""
                           
                            self.imgEventEvent.sd_setImage(with: URL(string: imgEvent), placeholderImage: UIImage(named: "noimage_icon"))
                           //let attachment_type:String = getUserDetail.value(forKey: "attachment_type") as? String ?? ""
                       }
                       
                       
                       
                       let islike:Bool = getDetail.value(forKey: "is_like") as? Bool ?? false
                       if(islike == true)
                       {
                         self.btnfavClickEvent.setImage(UIImage.init(named: "hrtRed_Icon2"), for: .normal)
                       }else
                       {
                           self.btnfavClickEvent.setImage(UIImage.init(named: "like_Dark"), for: .normal)
                       }
            
        }else if (getType == "opinion")
        {
            self.viwEvent.isHidden = true
            self.viwMedia.isHidden = true
            self.viwOpinion.isHidden = false
            self.viwPoll.isHidden = true
            
            self.imgUserProfileOpinion.layer.cornerRadius = 50/2
            self.imgUserProfileOpinion.layer.borderColor = UIColor.unilifeblueDark.cgColor
            self.imgUserProfileOpinion.layer.borderWidth = 2.0
            self.viwImageopinion.layer.borderColor = UIColor(red: 220.0/255, green: 220.0/255, blue: 220.0/255, alpha: 1.0).cgColor
            self.viwImageopinion.layer.borderWidth = 0.5
            self.viwImageopinion.layer.cornerRadius = 4
            self.viwImageopinion.layer.masksToBounds = true;
            
            
            let caption:String = getDetail.value(forKey: "caption") as? String ?? ""
            self.lblDesopinion.text = caption
            
            
            let comemntCount:Int = getDetail.value(forKey: "post_comments_count") as? Int ?? 0
            let likeCount:Int = getDetail.value(forKey: "post_like_count") as? Int ?? 0
            self.btnCommentopinion.setTitle(" \(comemntCount)", for: .normal)
            self.btnfavopinion.setTitle(" \(likeCount)", for: .normal)
            
            
            let getuserArray:NSArray = getDetail.value(forKey: "user_uploading_post") as? NSArray ?? NSArray()
            if(getuserArray.count > 0)
            {
                let getUserDetail:NSDictionary = getuserArray.object(at: 0) as? NSDictionary ?? NSDictionary()
                // print(getUserDetail)
                self.lblnameOpinion.text = getUserDetail.value(forKey: "username") as? String ?? ""
                let getuserImg:String = getUserDetail.value(forKey: "profile_image") as? String ?? ""
                self.imgUserProfileOpinion.sd_setImage(with: URL(string: getuserImg), placeholderImage: UIImage(named: "userProfile_ImageView"))
                
                let getDate:String = getUserDetail.value(forKey: "created_at") as? String ?? ""
                self.lblTimeopinion.text = ApplicationManager.instance.dateCalculator(createdDate: getDate)
            }
            
            
            let post_attachments:NSArray = getDetail.value(forKey: "post_attachments") as? NSArray ?? NSArray()
            if(post_attachments.count > 0)
            {
                self.hightOFImage.constant = 150
                 let getFirstEventDic:NSDictionary = post_attachments.object(at: 0) as? NSDictionary ?? NSDictionary()
                
                let imgEvent:String = getFirstEventDic.value(forKey: "attachment") as? String ?? ""
                let imgThumbnail:String = getFirstEventDic.value(forKey: "thumbnail") as? String ?? ""
                
                
                let attachment_type:String = getFirstEventDic.value(forKey: "attachment_type") as? String ?? ""
                if(attachment_type == "video")
                {
                    self.btnPlayVideoopinion.isHidden = false
                    if(imgThumbnail.count > 0)
                    {
                        self.imgEventopinion.sd_setImage(with: URL(string: postImageUrl + imgThumbnail), placeholderImage: UIImage(named: "noimage_icon"))
                    }
                }else
                {
                    self.btnPlayVideoopinion.isHidden = true
                    self.imgEventopinion.sd_setImage(with: URL(string: imgEvent), placeholderImage: UIImage(named: "noimage_icon"))
                }
            }else
            {
                self.hightOFImage.constant = 0
                    self.btnPlayVideoopinion.isHidden = true
            }
            let islike:Bool = getDetail.value(forKey: "is_like") as? Bool ?? false
            if(islike == true)
            {
                self.btnfavClickopinion.setImage(UIImage.init(named: "hrtRed_Icon2"), for: .normal)
            }else
            {
                self.btnfavClickopinion.setImage(UIImage.init(named: "like_Dark"), for: .normal)
            }
            
            
        }else if (getType == "normal")
        {
            self.viwEvent.isHidden = true
            self.viwMedia.isHidden = false
            self.viwOpinion.isHidden = true
            self.viwPoll.isHidden = true
            
            
            self.imgUserProfileMedia.layer.cornerRadius = 50/2
            self.imgUserProfileMedia.layer.borderColor = UIColor.unilifeblueDark.cgColor
            self.imgUserProfileMedia.layer.borderWidth = 2.0
            
           
            let caption:String = getDetail.value(forKey: "caption") as? String ?? ""
            self.lblDesMedia.text = caption
            let comemntCount:Int = getDetail.value(forKey: "post_comments_count") as? Int ?? 0
            let likeCount:Int = getDetail.value(forKey: "post_like_count") as? Int ?? 0
            self.btnCommentMedia.setTitle(" \(comemntCount)", for: .normal)
            self.btnfavMedia.setTitle(" \(likeCount)", for: .normal)
            
            
            let getuserArray:NSArray = getDetail.value(forKey: "user_uploading_post") as? NSArray ?? NSArray()
            if(getuserArray.count > 0)
            {
                let getUserDetail:NSDictionary = getuserArray.object(at: 0) as? NSDictionary ?? NSDictionary()
                // print(getUserDetail)
                self.lblnameMedia.text = getUserDetail.value(forKey: "username") as? String ?? ""
                let getuserImg:String = getUserDetail.value(forKey: "profile_image") as? String ?? ""
                self.imgUserProfileMedia.sd_setImage(with: URL(string: getuserImg), placeholderImage: UIImage(named: "userProfile_ImageView"))
                let getDate:String = getUserDetail.value(forKey: "created_at") as? String ?? ""
                self.lblTimeMedia.text = ApplicationManager.instance.dateCalculator(createdDate: getDate)
            }
            
            
            let post_attachments:NSArray = getDetail.value(forKey: "post_attachments") as? NSArray ?? NSArray()
            if(post_attachments.count > 0)
            {
                let getFirstEventDic:NSDictionary = post_attachments.object(at: 0) as? NSDictionary ?? NSDictionary()
                
                let imgEvent:String = getFirstEventDic.value(forKey: "attachment") as? String ?? ""
                let imgThumbnail:String = getFirstEventDic.value(forKey: "thumbnail") as? String ?? ""
                
                
                let attachment_type:String = getFirstEventDic.value(forKey: "attachment_type") as? String ?? ""
                if(attachment_type == "video")
                {
                    self.btnPlayVideoMedia.isHidden = false
                    if(imgThumbnail.count > 0)
                    {
                        self.imgEventMedia.sd_setImage(with: URL(string: postImageUrl + imgThumbnail), placeholderImage: UIImage(named: "noimage_icon"))
                    }
                }else
                {
                    self.btnPlayVideoMedia.isHidden = true
                    self.imgEventMedia.sd_setImage(with: URL(string: imgEvent), placeholderImage: UIImage(named: "noimage_icon"))
                }
            }else
            {
                self.btnPlayVideoMedia.isHidden = true
            }
            let islike:Bool = getDetail.value(forKey: "is_like") as? Bool ?? false
            if(islike == true)
            {
                self.btnfavClickMedia.setImage(UIImage.init(named: "hrtRed_Icon2"), for: .normal)
            }else
            {
                self.btnfavClickMedia.setImage(UIImage.init(named: "like_Dark"), for: .normal)
            }
        }else if (getType == "poll")
        {
            self.viwEvent.isHidden = true
            self.viwMedia.isHidden = true
            self.viwOpinion.isHidden = true
            //self.viwPoll.isHidden = true
            self.viwPoll.isHidden = false
            
            self.imgUserProfilePoll.layer.cornerRadius = 50/2
            self.imgUserProfilePoll.layer.borderColor = UIColor.unilifeblueDark.cgColor
            self.imgUserProfilePoll.layer.borderWidth = 2.0
            
            
            let question:String = getDetail.value(forKey: "question") as? String ?? ""
                       self.lblTitlePoll.text = question
                 
                       let getuserArray:NSArray = getDetail.value(forKey: "user_uploading_post") as? NSArray ?? NSArray()
                       if(getuserArray.count > 0)
                       {
                           let getUserDetail:NSDictionary = getuserArray.object(at: 0) as? NSDictionary ?? NSDictionary()
                          // print(getUserDetail)
                           self.lblNamePoll.text = getUserDetail.value(forKey: "username") as? String ?? ""
                           let getuserImg:String = getUserDetail.value(forKey: "profile_image") as? String ?? ""
                           self.imgUserProfilePoll.sd_setImage(with: URL(string: getuserImg), placeholderImage: UIImage(named: "userProfile_ImageView"))
                           
                       }
                       
                       let getDate:String = getDetail.value(forKey: "created_at") as? String ?? ""
                       self.lblTimePoll.text = ApplicationManager.instance.dateCalculator(createdDate: getDate)
                       let post_options:NSArray = getDetail.value(forKey: "post_options") as? NSArray ?? NSArray()
                     
                       self.DataForCollection = post_options
                       
                       let comemntCount:Int = getDetail.value(forKey: "post_comments_count") as? Int ?? 0
                        let likeCount:Int = getDetail.value(forKey: "post_like_count") as? Int ?? 0
                        self.btnCommentPoll.setTitle(" \(comemntCount)", for: .normal)
                        self.btnfavPoll.setTitle(" \(likeCount)", for: .normal)
                                  
                       
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
                           
                           self.heightOFPollCollection.constant = height
                       }else
                       {
                           self.heightOFPollCollection.constant = 0
                       }
                       
                       self.collectionAccess.reloadData()
            
        }else
        {
            self.viwEvent.isHidden = true
            self.viwMedia.isHidden = true
            self.viwOpinion.isHidden = true
            self.viwPoll.isHidden = true
        }
    }
    
    
    func updateCommentCount()
    {
        let getType:String = getDetail.value(forKey: "type") as? String ?? ""
        var comemntCount:Int = getDetail.value(forKey: "post_comments_count") as? Int ?? 0
        
        comemntCount = comemntCount + 1
        
        if(getType == "event")
        {
            self.btnCommentEvent.setTitle(" \(comemntCount)", for: .normal)
           
        }else if (getType == "normal")
        {
            self.btnCommentMedia.setTitle(" \(comemntCount)", for: .normal)
           
        }else if (getType == "opinion")
        {
            self.btnCommentopinion.setTitle(" \(comemntCount)", for: .normal)
           
        }
    }
    
    func updateLikeCount()
       {
           let getType:String = getDetail.value(forKey: "type") as? String ?? ""
           
           let post_like_count:Int = getDetail.value(forKey: "post_like_count") as? Int ?? 0
           
           
           if(getType == "event")
           {
           
               self.btnfavEvent.setTitle(" \(post_like_count)", for: .normal)
           }else if (getType == "normal")
           {
           
               self.btnfavMedia.setTitle(" \(post_like_count)", for: .normal)
           }else if (getType == "opinion")
           {
           
               self.btnfavopinion.setTitle(" \(post_like_count)", for: .normal)
           }
       }
    @IBAction func click_PlayVideo()
    {
        var _videoURl:String = ""
        let post_attachments:NSArray = getDetail.value(forKey: "post_attachments") as? NSArray ?? NSArray()
        if(post_attachments.count > 0)
        {
            let getFirstEventDic:NSDictionary = post_attachments.object(at: 0) as? NSDictionary ?? NSDictionary()
          //  print(getFirstEventDic)
            let videoR:String = getFirstEventDic.value(forKey: "attachment") as? String ?? ""
            let attachment_type:String = getFirstEventDic.value(forKey: "attachment_type") as? String ?? ""
            if(attachment_type == "video")
            {
                _videoURl = videoR
            }
        }
        if(_videoURl.count > 0)
        {
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
        let getType:String = getDetail.value(forKey: "type") as? String ?? ""
        if(getType == "event")
        {
            getShareText = getDetail.value(forKey: "event_description") as? String ?? ""
        }else if (getType == "opinion") || (getType == "normal")
        {
            getShareText = getDetail.value(forKey: "caption") as? String ?? ""
        }else if (getType == "poll")
        {
            getShareText = getDetail.value(forKey: "question") as? String ?? ""
        }
        
        if(getShareText.count > 0)
        {
            let viewController = UIActivityViewController(activityItems: [getShareText], applicationActivities: nil)
            viewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
           self.present(viewController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func ClickRegis(sender:UIButton)
    {
           var event_link:String = getDetail.value(forKey: "event_link") as? String ?? ""
        let event_id:String = getDetail.value(forKey: "id") as? String ?? "0"
           

            if(already_hit_button == false)
           {
              self.already_hit_button = true
              self.connection_RegisCountSend(getEventID: Int(event_id) ?? 0)
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
    
    @IBAction func click_Post()
          {
              
          }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
           
           tbl?.layer.removeAllAnimations()
           heightOFtbl?.constant = self.tbl?.contentSize.height ?? 0.0
           UIView.animate(withDuration: 0.5) {
               self.loadViewIfNeeded()
               
           }
       }
       
    
    @IBAction func ClickLike(sender:UIButton)
    {
        
        let getid:String = getDetail.value(forKey: "id") as? String ?? ""
      //  print(getDetail)
        self.likePost(post_id:getid, user_id:UserData().userId , index: sender.tag)
        var getlike:Int = getDetail.value(forKey: "is_like") as? Int ?? 0
        var post_like_count:Int = getDetail.value(forKey: "post_like_count") as? Int ?? 0
        if(getlike == 0)
        {
            getlike = 1
            post_like_count = post_like_count + 1
        }else
        {
            getlike = 0
            post_like_count = post_like_count - 1
        }
        let getDicChange:NSMutableDictionary = getDetail.mutableCopy() as? NSMutableDictionary ?? NSMutableDictionary()
        
     //   getDicChange.setObject(getlike, forKey: "is_like")
     //   getDicChange.setObject(post_like_count, forKey: "post_like_count")
        getDicChange.setValue(getlike, forKey: "is_like")
        getDicChange.setValue(post_like_count, forKey: "post_like_count")
        getDetail = getDicChange
        
        if(sender.imageView?.image == UIImage.init(named: "hrtRed_Icon2"))
        {
            sender.setImage(UIImage.init(named: "like_Dark"), for: .normal)
        }else
        {
            sender.setImage(UIImage.init(named: "hrtRed_Icon2"), for: .normal)
        }
    }
    
    @IBAction func click_sendComment()
    {
        let getText:String = self.txtComment.text ?? ""
        if(getText.trim().count > 0)
        {
            self.connection_sendComment()
        }
    }
    
    
    @IBAction func click_imageZoom(sender:UIButton)
    {
        
        let getType:String = getDetail.value(forKey: "type") as? String ?? ""
       
        if(getType == "event")
        {
          
          
           // blurViewX()
            let popupVC = kPhase2toryBoard.instantiateViewController(withIdentifier: "HomeImageZoomVC") as! HomeImageZoomVC
            popupVC.getimg = self.imgEventEvent.image
            popupVC.modalPresentationStyle = .overFullScreen
            popupVC.delegate = self
            self.present(popupVC, animated: true, completion: nil)
            
            
        }else if(getType == "opinion")
        {
            let popupVC = kPhase2toryBoard.instantiateViewController(withIdentifier: "HomeImageZoomVC") as! HomeImageZoomVC
            
            popupVC.getimg = self.imgEventopinion.image
            popupVC.modalPresentationStyle = .overFullScreen
            popupVC.delegate = self
            self.present(popupVC, animated: true, completion: nil)
        }else if(getType == "normal")
        {

           // blurViewX()
            let popupVC = kPhase2toryBoard.instantiateViewController(withIdentifier: "HomeImageZoomVC") as! HomeImageZoomVC
            
            popupVC.getimg = self.imgEventMedia.image
            popupVC.modalPresentationStyle = .overFullScreen
            popupVC.delegate = self
            self.present(popupVC, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func tapThreeDot_btn(_ sender: UIButton){
        
        guard let popoverContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReportPostOrUserViewController") as? ReportPostOrUserViewController else {return}
        
        popoverContent.controller = self
        
       // popoverContent.postUserId = String(self.eventPostData?[sender.tag].userID ?? 0)
        
      //  popoverContent.postId = String(self.eventPostData?[sender.tag].id ?? 0)
        
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
    
    
    @objc func keyBoardWillShow(notification:NSNotification){
           
           if let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue  {
               let keyboardHeight = keyboardSize.height
               //print(keyboardHeight)
               if self.keyBoardHeight == 0.0{
                   self.keyBoardHeight = Double(keyboardHeight)
                   
                self.botoomSpaceContent?.constant = CGFloat(self.keyBoardHeight)
                              UIView.animate(withDuration: 0.2, animations: {
                                      self.view.layoutIfNeeded()
                               })
                
                
               }
               
           }
//         DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//          self.view.frame.origin.y = 0
//         }
       }
   
}


extension CommentVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.aryComments.count
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
        let getdic:NSDictionary = self.aryComments.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
        let user_data:NSArray = getdic.value(forKey: "user_data") as? NSArray ?? NSArray()
        var name:String = ""
        var userImg:String = ""
        
        if(user_data.count > 0)
        {
            let getdic:NSDictionary = user_data.object(at:0) as? NSDictionary ?? NSDictionary()
            name = getdic.value(forKey: "username") as? String ?? ""
            userImg = getdic.value(forKey: "profile_image") as? String ?? ""
        }
        
        if(userImg.count > 0)
        {
           cell.imgUserProfile.sd_setImage(with: URL(string: userImg), placeholderImage: UIImage(named: "userProfile_ImageView"))
        }else
        {
            cell.imgUserProfile.image = UIImage.init(named: "userProfile_ImageView")
        }
        cell.viwOuter.layer.cornerRadius = 5
        cell.imgUserProfile.layer.cornerRadius = 50/2
        cell.lblTitle.text = name
        cell.lblComment.text  = getdic.value(forKey: "comment") as? String ?? ""
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
}




extension CommentVC
{
    
    
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
                    self?.updateLikeCount()
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
        }
        
    }
    
    
    func connection_getComment() {
       
        
        

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
       
             let getid:String = getDetail.value(forKey: "id") as? String ?? ""
              let params = [
                  "post_id":getid
              ]
              Indicator.shared.showProgressView(self.view)
          
            print(params)
              print(ConstantsHelper.getComments)
              WebServiceManager.shared.callWebService_Home(ConstantsHelper.getComments, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
                  
                 
                  if(response is NSDictionary)
                  {
                      
                     print(response)
                      let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                      if(status == true)
                      {
                      
                        self.aryComments = (response as! NSDictionary).value(forKey: "data") as? NSArray ?? NSArray()
                        self.tbl.reloadData()
                        
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
    
    func connection_sendComment() {
        
         let getid:String = getDetail.value(forKey: "id") as? String ?? ""
        
        let getText:String = self.txtComment.text ?? ""
        let param = ["user_id": UserData().userId, "post_id" : getid, "comment": getText.trim() ] as [String: AnyObject]
        
        print(param)
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "add_comment", params: param as [String: AnyObject]) {[weak self](receviedData) in
            
          //  print(receviedData)
            
            guard let self = self else {
                return
            }
            
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    self.txtComment.text! = ""
                    self.connection_getComment()
                    self.updateCommentCount()
                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
                
            }else {
                
                self.showDefaultAlert(Message: receviedData["Error"] as! String)
            }
            
        }
        
    }
    
    
    func connection_RegisCountSend(getEventID:Int)
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
                    let getText:String = self.btnRegisCount.titleLabel?.text ?? ""
                    var finalcount:Int = Int(getText.trim()) ?? 0
                    finalcount = finalcount + 1
                        
                    self.btnRegisCount.setTitle(" \(finalcount)", for: .normal)
                    
                   
                    
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



extension CommentVC:UITextFieldDelegate
{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // this method get called when you tap "Go"
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let nsString = NSString(string: textField.text!)
        let newText = nsString.replacingCharacters(in: range, with: string)
        
        if (textField == txtComment) {
            if(newText.count > 200)
            {
                return false;
            }
            let aSet = NSCharacterSet(charactersIn:"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@._ *%$#@!():;+=_-").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            if( string == numberFiltered)
            {
              
                return true
            }else
            {
                return false
            }
        }
        
        else {
            return  newText.count <= 50
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.botoomSpaceContent?.constant = CGFloat(self.keyBoardHeight)
               UIView.animate(withDuration: 0.2, animations: {
                       self.view.layoutIfNeeded()
                })
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.botoomSpaceContent?.constant = 0
                      UIView.animate(withDuration: 0.2, animations: {
                          self.view.layoutIfNeeded()
                      })

    }
    
    
}




extension CommentVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        
        return DataForCollection.count
        
        
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PollOptionCollectionCell", for: indexPath as IndexPath) as! PollOptionCollectionCell
        let getDic:NSDictionary = self.DataForCollection.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
        
        let getOption = getDic.value(forKey: "options") as? String ?? ""
        let selected = getDic.value(forKey: "selected") as? String ?? "no"
        let selected_count:Int = getDic.value(forKey: "selected_count") as? Int ?? 0
        
        if(selected == "yes")
        {
            cell.viwOuter.backgroundColor = UIColor.unilifeYesColor
            cell.btnOption.textColor = UIColor.white
        }else
        {
            cell.viwOuter.backgroundColor = UIColor.clear
            cell.btnOption.textColor = UIColor.black
        }
            cell.btnOption.text = getOption + ", \(selected_count)" + " Votes"
            cell.viwOuter.layer.borderColor = UIColor.unilifeYesColor.cgColor
            cell.viwOuter.layer.borderWidth = 2.0
            cell.viwOuter.layer.cornerRadius = 4
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
       
        return CGSize(width: self.collectionAccess.bounds.size.width/2, height: 50)
      
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          let post_options:NSArray = getDetail.value(forKey: "post_options") as? NSArray ?? NSArray()
        let getpollDic:NSDictionary = post_options.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
          
          let getId:String  = getpollDic.value(forKey: "id") as? String ?? ""
          let lastType:String = getpollDic.value(forKey: "selected") as? String ?? "no"
          if(lastType == "yes")
          {
              return
          }
        //  self.connection_selectPoll(post_id: getId, getindex: 0)
          
          let mainDic:NSMutableDictionary = getDetail.mutableCopy() as? NSMutableDictionary ?? NSMutableDictionary()
          let getMainPostArray:NSMutableArray = post_options.mutableCopy() as? NSMutableArray ?? NSMutableArray()
          
        //  let changingDic:NSMutableDictionary = getpollDic.mutableCopy() as? NSMutableDictionary ?? NSMutableDictionary()
       //   changingDic.setValue("yes", forKey: "selected")
          for i in 0..<getMainPostArray.count
          {
              if(i == indexPath.row)
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
        self.getDetail = mainDic.copy() as! NSDictionary
        DataForCollection = getMainPostArray.copy() as? NSArray ?? NSArray()
        self.collectionAccess.reloadData()
        
    }
  
}





//------------------------------------------------------
// MARK: Protocol for image popup     ------
//------------------------------------------------------

extension CommentVC:imgPopupProtocol
{
    func gotobackDelegate()
    {
         unblurViewX()
    }
}
