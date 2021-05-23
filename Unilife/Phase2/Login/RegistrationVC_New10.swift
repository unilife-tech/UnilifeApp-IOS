//
//  ViewController.swift
//  BMPG
//
//  Created by developer on 07/05/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit

class RegistrationVC_New10: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var heightOFtbl:NSLayoutConstraint?
    var aryData:NSArray = NSArray()
    var arySelectedIndex:NSMutableArray = NSMutableArray()
    
        var arySearch:NSArray = NSArray()
    var issearch:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateUI()
        getFriendList()
        arySelectedIndex.removeAllObjects()
        
        let fname:String = ApplicationManager.instance.reg_Dic["fname"] ?? ""
        let lname:String = ApplicationManager.instance.reg_Dic["lname"] ?? ""
        self.lblName.text =  fname + " " + lname
        
        
    }

    @IBAction func click_Back()
       {
           //self.navigationController?.popViewController(animated: true)
          var isfound:Bool = false
          
          if (self.navigationController != nil) {
              for vc in  self.navigationController!.viewControllers {
                  if vc is LoginVC_New {
                      isfound = true
                      self.navigationController?.popToViewController(vc, animated: false)
                      break
                  }
              }
          }
          if(isfound == false)
          {
              let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "HomeNavigation") as? UINavigationController
              UIApplication.shared.delegate?.window??.rootViewController = vc
          }
       }
    
    
    func UpdateUI()
    {
        
        imgMain.layer.cornerRadius = 5
        imgMain.layer.borderColor = UIColor.white.cgColor
        imgMain.layer.borderWidth = 2
        
        tbl?.tableFooterView = UIView()
          tbl?.estimatedRowHeight = 44.0
          tbl?.rowHeight = UITableView.automaticDimension
          self.tbl?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
//         img1.layer.cornerRadius = 5
//         img1.layer.borderColor = UIColor.white.cgColor
//         img1.layer.borderWidth = 2
        img2.layer.cornerRadius = 5
         img2.layer.borderColor = UIColor.white.cgColor
        img2.layer.borderWidth = 2
        let placeHolderColor:UIColor = UIColor(red: 9/255.0, green: 60/255.0, blue: 95/255.0, alpha: 1.0)
                     
                    
                     
                     txtSearch.attributedPlaceholder = NSAttributedString(string: "Search..",
                                                                         attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        tbl?.layer.removeAllAnimations()
        heightOFtbl?.constant = self.tbl?.contentSize.height ?? 0.0
        UIView.animate(withDuration: 0.5) {
            self.loadViewIfNeeded()
            
        }
    }
    

    @IBAction func click_Skip()
    {
           Switcher.afterLogin()
    }
    
    @IBAction func click_AddFriend(sender:UIButton)
    {
       var getDic:NSDictionary = NSDictionary()
                    if(issearch == true)
                    {
                         getDic = self.arySearch.object(at: sender.tag) as? NSDictionary ?? NSDictionary()
                    }else
                    {
                         getDic = self.aryData.object(at: sender.tag) as? NSDictionary ?? NSDictionary()
                    }
        let id:Int = getDic.value(forKey: "id") as? Int ?? 0
        
        if(arySelectedIndex.contains(id))
        {
            return
        }
        
        
        self.sendRequestService(request_id:id, getIndex: sender.tag)
    }
    
    
    
    func getFriendList()
    {
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "send_view_more_suggestions_user/\(UserData().userId)"){[weak self] (receviedData) in
             self?.addDevice()
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                //  print(receviedData)
                    self?.aryData = receviedData["data"] as? NSArray ?? NSArray()
                    self?.tbl.reloadData()
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
                
            }else {
                
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
        }
    }
    
    
    func addDevice(){
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId,"device_token": UserDefaults.standard.value(forKey: "fcmToken"),"device_id": UserDefaults.standard.value(forKey: "deviceId") ,"type": "ios"] as [String: AnyObject]
        
        print(param)
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "User_device", params: param as [String: AnyObject]){[weak self] (receviedData) in
           
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                }
                
            }else {
                self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
                
            }
            
        }
    }
    
    
    func sendRequestService(request_id: Int,getIndex:Int) {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId,"request_id": "\(request_id)" ]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "send_friend_request", params: param as [String: AnyObject]) {[weak self]
            (receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    
                    self?.arySelectedIndex.add(request_id)
                    self?.tbl.reloadData()
                    
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                }
                
                
            }else {
                
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
        }
        
    }
    
    
    func search(getText:String)
    {
           if(getText.count == 0)
           {
               self.issearch = false
           }else
           {
               self.issearch = true
               let predicateBottom = NSPredicate(format: "SELF.username contains[c] '\(getText)'")
               self.arySearch = self.aryData.filtered(using: predicateBottom) as? NSArray ?? NSArray()
               self.tbl.reloadData()
           }
       }
       
  
    @IBAction func click_invite()
    {
              let text =  kInviteMessage
               let textShare = [ text ]
               let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
               activityViewController.popoverPresentationController?.sourceView = self.view
               self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func click_AddNewContact()
    {
        
        
        let vc = kLoginStoryBoard.instantiateViewController(withIdentifier: "Registration_ContactVC") as! Registration_ContactVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension RegistrationVC_New10:UITextFieldDelegate
{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // this method get called when you tap "Go"
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let nsString = NSString(string: textField.text!)
        let newText = nsString.replacingCharacters(in: range, with: string)
        
   if (textField == txtSearch)
        {
            if(newText.count > 250)
            {
                return false;
            }
            let aSet = NSCharacterSet(charactersIn:"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@._+- *&^%$#@!();:?.>,< ").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            if( string == numberFiltered)
            {
                self.search(getText: newText)
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
    
}

extension RegistrationVC_New10:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if(issearch == true)
        {
            return self.arySearch.count
        }
        return self.aryData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        var getDic:NSDictionary = NSDictionary()
               if(issearch == true)
               {
                    getDic = self.arySearch.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
               }else
               {
                    getDic = self.aryData.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
               }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegisSearchUserCell") as! RegisSearchUserCell
       // let getDic:NSDictionary = self.aryData.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
        let getname:String = getDic.value(forKey: "username") as? String ?? ""
        let img:String = getDic.value(forKey: "profile_image") as? String ?? ""
        if(img.count > 0)
        {
         cell.imgUser.sd_setImage(with: URL(string: profileImageUrl + img), placeholderImage: UIImage(named: "noimage_icon"))
        }else
        {
            cell.imgUser.image = UIImage(named: "noimage_icon")
        }
         let id:Int = getDic.value(forKey: "id") as? Int ?? 0
        if(arySelectedIndex.contains(id))
        {
            cell.btnAddFriend.setTitle("Requested", for: .normal)
            cell.btnAddFriend.backgroundColor = UIColor.gray
        }else
        {
            cell.btnAddFriend.setTitle("Add Friend", for: .normal)
            cell.btnAddFriend.backgroundColor = UIColor.unilifeblueDark
        }
        cell.lblName.text = getname
        
        
        cell.imgUser.layer.cornerRadius = 40/2
        cell.imgUser.layer.borderColor = UIColor.white.cgColor
        cell.imgUser.layer.borderWidth = 2.0
        
        
        cell.btnAddFriend.layer.cornerRadius = 5
        cell.btnAddFriend.tag = indexPath.row
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
