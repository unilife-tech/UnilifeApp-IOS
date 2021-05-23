//
//  DrawerViewController.swift
//  Unilife
//
//  Created by Apple on 29/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class DrawerViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var drawer_TableView: UITableView!
    
    @IBOutlet weak var back_View: UIView!
    
    @IBOutlet weak var top_View: UIView!
    
    @IBOutlet weak var profile_Image: CircleImage!
    
    @IBOutlet weak var userName_lbl: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    
    @IBOutlet weak var profilePicTop_constant: NSLayoutConstraint!
    
    @IBOutlet weak var front_View: UIView!
    
    // MARK: - Variable
    
    // "Invite Friends"
    var drawerNameArray = ["My Account", "Invite Friends", "Chat Settings", "Brand Settings", "Blog Settings", "Help", "FAQ's","Give us your Feedback","Change Password", "Logout"]
    
    var drawerImageArray = [UIImage(named: "myAcountWhite_icon"),UIImage(named: "inviteWhite_icon") ,UIImage(named: "chatWhite_icon"), UIImage(named: "brandWhite_icon"), UIImage(named: "blogWhite_Image"), UIImage(named: "helpWhite_icon"), UIImage(named: "faqWhite_icon"), UIImage(named: "feedWhite_icon"),UIImage(named: "padlock"), UIImage(named: "logoutWhite_icon")]
    
    var moveNext:UIViewController?
    
    var condition = ""
    
    @IBOutlet weak var deleteAccount_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     //   self.drawer_TableView.delegate = self
     //   self.drawer_TableView.dataSource = self
        
        self.userName_lbl.text! = UserData().name
        //        self.commentUserTag_lbl.text! =  "@" + UserData().name
        
        if UserData().image == "" {
            
            self.profile_Image.image = UIImage(named: "noimage_icon")
        }else {
            
            self.profile_Image.sd_setImage(with: URL(string: profileImageUrl + UserData().image), placeholderImage: UIImage(named: "noimage_icon"))
            
        }
        
        
        let getHeading:String = UserDefaults.standard.value(forKey: "_heading") as? String ?? ""
        self.lblHeading.text = getHeading
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.back_View.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.detectDevice()
        self.top_View.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.push()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    deinit {
        print(#file ,"deconstructure called")
    }
    
    //MARK:- Functions
    func detectDevice(){
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
                
            case 2436:
                print("iPhone X, XS")
                // self.topSideView_Height.constant = 180
                self.profilePicTop_constant.constant = 30
            case 2688:
                print("iPhone XS Max")
                //self.topSideView_Height.constant = 205
                self.profilePicTop_constant.constant = 30
            case 1792:
                print("iPhone XR")
                //self.topSideView_Height.constant = 205
                self.profilePicTop_constant.constant = 30
            default:
                print("Unknown")
                
            }
        }
    }
    
    func push(){
        
        self.front_View.frame.origin.x = -self.front_View.frame.width
        self.back_View.isHidden = false
        
        
        UIView.animate(withDuration: 0.3) {
            self.front_View.frame.origin.x = 0
            self.back_View.frame.origin.x = 0
        }
        
    }
    
    func pop(vc: UIViewController?){
        
        self.back_View.isHidden = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.front_View.frame.origin.x = -self.front_View.frame.width
            self.back_View.frame.origin.x = -self.back_View.frame.width
        }) { (fn) in
            
            if(fn){
                self.tapBackView(vc: vc)
            }
        }
        
    }
    
    @IBAction func tapDismis_Btn(_ sender: UIButton) {
        self.pop(vc: nil)
    }
    
    @objc func tapBackView(vc: UIViewController?){
        
        let transition = CATransition()
        transition.duration = 0.1
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window!.layer.add(transition, forKey: nil)
        
        if(vc != nil){
            
            self.dismiss(animated: false, completion: {
                self.moveNext?.navigationController?.pushViewController(vc!, animated: true)
            })
            
        }else{
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    
    
    @IBAction func tapSelectProfile_btn(_ sender: Any) {
        /*
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewProfileViewController") as! ViewProfileViewController
        
        self.dismiss(animated: false, completion: {
            self.moveNext?.navigationController?.pushViewController(vc, animated: true)
        })
        
        */
        
        let vc = kPhase2toryBoard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
         self.dismiss(animated: true, completion: nil)
         self.moveNext?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapDeleteAccount_btn(_ sender: Any) {
        
        self.showAlertWithActionOkandCancel(Title: "Unilife", Message: " Your account and your data will be deleted permanently", OkButtonTitle: "Ok", CancelButtonTitle: "Cancel"){
            
            self.condition = "deleteAccount"
            self.removeDevice()
            
        }
    }
    
    @IBAction func tapMenu(sender:UIButton)
    {
            
            if sender.tag == 0 {
                
    //            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewProfileViewController") as! ViewProfileViewController
    //
    //            self.dismiss(animated: true, completion: nil)
    //            self.moveNext?.navigationController?.pushViewController(vc, animated: true)
                
                
                ////... Phase 2
                let vc = kPhase2toryBoard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
               // let vc = kPhase2toryBoard.instantiateViewController(withIdentifier: "ProfileNavigation") as! UINavigationController
                          
                
                self.dismiss(animated: true, completion: nil)
                self.moveNext?.navigationController?.pushViewController(vc, animated: true)
               // self.present(vc, animated: true, completion: nil)
                
            }
                
            else if sender.tag == 1 {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "InviteViewController") as! InviteViewController
                
                self.dismiss(animated: true, completion: nil)
                self.moveNext?.navigationController?.pushViewController(vc, animated: true)
                
            }
                
            else if sender.tag == 2 {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatSetttingViewController") as! ChatSetttingViewController
                
                self.dismiss(animated: true, completion: nil)
                self.moveNext?.navigationController?.pushViewController(vc, animated: true)
                
                
            }
                
            else if sender.tag == 3 {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BrandSettingViewController") as! BrandSettingViewController
                
                self.dismiss(animated: true, completion: nil)
                self.moveNext?.navigationController?.pushViewController(vc, animated: true)
                
            }
                
            else if sender.tag == 4 {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlogSettingViewController") as! BlogSettingViewController
                
                self.dismiss(animated: true, completion: nil)
                self.moveNext?.navigationController?.pushViewController(vc, animated: true)
            }
                
            else if sender.tag == 5 {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
                
                self.dismiss(animated: true, completion: nil)
                self.moveNext?.navigationController?.pushViewController(vc, animated: true)
                
            }
                
            else if sender.tag == 6 {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
                
                self.dismiss(animated: true, completion: nil)
                self.moveNext?.navigationController?.pushViewController(vc, animated: true)
                
                
            }else if sender.tag == 7 {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FeedBackViewController") as! FeedBackViewController
                
                self.dismiss(animated: true, completion: nil)
                self.moveNext?.navigationController?.pushViewController(vc, animated: true)
                
            }
                
            else if sender.tag == 8 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
                
                self.dismiss(animated: true, completion: nil)
                self.moveNext?.navigationController?.pushViewController(vc, animated: true)
                
                
                
                
            }else if sender.tag == 9 {
                
                self.makeOfflineUser()
            }
            
        }
    
    
     @IBAction func click_Extra_Bottom(sender:UIButton)
        {
    //        let VC = kPhase2toryBoard.instantiateViewController(withIdentifier: "CommingSoon") as! CommingSoon
    //        self.navigationController?.pushViewController(VC, animated: true)
            
            guard let popoverContent = kPhase2toryBoard.instantiateViewController(withIdentifier: "CommingSoon") as? CommingSoon else {return}
                  
                  popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
            if(sender.tag == 1) || (sender.tag == 5)
            {
                popoverContent.preferredContentSize = CGSize(width: 100, height: 40)
            }else
            {
                popoverContent.preferredContentSize = CGSize(width: 200, height: 40)
            }
                  let popOver = popoverContent.popoverPresentationController
                  
                  popOver?.delegate = self
                  //
                  popOver?.sourceView = sender
                  //
                  
                  // popOver?.sourceView = sender
                  popOver?.sourceRect = sender.bounds
                  //
            popOver?.permittedArrowDirections = [.down]
                  popOver?.backgroundColor = UIColor(red: 106/255, green: 162/255, blue: 185/255, alpha: 1.0)
                  
                  self.present(popoverContent, animated: true, completion: nil)
            
        }
    
    
}

