//
//  ViewController.swift
//  Trendy
//
//  Created by developer on 17/04/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit
import Photos

class ProfileVC: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate  {

    typealias Parameters = [String: String]
    @IBOutlet weak var collectionCourse: UICollectionView!
    @IBOutlet weak var heightOFCollec: NSLayoutConstraint!
    @IBOutlet weak var tblExperience: UITableView!
    @IBOutlet weak var tblEducation: UITableView!
    @IBOutlet weak var tblAcheivetnt: UITableView!
    @IBOutlet weak var tagSkills: TagListView!
    @IBOutlet weak var tagLanguage: TagListView!
    @IBOutlet weak var tagIntrest: TagListView!
    
    let kcornaRadious:CGFloat = 10.0
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblUniversity: UILabel!
    @IBOutlet weak var lblUniversity2: UILabel!
    @IBOutlet weak var lblUserID: UILabel!
    
    @IBOutlet weak var lblPersionMission: UILabel!
    
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var imgbgProfile: UIImageView!
    @IBOutlet weak var lblWorking: UILabel!
    @IBOutlet weak var lblStuding: UILabel!
    @IBOutlet weak var lblLives: UILabel!
    @IBOutlet weak var lblFrom: UILabel!
    @IBOutlet weak var lblGraguate: UILabel!
    @IBOutlet weak var lblHighSchool: UILabel!
    
    
    @IBOutlet weak var viwPersonal: UIView!
    @IBOutlet weak var viwHighlight: UIView!
    @IBOutlet weak var viwSocial: UIView!
    @IBOutlet weak var viwProfile: UIView!
    
    @IBOutlet weak var viwLanguage: UIView!
       @IBOutlet weak var viwSkils: UIView!
       @IBOutlet weak var viwIntrest: UIView!
    
    @IBOutlet weak var btnSeeFriend: UIButton!
    @IBOutlet weak var btnAddFriend: UIButton!
    @IBOutlet weak var btnAddFriend2: UIButton!
    
    @IBOutlet weak var viwSeeFriendAddFriend: UIView!
    @IBOutlet weak var viwSeeFriend: UIView!
    
    @IBOutlet weak var heightOFtblExperience:NSLayoutConstraint?
    @IBOutlet weak var heightOFtblEducation:NSLayoutConstraint?
    @IBOutlet weak var heightOFtblAchi:NSLayoutConstraint?
    var tbltype:Int = 0
    var aryExperience:NSMutableArray = NSMutableArray()
    var aryEducation:NSMutableArray =  NSMutableArray()
    var aryAchi:NSMutableArray =  NSMutableArray()
    //var aryCourse:NSArray =  NSArray()
    var typeOFimagePicker:Int = 0
    
    let pickerController = UIImagePickerController()
    var asset: PHAsset?
    var selectedimage:UIImage!
    var getUserHighlight:NSDictionary = NSDictionary()
    var getUserData:NSDictionary = NSDictionary()
    var getSocialData:NSDictionary = NSDictionary()
    var arySkills:[String] = [String]()
    var aryLanguage:[String] = [String]()
    var aryIntrese:[String] = [String]()
    var aryCourses:NSArray = NSArray()
   // var moveNext:UIViewController?
    var getImageHeader:String = ""
    var getImageBackground:String = ""
    
    var getUserID:Int = -1
    var itSelf:Bool = true
    
    @IBOutlet weak var btnEdit1: UIButton!
    @IBOutlet weak var btnEdit2: UIButton!
    @IBOutlet weak var btnEdit3: UIButton!
    @IBOutlet weak var btnEdit4: UIButton!
    @IBOutlet weak var btnEdit5: UIButton!
    @IBOutlet weak var btnEdit6: UIButton!
    @IBOutlet weak var btnEdit7: UIButton!
    @IBOutlet weak var btnEdit8: UIButton!
    @IBOutlet weak var btnEdit9: UIButton!
    @IBOutlet weak var btnEdit10: UIButton!
    @IBOutlet weak var btnEdit11: UIButton!
    @IBOutlet weak var btnEdit12: UIButton!
    @IBOutlet weak var btnCamera1: UIButton!
    @IBOutlet weak var btnCamera2: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
   
    var isComeFromFriend:Bool = false  ///... true mens friend false not friend
    var needTOload:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viwSeeFriendAddFriend.isHidden = true
        viwSeeFriend.isHidden = false
        
        UpdatUI()
        LoadUI()
        needTOload = true
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        
       // self.navigationController?.setNavigationBarHidden(true, animated: true)
       self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if(needTOload == true)
        {
        if(getUserID == -1)
        {
         connection_ProfileHeader()
        }else
        {
            let getUserid:Int = Int(UserData().userId) ?? 0
            if(getUserID == getUserid)
            {
                ///... this is self user
                 itSelf = true
                connection_ProfileHeader()
                self.viwSeeFriend.isHidden = false
                self.viwSeeFriendAddFriend.isHidden = true
            }else
            {
                itSelf = false
                 let aryOFEditButton:[UIButton] = [btnEdit1,btnEdit2,btnEdit3,btnEdit4,btnEdit5,btnEdit6,btnEdit7,btnEdit8,btnEdit9,btnEdit10,btnEdit11,btnEdit12,btnCamera1,btnCamera2]
                for btn in aryOFEditButton
                {
                    btn.isHidden = true
                }
                
                lblTitle.text = "Account"
                connection_ProfileHeader_otherUser()
                
                
                if(isComeFromFriend == true)
                {
                    self.viwSeeFriend.isHidden = false   ///... hide add friend button and show single view
                     self.viwSeeFriendAddFriend.isHidden = true
                  self.btnAddFriend.isHidden = true
                }else
                {
                    self.viwSeeFriend.isHidden = true  ////.. show add friend button and hide sing see friend button
                    self.viwSeeFriendAddFriend.isHidden = false
                  self.btnAddFriend.isHidden = false
                }
            }
        }
        }else
        {
            needTOload = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
          
          self.tabBarController?.tabBar.isHidden = false
          self.navigationController?.setNavigationBarHidden(false, animated: true)
          
      }
    
    @IBAction func click_Back(_ sender: Any) {
           
           self.navigationController?.popViewController(animated: true)
       }