// MARK: - Table View Delegate And Data Source

extension DrawerViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return drawerNameArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.drawer_TableView.dequeueReusableCell(withIdentifier: "DrawerTableViewCell") as! DrawerTableViewCell
        
        cell.drawerName_lbl.text = self.drawerNameArray[indexPath.row]
        
        cell.drawer_ImageView.image = self.drawerImageArray[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewProfileViewController") as! ViewProfileViewController
//
//            self.dismiss(animated: true, completion: nil)
//            self.moveNext?.navigationController?.pushViewController(vc, animated: true)
            
            
            ////... Phase 2
            let vc = kPhase2toryBoard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
           // let vc = kPhase2toryBoard.instantiateViewController(withIdentifier: "ProfileNavigation") as! UINavigationController
                      
            
            self.dismiss(animated: true, completion: nil)
            self.moveNext?.navigationController?.pushViewController(vc, animated: true)
           // self.present(vc, animated: true, completion: nil)
            
        }
            
        else if indexPath.row == 1 {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "InviteViewController") as! InviteViewController
            
            self.dismiss(animated: true, completion: nil)
            self.moveNext?.navigationController?.pushViewController(vc, animated: true)
            
        }
            
        else if indexPath.row == 2 {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatSetttingViewController") as! ChatSetttingViewController
            
            self.dismiss(animated: true, completion: nil)
            self.moveNext?.navigationController?.pushViewController(vc, animated: true)
            
            
        }
            
        else if indexPath.row == 3 {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BrandSettingViewController") as! BrandSettingViewController
            
            self.dismiss(animated: true, completion: nil)
            self.moveNext?.navigationController?.pushViewController(vc, animated: true)
            
        }
            
        else if indexPath.row == 4 {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlogSettingViewController") as! BlogSettingViewController
            
            self.dismiss(animated: true, completion: nil)
            self.moveNext?.navigationController?.pushViewController(vc, animated: true)
        }
            
        else if indexPath.row == 5 {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
            
            self.dismiss(animated: true, completion: nil)
            self.moveNext?.navigationController?.pushViewController(vc, animated: true)
            
        }
            
        else if indexPath.row == 6 {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
            
            self.dismiss(animated: true, completion: nil)
            self.moveNext?.navigationController?.pushViewController(vc, animated: true)
            
            
        }else if indexPath.row == 7 {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FeedBackViewController") as! FeedBackViewController
            
            self.dismiss(animated: true, completion: nil)
            self.moveNext?.navigationController?.pushViewController(vc, animated: true)
            
        }
            
        else if indexPath.row == 8 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
            
            self.dismiss(animated: true, completion: nil)
            self.moveNext?.navigationController?.pushViewController(vc, animated: true)
            
            
            
            
        }else if indexPath.row == 9 {
            
            self.makeOfflineUser()
        }
        
    }
    
    func afterLogout(){
        
      //  let WaitUntilLoginController: UINavigationController? = kMainStoryBoard.instantiateViewController(withIdentifier: "HomeNavigation") as? UINavigationController
      //  UIApplication.shared.delegate?.window??.rootViewController = WaitUntilLoginController
        
      
    let rootVc = self.storyboard?.instantiateViewController(withIdentifier: "SelectSinInOrSignUpViewController") as! SelectSinInOrSignUpViewController
        
               
              let navVc = self.storyboard?.instantiateViewController(withIdentifier: "RootNavigationViewController") as! RootNavigationViewController
               
               navVc.viewControllers = [rootVc]
               
               UIApplication.shared.keyWindow?.rootViewController = navVc
        UserDefaults.standard.removeObject(forKey: "userData")
        /*
        let rootVc = self.storyboard?.instantiateViewController(withIdentifier: "SelectSinInOrSignUpViewController") as! SelectSinInOrSignUpViewController
         let Login = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC_New") as! LoginVC_New
       let navVc = self.storyboard?.instantiateViewController(withIdentifier: "RootNavigationViewController") as! RootNavigationViewController
        
        //navVc.viewControllers = [rootVc]
        navVc.viewControllers = [Login]
        UIApplication.shared.keyWindow?.rootViewController = navVc
        */
        
        
        
    }
    
}