    @IBAction func click_addOtherFriend()
    {
        sendRequestService()
    }
    func UpdatUI()
    {
        
        imgUserProfile.layer.cornerRadius = 128/2
        imgUserProfile.layer.borderColor = UIColor.unilifeblueDark.cgColor
        imgUserProfile.layer.borderWidth = 2.0
        
        viwPersonal.layer.cornerRadius = self.kcornaRadious
        viwHighlight.layer.cornerRadius = self.kcornaRadious
        viwSocial.layer.cornerRadius = self.kcornaRadious
        viwProfile.layer.cornerRadius = self.kcornaRadious
        viwLanguage.layer.cornerRadius = self.kcornaRadious
        viwSkils.layer.cornerRadius = self.kcornaRadious
        viwIntrest.layer.cornerRadius = self.kcornaRadious
        
        btnSeeFriend.layer.cornerRadius = self.kcornaRadious
        btnAddFriend.layer.cornerRadius = self.kcornaRadious
        btnAddFriend2.layer.cornerRadius = self.kcornaRadious
        btnSeeFriend.layer.borderWidth = 2.0
        btnAddFriend.layer.borderWidth = 2.0
        btnAddFriend2.layer.borderWidth = 2.0
        
        btnSeeFriend.layer.borderColor = UIColor.unilifeblueDark.cgColor
        btnAddFriend.layer.borderColor = UIColor.unilifeblueDark.cgColor
        btnAddFriend2.layer.borderColor = UIColor.unilifeblueDark.cgColor
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viwPersonal.layer.masksToBounds = false
            self.viwPersonal.layer.shadowColor = UIColor.black.cgColor
            self.viwPersonal.layer.shadowOpacity = 0.3
            self.viwPersonal.layer.shadowOffset = CGSize(width: 1, height: 0)
            self.viwPersonal.layer.shadowRadius = 2.4
            
            
            self.viwHighlight.layer.masksToBounds = false
            self.viwHighlight.layer.shadowColor = UIColor.black.cgColor
            self.viwHighlight.layer.shadowOpacity = 0.3
            self.viwHighlight.layer.shadowOffset = CGSize(width: 1, height: 0)
            self.viwHighlight.layer.shadowRadius = 2.4
            
            self.viwSocial.layer.masksToBounds = false
            self.viwSocial.layer.shadowColor = UIColor.black.cgColor
            self.viwSocial.layer.shadowOpacity = 0.3
            self.viwSocial.layer.shadowOffset = CGSize(width: 1, height: 0)
            self.viwSocial.layer.shadowRadius = 2.4
            
            
            self.viwProfile.layer.masksToBounds = false
            self.viwProfile.layer.shadowColor = UIColor.black.cgColor
            self.viwProfile.layer.shadowOpacity = 0.3
            self.viwProfile.layer.shadowOffset = CGSize(width: 1, height: 0)
            self.viwProfile.layer.shadowRadius = 2.4
            
            
            self.viwLanguage.layer.masksToBounds = false
            self.viwLanguage.layer.shadowColor = UIColor.black.cgColor
            self.viwLanguage.layer.shadowOpacity = 0.3
            self.viwLanguage.layer.shadowOffset = CGSize(width: 1, height: 0)
            self.viwLanguage.layer.shadowRadius = 2.4
            
            
            self.viwSkils.layer.masksToBounds = false
            self.viwSkils.layer.shadowColor = UIColor.black.cgColor
            self.viwSkils.layer.shadowOpacity = 0.3
            self.viwSkils.layer.shadowOffset = CGSize(width: 1, height: 0)
            self.viwSkils.layer.shadowRadius = 2.4
            
            
            self.viwIntrest.layer.masksToBounds = false
            self.viwIntrest.layer.shadowColor = UIColor.black.cgColor
            self.viwIntrest.layer.shadowOpacity = 0.3
            self.viwIntrest.layer.shadowOffset = CGSize(width: 1, height: 0)
            self.viwIntrest.layer.shadowRadius = 2.4
            
        }
        
        
        
        tblEducation?.tableFooterView = UIView()
        tblEducation?.estimatedRowHeight = 44.0
        tblEducation?.rowHeight = UITableView.automaticDimension
        self.tblEducation?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        tblExperience?.tableFooterView = UIView()
        tblExperience?.estimatedRowHeight = 44.0
        tblExperience?.rowHeight = UITableView.automaticDimension
        