// MARK: - Servive Response


extension DrawerViewController{
    
    
    
    // MARK: - Make User Offline
    
    func makeOfflineUser(){

        Indicator.shared.showProgressView(self.view)
        UserDefaults.standard.set("", forKey: "_heading")
        let param = ["user_id": UserData().userId,"status":"offline"] as [String: AnyObject]
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "make_user_online_offline", params: param as [String: AnyObject]){[weak self] (recevieData) in
            
            print(recevieData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if recevieData["response"] as? Bool == true {
                    
                    self?.removeDevice()
                    
                    self?.afterLogout()
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (recevieData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                
                self?.showDefaultAlert(Message: (recevieData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
                
            }
            
        }
    }
    
    
    
    // MARK: - Remove Device
    
    func removeDevice() {
        
        Indicator.shared.showProgressView(self.view)
        
        
        let param = ["user_id": UserData().userId,"device_token": UserDefaults.standard.value(forKey: "fcmToken"),"device_id": UserDefaults.standard.value(forKey: "deviceId") ,"type": "ios"] as [String: AnyObject]
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "delete_User_device", params: param as [String: AnyObject]){[weak self] (receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    if self?.condition == "deleteAccount" {
                        
                        self?.makeOfflineUser()
                        
                        self?.deleteUserAccount()
                        
                        UserDefaults.standard.removeObject(forKey: "userData")
                        
                        self?.afterLogout()
                        
                        
                    }else {
                        UserDefaults.standard.removeObject(forKey: "userData")
                        
                    }
                    
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                
                self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
                
                
                
            }
            
        }
    }
    
    // MARK: - Delete User Account
    
    
    func deleteUserAccount() {
        
        Indicator.shared.showProgressView(self.view)
        
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "delete-user-account/\(UserData().userId)"){[weak self] (receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    UserDefaults.standard.removeObject(forKey: "userData")
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                }
                
            }else {
                
                self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
                
            }
            
        }
    }
}


extension DrawerViewController: UIPopoverPresentationControllerDelegate
{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
          return .none
      }
}