        self.tblExperience?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        tblAcheivetnt?.tableFooterView = UIView()
              tblAcheivetnt?.estimatedRowHeight = 44.0
              tblAcheivetnt?.rowHeight = UITableView.automaticDimension
              self.tblAcheivetnt?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        
        
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
             if(tbltype == 0)
             {
                 tblExperience?.layer.removeAllAnimations()
                 heightOFtblExperience?.constant = self.tblExperience?.contentSize.height ?? 0.0
                 UIView.animate(withDuration: 0.5) {
                     self.loadViewIfNeeded()
                 }
             }else if(tbltype == 1)
             {
                 tblAcheivetnt?.layer.removeAllAnimations()
                 heightOFtblAchi?.constant = self.tblAcheivetnt?.contentSize.height ?? 0.0
                 UIView.animate(withDuration: 0.5) {
                     self.loadViewIfNeeded()
                 }
             }else
             {
                 tblEducation?.layer.removeAllAnimations()
                 heightOFtblEducation?.constant = self.tblEducation?.contentSize.height ?? 0.0
                 UIView.animate(withDuration: 0.5) {
                     self.loadViewIfNeeded()
                 }
             }
                     
               }
    
    
    func LoadUI()
    {
        var currently_working = ""
        var study = ""
        var lives = ""
        var fromValue = ""
        var graduateFrom = ""
        var complete_highschool_at = ""
        if(self.getUserHighlight.count > 0)
        {
            
            currently_working = self.getUserHighlight.value(forKey: "currently_working") as? String ?? ""
            study = self.getUserHighlight.value(forKey: "currently_studying") as? String ?? ""
            lives = self.getUserHighlight.value(forKey: "lives_in") as? String ?? ""
            fromValue = self.getUserHighlight.value(forKey: "from") as? String ?? ""
            graduateFrom = self.getUserHighlight.value(forKey: "graduated_from") as? String ?? ""
            complete_highschool_at = self.getUserHighlight.value(forKey: "complete_highschool_at") as? String ?? ""
            
          //  addValue = "Graduated From " + addValue
            lives = "in " + lives
            
        }
        
        
        let lightcolor:UIColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        
        let workingFUllText = "Currently working at " + currently_working
        let WorkingBold  = "Currently working at"
        
        
        let attributedString2 = NSMutableAttributedString(string:workingFUllText)
        let startRange = (workingFUllText as NSString).range(of: WorkingBold)
        attributedString2.addAttribute(NSAttributedString.Key.foregroundColor, value:lightcolor, range: startRange)
        
        lblWorking.attributedText = attributedString2
        
        
        let stuFUllText = "Currently studying at " + study
        let stuBold  = "Currently studying at"
        
        let stuArr = NSMutableAttributedString(string:stuFUllText)
        let stuRange = (stuFUllText as NSString).range(of: stuBold)
        stuArr.addAttribute(NSAttributedString.Key.foregroundColor, value:lightcolor, range: stuRange)
        
        lblStuding.attributedText = stuArr
        
        let stuFUllTextGraduate = "Graduated from " + graduateFrom
               let stuBoldGra  = "Graduated from"
               
               let stuArrGra = NSMutableAttributedString(string:stuFUllTextGraduate)
               let stuRangeGra = (stuFUllTextGraduate as NSString).range(of: stuBoldGra)
               stuArrGra.addAttribute(NSAttributedString.Key.foregroundColor, value:lightcolor, range: stuRangeGra)
               
               lblGraguate.attributedText = stuArrGra
        
        
        let stuFUllTextHighSchool = "Completed High-school at " + complete_highschool_at
               let stuBoldHigh  = "Completed High-school at"
               
               let stuArrHigh = NSMutableAttributedString(string:stuFUllTextHighSchool)
               let stuRangeHigh = (stuFUllTextHighSchool as NSString).range(of: stuBoldHigh)
               stuArrHigh.addAttribute(NSAttributedString.Key.foregroundColor, value:lightcolor, range: stuRangeHigh)
               
               lblHighSchool.attributedText = stuArrHigh
        
        
        
        let livesFUllText = "Lives " + lives
        let livesBold  = "Lives"
        
        let livesArr = NSMutableAttributedString(string:livesFUllText)
        let liveRange = (livesFUllText as NSString).range(of: livesBold)
        livesArr.addAttribute(NSAttributedString.Key.foregroundColor, value:lightcolor, range: liveRange)
        
        lblLives.attributedText = livesArr
        
        
        
        let fromFUllText = "From " + fromValue
        let fromBold  = "From"
        
        let fromArr = NSMutableAttributedString(string:fromFUllText)
        let fromRange = (fromFUllText as NSString).range(of: fromBold)
        fromArr.addAttribute(NSAttributedString.Key.foregroundColor, value:lightcolor, range: fromRange)
        
        lblFrom.attributedText = fromArr
        
        
        
//        let addFUllText = "Add " + addValue
//        let addBold  = "Add"
//
//        let addArr = NSMutableAttributedString(string:addFUllText)
//        let addRange = (addFUllText as NSString).range(of: addBold)
//        addArr.addAttribute(NSAttributedString.Key.foregroundColor, value:lightcolor, range: addRange)
//
//        lblAdd.attributedText = addArr
        
        
        if(self.getUserData.count > 0)
        {
            let getimg:String = self.getUserData.value(forKey: "profile_image") as? String ?? ""
            let getName:String = self.getUserData.value(forKey: "username") as? String ?? ""
            let personal_mission:String = self.getUserData.value(forKey: "personal_mission") as? String ?? ""
            self.imgUserProfile.sd_setImage(with: URL(string: getimg), placeholderImage: UIImage(named: "noimage_icon"))
            self.lblName.text = getName
//            self.lblUniversity.text = getUniver
            
            
            let getStatus:String = self.getUserData.value(forKey: "designation") as? String ?? ""
            let getOrgani:String = self.getUserData.value(forKey: "organisation") as? String ?? ""
            self.lblPersionMission.text = personal_mission
            self.lblUniversity.text = getStatus
            if(getOrgani.count > 0)
            {
              self.lblUniversity2.text =  "at " + getOrgani
            }else
            {
                self.lblUniversity2.text = ""
            }
            
            let profile_banner_image:String = self.getUserData.value(forKey: "profile_banner_image") as? String ?? ""
           // print(profile_banner_image)
            if(profile_banner_image.count > 0)
            {
                let getFullImg:String = profile_banner_image
                self.imgbgProfile.sd_setImage(with: URL(string: getFullImg), placeholderImage: UIImage(named: "bgMyProfile"))
            }else
            {
                self.imgbgProfile.image = UIImage.init(named: "bgMyProfile")
                
            }
            
            let unilife_user_name:String = self.getUserData.value(forKey: "unilife_user_name") as? String ?? ""
            self.lblUserID.text = unilife_user_name
        }
        tagSkills.removeAllTags()
        tagIntrest.removeAllTags()
        tagLanguage.removeAllTags()
        self.tblEducation.reloadData()
        tagSkills.addTags(self.arySkills)
        self.tagIntrest.addTags(self.aryIntrese)
        self.tagLanguage.addTags(self.aryLanguage)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tblAcheivetnt.reloadData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.tblExperience.reloadData()
            
        }
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        //
        //        }
        
        if(self.arySkills.count > 0)
        {
            viwSkils.isHidden = false
        }else
        {
            viwSkils.isHidden = true
        }
        if(self.aryIntrese.count > 0)
        {
            self.viwIntrest.isHidden = false
        }else
        {
            self.viwIntrest.isHidden = true
        }
        
        if(self.aryLanguage.count > 0)
        {
            self.viwLanguage.isHidden = false
        }else
        {
            self.viwLanguage.isHidden = true
        }
        
    }
    
    
    
    @IBAction func Click_EditImage(sender:UIButton)
    {
        
        if(sender.tag == 1) ///.. 1 for profile image 0 for header image
        {
          return
        }
        typeOFimagePicker = sender.tag
        //"Select Picture"
        let actionSheetController: UIAlertController = UIAlertController(title: "" , message: "Set profile image", preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            
        }
        
       
      
        let galleryAction: UIAlertAction = UIAlertAction(title: "Choose from gallery", style: .default) { action -> Void in
            self.needTOload = false
            self.openImagePicker()
        }
        let cameraAction: UIAlertAction = UIAlertAction(title: "Take a picture", style: .default) { action -> Void in
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.delegate = self
            vc.modalPresentationStyle = .pageSheet
            self.needTOload = false
            if(kDeviceType == "ipad")
            {
                //                vc.modalPresentationStyle = .popover
                //                vc.popoverPresentationController?.delegate = self
                //                vc.popoverPresentationController?.sourceView = self.view
                vc.modalPresentationStyle = .pageSheet
            }else
            {
                vc.modalPresentationStyle = .pageSheet
                
            }
            self.present(vc, animated: true, completion: nil)
            
        }
        
      
       
        actionSheetController.addAction(cameraAction)
        actionSheetController.addAction(galleryAction)
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    

    
    @IBAction func Click_Edit(sender:UIButton)
    {
        if(sender.tag == 1)  ////... My profile
        {
            let vc = kProfileEditStoryBoard.instantiateViewController(withIdentifier: "SelfIntroProfileVC") as! SelfIntroProfileVC
            vc.getUserData = self.getUserData
             self.navigationController?.pushViewController(vc, animated: true)
        }else if (sender.tag == 2)   ////.... Highlights
        {
            let vc = kProfileEditStoryBoard.instantiateViewController(withIdentifier: "HighlightProfileVC") as! HighlightProfileVC
            vc.getUserHighlight = self.getUserHighlight
            self.navigationController?.pushViewController(vc, animated: true)
        }else if (sender.tag == 3)   ////.....  Experience
        {
            let vc = kProfileEditStoryBoard.instantiateViewController(withIdentifier: "AddExperienceVC") as! AddExperienceVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if (sender.tag == 4)     //// ... . Education
        {
            let vc = kProfileEditStoryBoard.instantiateViewController(withIdentifier: "AddEducationVC") as! AddEducationVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if (sender.tag == 5)    /////...  Skills
        {
            let vc = kProfileEditStoryBoard.instantiateViewController(withIdentifier: "SkillProfileVC") as! SkillProfileVC
            vc.getAlreadyValue = self.arySkills
             self.navigationController?.pushViewController(vc, animated: true)

        }else if (sender.tag == 6)    ///// .. . Languages
        {
            let vc = kProfileEditStoryBoard.instantiateViewController(withIdentifier: "LanguageProfileVC") as! LanguageProfileVC
            vc.getAlreadyValue = self.aryLanguage
             self.navigationController?.pushViewController(vc, animated: true)
        }else if (sender.tag == 7)      // //  .. . .Achievements
        {
            let vc = kProfileEditStoryBoard.instantiateViewController(withIdentifier: "AddAchivementVC") as! AddAchivementVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if (sender.tag == 8)     //////.. . Interest
        {
            let vc = kProfileEditStoryBoard.instantiateViewController(withIdentifier: "InterestProfileVC") as! InterestProfileVC
            vc.getAlreadyValue = self.aryIntrese
             self.navigationController?.pushViewController(vc, animated: true)
        }else if (sender.tag == 9)      // / / . ..Unilife Profile ID
        {
            
        }else if (sender.tag == 10)      // / / . ..Social data
        {
            let vc = kProfileEditStoryBoard.instantiateViewController(withIdentifier: "AddSocialVC") as! AddSocialVC
            vc.getSocialData = self.getSocialData
            self.navigationController?.pushViewController(vc, animated: true)
        }else if (sender.tag == 11)      // / / . ..Courses 
        {
            var aryCo:[String] = [String]()
            if(aryCourses.count > 0)
            {
                for i in 0..<aryCourses.count
                {
                    let getDic:NSDictionary = aryCourses.object(at: i) as? NSDictionary ?? NSDictionary()
                    let skill_name:String = getDic.value(forKey: "name") as? String ?? ""
                    aryCo.append(skill_name)
                }
            }
            let vc = kProfileEditStoryBoard.instantiateViewController(withIdentifier: "CoursesProfileVC") as! CoursesProfileVC
             vc.getAlreadyValue = aryCo
            self.navigationController?.pushViewController(vc, animated: true)
        }else if (sender.tag == 12)      // / / . ..Personal Mission
        {
           let personal_mission:String = self.getUserData.value(forKey: "personal_mission") as? String ?? ""
            let vc = kProfileEditStoryBoard.instantiateViewController(withIdentifier: "PersonalMIssionVC") as! PersonalMIssionVC
            vc.getStatement = personal_mission
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    
    @IBAction func clickSocial(sender:UIButton)
    {
        if(self.getSocialData.count > 0)
        {
            var openURL:String = ""
            
            if(sender.tag == 0)   /////...fb
            {
                openURL = self.getSocialData.value(forKey: "facebook") as? String ?? ""
                
            }else if (sender.tag == 1) /////...insta
            {
                openURL = self.getSocialData.value(forKey: "instagram") as? String ?? ""
            }else if (sender.tag == 2) /////...snap
            {
                openURL = self.getSocialData.value(forKey: "snapchat") as? String ?? ""
            }else if (sender.tag == 3)  /////...tw
            {
                openURL = self.getSocialData.value(forKey: "twitter") as? String ?? ""
            }else if (sender.tag == 4)  /////...linkd
            {
                openURL = self.getSocialData.value(forKey: "linkedIn") as? String ?? ""
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
                self.localAlert(getMSG: msgInvalid)
                }
            }
        }
        
    }
    

    func clickDelete_achivement(sender:Int)
    {
        let getDic:NSDictionary = self.aryAchi.object(at: sender) as? NSDictionary ?? NSDictionary()
        let getid = getDic.value(forKey: "id") as? String ?? ""
        alertDeleteMsg(getmsg: mDeleteAchivement_message,type:2,getid:getid, getindx: sender)
    }
    
     func clickDelete_Exp(sender:Int)
    {
        let getDic:NSDictionary = self.aryExperience.object(at: sender) as? NSDictionary ?? NSDictionary()
        let getid = getDic.value(forKey: "id") as? String ?? ""
        alertDeleteMsg(getmsg: mDeleteExperience_message,type: 0,getid:getid, getindx: sender)
    }
    
     func clickDelete_education(sender:Int)
    {
        let getDic:NSDictionary = self.aryEducation.object(at: sender) as? NSDictionary ?? NSDictionary()
        let getid = getDic.value(forKey: "id") as? String ?? ""
        alertDeleteMsg(getmsg: mDeleteEducation_message,type: 1,getid:getid, getindx: sender )
    }
    
    @IBAction func click_SeeFriend(_ sender: Any) {
          
        if(itSelf == true)
        {
            let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "FriendsListingViewController") as! FriendsListingViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else
        {
            let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "OtherFriendsListingViewController") as! OtherFriendsListingViewController
            vc.getUserID = self.getUserID
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
      }
      
    
    func localAlert(getMSG:String)
    {
           let alert = UIAlertController(title: msgTitle, message: getMSG, preferredStyle: UIAlertController.Style.alert)
                 alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                 
                 alert.view.tintColor = UIColor.appSkyBlue
                 
           self.present(alert, animated: true, completion: nil)
    }
    
    
    func alertDeleteMsg(getmsg:String,type:Int,getid:String,getindx:Int)
    {
       
        let actionSheetController: UIAlertController = UIAlertController(title: "Delete" , message: getmsg, preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            
        }
        
        let galleryAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
            if(type == 0)  ////..delete experience
            {
                self.connection_deleteExperience(getIndex: getindx, getid: getid)
            }else if (type == 1)  /////... delete education
            {
                self.connection_DeleteEducation(getIndex: getindx, getid: getid)
                
            }else  //... 2  delete achivement
            {
                self.connection_DeleteAchivement(getIndex: getindx, getid: getid)
            }
        }
        
        actionSheetController.addAction(galleryAction)
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    func UpdateUIofCOurseCollection()
    {
        if(self.aryCourses.count > 0)
        {
            self.heightOFCollec.constant = 80
        }else
        {
            self.heightOFCollec.constant = 0
        }
    }
    
    
}



extension ProfileVC:UITableViewDelegate,UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(tableView == self.tblExperience)
               {tbltype = 0
                   return self.aryExperience.count
               }else if(tableView == self.tblAcheivetnt)
               {tbltype = 1
                   return self.aryAchi.count
               }else
               {
                   tbltype = 2
                   return self.aryEducation.count
               }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 1
//        if(tableView == self.tblExperience)
//        {tbltype = 0
//            return self.aryExperience.count
//        }else if(tableView == self.tblAcheivetnt)
//        {tbltype = 1
//            return self.aryAchi.count
//        }else
//        {
//            tbltype = 2
//            return self.aryEducation.count
//        }
    
        
      
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == self.tblExperience)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileExperienceCell") as! ProfileExperienceCell
            
            cell.viwOuter.layer.cornerRadius = self.kcornaRadious
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                cell.viwOuter.layer.masksToBounds = false
//                cell.viwOuter.layer.shadowColor = UIColor.black.cgColor
//                cell.viwOuter.layer.shadowOpacity = 0.3
//                cell.viwOuter.layer.shadowOffset = CGSize(width: 1, height: 0)
//                cell.viwOuter.layer.shadowRadius = 2.4
//            }
            
             cell.viwImg.layer.cornerRadius = self.kcornaRadious

            let getDic:NSDictionary = self.aryExperience.object(at: indexPath.section) as? NSDictionary ?? NSDictionary()
            cell.lblName.text = getDic.value(forKey: "company_name") as? String ?? ""
            cell.lblManagement.text = getDic.value(forKey: "designation") as? String ?? ""
            let getSdate = getDic.value(forKey: "start_date") as? String ?? ""
            let getEdate = getDic.value(forKey: "end_date") as? String ?? ""
            cell.lblYear.text = getSdate.prefix(4) + " - " + getEdate.prefix(4)
            cell.img.image = UIImage.init(named: "Experience_green")

            cell.btnDelete.tag = indexPath.section
            cell.selectionStyle = .none
            return cell
        }else if(tableView == self.tblAcheivetnt)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileExperienceCell") as! ProfileExperienceCell
            let getDic:NSDictionary = self.aryAchi.object(at: indexPath.section) as? NSDictionary ?? NSDictionary()
            
            cell.viwOuter.layer.cornerRadius = self.kcornaRadious
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                cell.viwOuter.layer.masksToBounds = false
//                cell.viwOuter.layer.shadowColor = UIColor.black.cgColor
//                cell.viwOuter.layer.shadowOpacity = 0.5
//                cell.viwOuter.layer.shadowOffset = CGSize(width: 1, height: 1)
//                cell.viwOuter.layer.shadowRadius = 2.4
//            }
            
             cell.viwImg.layer.cornerRadius = self.kcornaRadious
            cell.lblName.text = getDic.value(forKey: "certificate_name") as? String ?? ""
            cell.lblManagement.text = getDic.value(forKey: "offered_by") as? String ?? ""
            cell.lblYear.text = getDic.value(forKey: "offered_date") as? String ?? ""
            cell.img.image = UIImage.init(named: "Achievements_blue")
            
            cell.btnDelete.tag = indexPath.section
            cell.selectionStyle = .none
            return cell
        }else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileExperienceCell") as! ProfileExperienceCell
            
            cell.viwOuter.layer.cornerRadius = self.kcornaRadious
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                cell.viwOuter.layer.masksToBounds = false
//                cell.viwOuter.layer.shadowColor = UIColor.black.cgColor
//                cell.viwOuter.layer.shadowOpacity = 0.5
//                cell.viwOuter.layer.shadowOffset = CGSize(width: 1, height: 1)
//                cell.viwOuter.layer.shadowRadius = 2.4
//            }
            
            cell.viwImg.layer.cornerRadius = self.kcornaRadious
            let getDic:NSDictionary = self.aryEducation.object(at: indexPath.section) as? NSDictionary ?? NSDictionary()
            cell.lblName.text = getDic.value(forKey: "college_name") as? String ?? ""
            cell.lblManagement.text = getDic.value(forKey: "degree") as? String ?? ""
            let getSdate = getDic.value(forKey: "start_date") as? String ?? ""
            let getEdate = getDic.value(forKey: "end_date") as? String ?? ""
            cell.lblYear.text = getSdate.prefix(4) + " - " + getEdate.prefix(4)
            cell.img.image = UIImage.init(named: "Education_Yellow")
            cell.btnDelete.tag = indexPath.section
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viw = UIView()
        return viw
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        return
        if(tableView == self.tblExperience)
        {
            let getDic:NSDictionary = self.aryExperience.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
            let vc = kProfileEditStoryBoard.instantiateViewController(withIdentifier: "AddExperienceVC") as! AddExperienceVC
            vc.isEdit = true
            vc.getDetail = getDic
                       self.navigationController?.pushViewController(vc, animated: true)
           
            
        }else if(tableView == self.tblAcheivetnt)
        {
            let getDic:NSDictionary = self.aryAchi.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
            
            let vc = kProfileEditStoryBoard.instantiateViewController(withIdentifier: "AddAchivementVC") as! AddAchivementVC
            vc.isEdit = true
            vc.getDetail = getDic
            
            self.navigationController?.pushViewController(vc, animated: true)
                       
                    
        }else
        {
            let getDic:NSDictionary = self.aryEducation.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
            
            let vc = kProfileEditStoryBoard.instantiateViewController(withIdentifier: "AddEducationVC") as! AddEducationVC
            vc.isEdit = true
            vc.getDetail = getDic
           self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    */
   
    /*
    private func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
       // let the controller to know that able to edit tableView's row
        
       if(itSelf == true)
       {
         return false
        }else {
           return true
       }
       
    }

  
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    */
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if(itSelf == true)
        {
        let action = UIContextualAction(
            style: .destructive,
            title: "Delete",
            handler: { (action, view, completion) in
                
                if(tableView == self.tblEducation)
                {
                    self.clickDelete_education(sender: indexPath.section)
                }else if(tableView == self.tblAcheivetnt)
                {
                    self.clickDelete_achivement(sender: indexPath.section)
                }else    ///.. experience
                {
                    self.clickDelete_Exp(sender: indexPath.section)
                }
                
                completion(true)
        })

        action.image = UIImage.init(named: "deleteswipe")
        action.backgroundColor = .unilifeSwipeRedDelete
        
        let Edit = UIContextualAction(
                   style: .destructive,
                   title: "Edit",
                   handler: { (action, view, completion) in
                    if(tableView == self.tblEducation)
                    {
                       let getDic:NSDictionary = self.aryEducation.object(at: indexPath.section) as? NSDictionary ?? NSDictionary()
                       
                       let vc = kProfileEditStoryBoard.instantiateViewController(withIdentifier: "AddEducationVC") as! AddEducationVC
                       vc.isEdit = true
                       vc.getDetail = getDic
                       self.navigationController?.pushViewController(vc, animated: true)
                    }else if(tableView == self.tblAcheivetnt)
                    {
                        let getDic:NSDictionary = self.aryAchi.object(at: indexPath.section) as? NSDictionary ?? NSDictionary()
                        
                        let vc = kProfileEditStoryBoard.instantiateViewController(withIdentifier: "AddAchivementVC") as! AddAchivementVC
                        vc.isEdit = true
                        vc.getDetail = getDic
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else    ///.. experience
                    {
                        let getDic:NSDictionary = self.aryExperience.object(at: indexPath.section) as? NSDictionary ?? NSDictionary()
                        let vc = kProfileEditStoryBoard.instantiateViewController(withIdentifier: "AddExperienceVC") as! AddExperienceVC
                        vc.isEdit = true
                        vc.getDetail = getDic
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    completion(true)
        })
        
        Edit.image = UIImage.init(named: "editSwipe")
        Edit.backgroundColor = .unilifeSwipeBlueEdit
        
        let Cancel = UIContextualAction(
                          style: .destructive,
                          title: "Cancel",
                          handler: { (action, view, completion) in
                              //do what you want here
                              completion(true)
                      })
               
               Cancel.image = UIImage.init(named: "closeSwipe")
               Cancel.backgroundColor = .unilifeSwipeCloseColor
        
        let configuration = UISwipeActionsConfiguration(actions: [action,Edit,Cancel])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
        }else
        {
            return nil
        }
    }
    
    
}
//------------------------------------------------------
// MARK: Image Picker   ------------------------------------------------------
//------------------------------------------------------



extension ProfileVC
{
    
    func openImagePicker(){
        
           pickerController.delegate = self
           pickerController.allowsEditing = false
           pickerController.mediaTypes = ["public.image"]
           pickerController.sourceType = .photoLibrary
           present(pickerController, animated: true, completion: nil)
           
       }
    
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         
         
         
         guard let image = info[UIImagePickerController.InfoKey.originalImage]
             as? UIImage else {
                  self.dismiss(animated: true, completion: nil)
                 return
         }
       
             self.selectedimage = image
//              var getitn = self.compressImage()
//             if(getitn == 1)
//             {
//                 getitn = self.compressImage()
//             }
        
        if(self.typeOFimagePicker == 0)
        {
            self.imgbgProfile.image = self.selectedimage
        }else
        {
            self.imgUserProfile.image = self.selectedimage
            
        }
         //   self.imgUserProfile.image = self.selectedimage
             self.dismiss(animated: true, completion: nil)
    
         DispatchQueue.main.async {
            self.Connection_UploadImage()
        }
}
    
    
    
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {self.dismiss(animated: true, completion: nil)
       }
}


//------------------------------------------------------
// MARK: Image Picker   ------------------------------------------------------
//------------------------------------------------------



extension ProfileVC
{
    
    
    
    func Connection_UploadImage()
    {
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            
            Singleton.sharedInstance.customAlert(getMSG: FAILED_INTERNET)
            return
        case .online(.wwan):
            print("")
        case .online(.wiFi):
            print("")
        }
        
        
        Indicator.shared.showProgressView(self.view)
        
        //  ZKProgressHUD.show(NSLocalizedString("Loading"))
        if(selectedimage != nil)
        {
            //            var getitn = self.compressImage()
            //            if(getitn == 1)
            //            {
            //                getitn = self.compressImage()
            //            }
        }
        
        
        
        let parameters = ["":""]
        // print(parameters)
        
        
        guard let mediaImage = Media(withImage: selectedimage ?? UIImage(), forKey: "")else{return}
        
        // guard let url = URL(string: kURL_UPLOADIMAGE + "?data={'userdata':{'user_id': '\(ApplicationManager.instance.user_id)'}}") else {return}
        
        let url = URL(string: ConstantsHelper.UplaodImageURL)
        //print(url)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let boundary = generateBoundary()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //request.addValue(kAPIversion, forHTTPHeaderField: "app-version")
        request.addValue(UserData().userId, forHTTPHeaderField: "Token")
        
        
        let dataBody =  createDataBody(withParameters: parameters, media: [mediaImage], boundary:  boundary)
        request.httpBody = dataBody
        
        let session =  URLSession.shared
        session.dataTask(with: request){(data, response, error) in
            
            
            if let data = data{
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print(json)
                    let getDic:NSDictionary = json as! NSDictionary
                    let getStatus:Bool = (getDic.value(forKey: "status") as? Bool )!
                    if(getStatus == true)
                    {
                        
                        let getImageURL:String = getDic.value(forKey: "data") as? String ?? ""
                       // let getImageURL:String = getDic.value(forKey: "url") as? String ?? ""
                        
                        // self.userImageURL = getImageURL
                         print("-------------__----------__----->",getImageURL)
                        DispatchQueue.main.async { [unowned self] in
//                            if(self.typeOFimagePicker == 0)
//                            {
//                                self.getImageBackground = getImageURL
//                            }else
//                            {
//                                self.getImageHeader = getImageURL
//                            }
                            self.getImageHeader = getImageURL
                            if(self.typeOFimagePicker == 0)
                            {
                                self.connection_UpdateProfile()
                            }
                            
                            
                            //     ZKProgressHUD.dismiss()
                           // Indicator.shared.hideProgressView()
                            
                        }
                        
                        // return
                        
                        
                    }else
                    {
                        let getmessage =  getDic.value(forKey: "message") as? String ?? ""
                        Singleton.sharedInstance.customAlert(getMSG: getmessage)
                        
                    }
                    
                    DispatchQueue.main.async { [unowned self] in
                        
                        //   ZKProgressHUD.dismiss()
                        
                        Indicator.shared.hideProgressView()
                    }
                }catch{
                    //  print(error)
                    DispatchQueue.main.async { [unowned self] in
                        
                        
                        //  ZKProgressHUD.dismiss()
                        
                        Indicator.shared.hideProgressView()
                    }
                }
            }
            
        }.resume()
    }
    
    
    
    
    
    func generateBoundary()->String{
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func  createDataBody(withParameters params:Parameters?, media:[Media]?, boundary:String) -> Data {
        let lineBreak = "\r\n"
        var body  = Data()
        if let parameters = params{
            for(key, value) in parameters{
                
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        if let media = media {
            for photo in media{
                
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
                body.append("COntent-Type: \(photo.mime + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
            
        }
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
}

//------------------------------------------------------
// MARK: API     ------------------------------------------------------
//------------------------------------------------------

extension ProfileVC
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
      print(params)
            print(ConstantsHelper.get_all_profile_data)
            WebServiceManager.shared.callWebService_Home(ConstantsHelper.get_all_profile_data, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
                
              
                
                if(response is NSDictionary)
                {
                    
                   print(response)
                    let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                    if(status == true)
                    {
                        
                        let respoonseInside = (response as! NSDictionary).value(forKey: "respoonse") as? NSDictionary ?? NSDictionary()
                        
                        let aryOFHigh:NSArray = respoonseInside.value(forKey: "user_highlights") as? NSArray ?? NSArray()
                        if(aryOFHigh.count > 0)
                        {
                            self.getUserHighlight = aryOFHigh.object(at: 0) as? NSDictionary ?? NSDictionary()
                        }
                        self.getUserData = (response as! NSDictionary).value(forKey: "self_intoduction") as? NSDictionary ?? NSDictionary()
                        self.aryAchi.removeAllObjects()
                        self.aryEducation.removeAllObjects()
                        self.aryExperience.removeAllObjects()
                        
                        let __aryAchi = respoonseInside.value(forKey: "user_achievements") as? NSArray ?? NSArray()
                        self.aryAchi = __aryAchi.mutableCopy() as? NSMutableArray ?? NSMutableArray()
                        
                        let __aryEducation = respoonseInside.value(forKey: "user_education") as? NSArray ?? NSArray()
                        
                        self.aryEducation = __aryEducation.mutableCopy() as? NSMutableArray ?? NSMutableArray()
                        
                        let __aryExperience = respoonseInside.value(forKey: "user_experience") as? NSArray ?? NSArray()
                        
                        self.aryExperience = __aryExperience.mutableCopy() as? NSMutableArray ?? NSMutableArray()
                        
                        let arySocial:NSArray = respoonseInside.value(forKey: "user_social_profile") as? NSArray ?? NSArray()
                        if(arySocial.count > 0)
                        {
                            self.getSocialData = arySocial.object(at: 0) as? NSDictionary ?? NSDictionary()
                        }
                        self.arySkills = [String]()
                        self.aryLanguage = [String]()
                        self.aryIntrese = [String]()
                        
                        
                        let skills:NSArray = respoonseInside.value(forKey: "user_skills") as? NSArray ?? NSArray()
                        self.aryCourses = respoonseInside.value(forKey: "user_course") as? NSArray ?? NSArray()
                        self.UpdateUIofCOurseCollection()
                      
                        if(skills.count > 0)
                        {
                            for i in 0..<skills.count
                            {
                                let getDic:NSDictionary = skills.object(at: i) as? NSDictionary ?? NSDictionary()
                                let skill_name:String = getDic.value(forKey: "skill_name") as? String ?? ""
                                self.arySkills.append(skill_name)
                            }
                        }
                        
                        let language:NSArray = respoonseInside.value(forKey: "user_languages") as? NSArray ?? NSArray()
                        if(language.count > 0)
                        {
                            for i in 0..<language.count
                            {
                                let getDic:NSDictionary = language.object(at: i) as? NSDictionary ?? NSDictionary()
                                let skill_name:String = getDic.value(forKey: "language_name") as? String ?? ""
                                self.aryLanguage.append(skill_name)
                            }
                        }
                       
                        
                        let Intrest:NSArray = respoonseInside.value(forKey: "user_interest") as? NSArray ?? NSArray()
                        if(Intrest.count > 0)
                        {
                            for i in 0..<Intrest.count
                            {
                                let getDic:NSDictionary = Intrest.object(at: i) as? NSDictionary ?? NSDictionary()
                                let skill_name:String = getDic.value(forKey: "interest_name") as? String ?? ""
                                self.aryIntrese.append(skill_name)
                            }
                        }
                        
                        self.LoadUI()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.collectionCourse.reloadData()
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
    
    
    func connection_DeleteAchivement(getIndex:Int,getid:String)
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
            "type":"delete","id":getid
            ] as [String : Any]
        
        
        Indicator.shared.showProgressView(self.view)
        //ApplicationManager.instance.startloading()
        print(params)
        //  print(ConstantsHelper.Profile_highlight)
        WebServiceManager.shared.callWebService_Home(ConstantsHelper.user_achievements, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
            
            
            
            if(response is NSDictionary)
            {
                
             //   print(response)
                let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                if(status == true)
                {
                    self.aryAchi.removeObject(at: getIndex)
                    self.tblAcheivetnt.reloadData()
                 //   let getMessage = (response as! NSDictionary).value(forKey: "message") as? String ?? ""
                 //   Singleton.sharedInstance.customAlert(getMSG: getMessage)
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
    
    func connection_DeleteEducation(getIndex:Int,getid:String)
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
           "type":"delete","id":getid
              ] as [String : Any]
          
          
          Indicator.shared.showProgressView(self.view)
      //ApplicationManager.instance.startloading()
    print(params)
        //  print(ConstantsHelper.Profile_highlight)
          WebServiceManager.shared.callWebService_Home(ConstantsHelper.user_education, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
              
            
              
              if(response is NSDictionary)
              {
                  
                 print(response)
                  let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                  if(status == true)
                  {
                      self.aryEducation.removeObject(at: getIndex)
                      self.tblEducation.reloadData()
                     //  let getMessage = (response as! NSDictionary).value(forKey: "message") as? String ?? ""
                     // Singleton.sharedInstance.customAlert(getMSG: getMessage)
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
    
    func connection_deleteExperience(getIndex:Int,getid:String)
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
              "type":"delete","id":getid
              ] as [String : Any]
          
          
          Indicator.shared.showProgressView(self.view)
      //ApplicationManager.instance.startloading()
    print(params)
          print(ConstantsHelper.user_experience)
          WebServiceManager.shared.callWebService_Home(ConstantsHelper.user_experience, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
              
            
              
              if(response is NSDictionary)
              {
                  
                 print(response)
                  let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                  if(status == true)
                  {
                      self.aryExperience.removeObject(at: getIndex)
                      self.tblExperience.reloadData()
                 //      let getMessage = (response as! NSDictionary).value(forKey: "message") as? String ?? ""
                 //     Singleton.sharedInstance.customAlert(getMSG: getMessage)
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
    
    func connection_UpdateProfile()
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
            "profile_banner_image":self.getImageHeader
          ]
          
          
          Indicator.shared.showProgressView(self.view)
      //ApplicationManager.instance.startloading()
           print(params)
          print(ConstantsHelper.profile_update)
          WebServiceManager.shared.callWebService_Home(ConstantsHelper.profile_update, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
              
            
              
              if(response is NSDictionary)
              {
                  
                 print(response)
                  let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                  if(status == true)
                  {
                    
                       let getMessage = (response as! NSDictionary).value(forKey: "message") as? String ?? ""
                      Singleton.sharedInstance.customAlert(getMSG: getMessage)
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
    
    
    
    func connection_ProfileHeader_otherUser()
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
        ConstantsHelper.OtherUserID = self.getUserID
          Indicator.shared.showProgressView(self.view)
      //ApplicationManager.instance.startloading()
    print(params)
          print(ConstantsHelper.get_all_profile_data)
          WebServiceManager.shared.callWebService_OtherAuth(ConstantsHelper.get_all_profile_data, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
              
            
              
              if(response is NSDictionary)
              {
                  
                 print(response)
                  let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                  if(status == true)
                  {
                      
                      let respoonseInside = (response as! NSDictionary).value(forKey: "respoonse") as? NSDictionary ?? NSDictionary()
                      
                      let aryOFHigh:NSArray = respoonseInside.value(forKey: "user_highlights") as? NSArray ?? NSArray()
                      if(aryOFHigh.count > 0)
                      {
                          self.getUserHighlight = aryOFHigh.object(at: 0) as? NSDictionary ?? NSDictionary()
                      }
                      self.getUserData = (response as! NSDictionary).value(forKey: "self_intoduction") as? NSDictionary ?? NSDictionary()
                      self.aryAchi.removeAllObjects()
                      self.aryEducation.removeAllObjects()
                      self.aryExperience.removeAllObjects()
                      
                      let __aryAchi = respoonseInside.value(forKey: "user_achievements") as? NSArray ?? NSArray()
                      self.aryAchi = __aryAchi.mutableCopy() as? NSMutableArray ?? NSMutableArray()
                      
                      let __aryEducation = respoonseInside.value(forKey: "user_education") as? NSArray ?? NSArray()
                      
                      self.aryEducation = __aryEducation.mutableCopy() as? NSMutableArray ?? NSMutableArray()
                      
                      let __aryExperience = respoonseInside.value(forKey: "user_experience") as? NSArray ?? NSArray()
                      
                      self.aryExperience = __aryExperience.mutableCopy() as? NSMutableArray ?? NSMutableArray()
                      
                      let arySocial:NSArray = respoonseInside.value(forKey: "user_social_profile") as? NSArray ?? NSArray()
                      if(arySocial.count > 0)
                      {
                          self.getSocialData = arySocial.object(at: 0) as? NSDictionary ?? NSDictionary()
                      }
                      self.arySkills = [String]()
                      self.aryLanguage = [String]()
                      self.aryIntrese = [String]()
                      
                      
                      let skills:NSArray = respoonseInside.value(forKey: "user_skills") as? NSArray ?? NSArray()
                      self.aryCourses = respoonseInside.value(forKey: "user_course") as? NSArray ?? NSArray()
                      self.UpdateUIofCOurseCollection()
                    
                      if(skills.count > 0)
                      {
                          for i in 0..<skills.count
                          {
                              let getDic:NSDictionary = skills.object(at: i) as? NSDictionary ?? NSDictionary()
                              let skill_name:String = getDic.value(forKey: "skill_name") as? String ?? ""
                              self.arySkills.append(skill_name)
                          }
                      }
                      
                      let language:NSArray = respoonseInside.value(forKey: "user_languages") as? NSArray ?? NSArray()
                      if(language.count > 0)
                      {
                          for i in 0..<language.count
                          {
                              let getDic:NSDictionary = language.object(at: i) as? NSDictionary ?? NSDictionary()
                              let skill_name:String = getDic.value(forKey: "language_name") as? String ?? ""
                              self.aryLanguage.append(skill_name)
                          }
                      }
                     
                      
                      let Intrest:NSArray = respoonseInside.value(forKey: "user_interest") as? NSArray ?? NSArray()
                      if(Intrest.count > 0)
                      {
                          for i in 0..<Intrest.count
                          {
                              let getDic:NSDictionary = Intrest.object(at: i) as? NSDictionary ?? NSDictionary()
                              let skill_name:String = getDic.value(forKey: "interest_name") as? String ?? ""
                              self.aryIntrese.append(skill_name)
                          }
                      }
                      
                      self.LoadUI()
                      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                          self.collectionCourse.reloadData()
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
    
    
    func sendRequestService() {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId,"request_id": self.getUserID ] as [String : Any]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "send_friend_request", params: param as [String: AnyObject]) {[weak self]
            (receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    
                   Singleton.sharedInstance.customAlert(getMSG: "Friend request is sent")
                    self?.btnAddFriend.isHidden = true
                    
                    self?.isComeFromFriend = true
                    self?.viwSeeFriend.isHidden = false   ///... hide add friend button and show signle view
                    self?.viwSeeFriendAddFriend.isHidden = true
                    self?.btnAddFriend.isHidden = true
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                }
                
                
            }else {
                
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
        }
        
    }
    
}




//------------------------------------------------------
// MARK: UICollectionView   ------
//------------------------------------------------------



extension ProfileVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        
        return aryCourses.count
        
        
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCourseCell", for: indexPath as IndexPath) as! ProfileCourseCell
        let getDic:NSDictionary = self.aryCourses.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
        cell.lblTitle.text = getDic.value(forKey: "name") as? String ?? ""
        
            cell.viwOuter.layer.cornerRadius = 5
        cell.viwOuter.layer.cornerRadius = self.kcornaRadious
                   DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                       cell.viwOuter.layer.masksToBounds = false
                       cell.viwOuter.layer.shadowColor = UIColor.black.cgColor
                       cell.viwOuter.layer.shadowOpacity = 0.3
                       cell.viwOuter.layer.shadowOffset = CGSize(width: 1, height: 0)
                       cell.viwOuter.layer.shadowRadius = 2.4
                   }
           
        //    let getOBJ:NSDictionary = self.aryCourse.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
    
     
            return cell
        
    }
    
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
       
        return CGSize(width: self.view.bounds.size.width/3, height: 70)
      
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        
    }
  
}





extension String{

    func isValidForUrl()->Bool{

        if(self.hasPrefix("http") || self.hasPrefix("https")){
            return true
        }
        return false
    }
}



