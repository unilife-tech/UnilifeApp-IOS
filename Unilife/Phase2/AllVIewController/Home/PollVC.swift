//
//  ViewController.swift
//  Trendy
//
//  Created by developer on 17/04/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit

class PollVC: UIViewController {

    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var txtQuestionType: UITextField!
    @IBOutlet weak var imgCheckBox: UIImageView!
    @IBOutlet weak var heightOFtbl: NSLayoutConstraint!
    
    var isGroup:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ApplicationManager.instance.aryPoll = [AddPollModel]()
        var obj:[String: Any] = [String: Any]()
        obj["optionName"] = ""
        let newNotable = AddPollModel(dictionary: obj)
        ApplicationManager.instance.aryPoll.append(newNotable)
        UpdatUI()
        UpdateGroupUI()
        
        imgUserProfile.sd_setImage(with: URL(string: profileImageUrl + UserData().image), placeholderImage: UIImage(named: "noimage_icon"))
        self.lblname.text = UserData().name
    }
    
    override func viewWillAppear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = true
           //self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
              let crossHome    = UIImage(named: "crossHome")!

              let backButton   = UIBarButtonItem(image: crossHome,  style: .plain, target: self, action: #selector(CancelBack(sender:)))
              backButton.tintColor = UIColor.red
              navigationItem.leftBarButtonItem = backButton
              
               let rightButton   = UIBarButtonItem(title: "Post",  style: .done, target: self, action: #selector(PostButton(sender:)))
              rightButton.tintColor = UIColor.unilifeButtonBlueColor
              navigationItem.rightBarButtonItem = rightButton
              navigationItem.title = "Poll"
    }

    
    
    @objc func CancelBack(sender: AnyObject){
            self.navigationController?.popViewController(animated: true)
       }

       @objc func PostButton(sender: AnyObject)
       {
           
           let getQuestion:String = self.txtQuestionType.text ?? ""
           if(getQuestion.trim().count > 0)
           {
               var aryofData:[String:Any] = [String:Any]()
                      
                      for i in 0..<ApplicationManager.instance.aryPoll.count
                      {
                          let index = IndexPath(row: i, section: 0)
                          let getcell:PollAddOptionsCell? = self.tbl.cellForRow(at: index) as? PollAddOptionsCell
                          if(getcell != nil)
                          {
                              let getvalue = getcell?.txtOption.text ?? ""
                              if(getvalue.count > 0)
                              {
                                  aryofData["\(aryofData.count + 1)"] = getvalue
                              }
                          }
                      }
                      
                      if(aryofData.count > 0)
                      {
                          self.connection_Poll(getDic: aryofData)
                      }else
                      {
                       Singleton.sharedInstance.customAlert(getMSG: msgEnterOption)
               }
           }else
           {
               Singleton.sharedInstance.customAlert(getMSG: msgEnterPoll)
           }
       }
    
    
//    @IBAction func click_Back()
//    {
//        self.navigationController?.popViewController(animated: true)
//    }
    
    @IBAction func click_Add()
    {
        var obj:[String: Any] = [String: Any]()
        obj["optionName"] = ""
        let newNotable = AddPollModel(dictionary: obj)
        ApplicationManager.instance.aryPoll.append(newNotable)
        self.tbl.reloadData()
    }
    
    @IBAction func click_Delete(sender:UIButton)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // your code here
            ApplicationManager.instance.aryPoll.remove(at: sender.tag)
            self.tbl.reloadData()
        }
    }
    
    func UpdatUI()
    {
            imgUserProfile.layer.cornerRadius = 78/2
            imgUserProfile.layer.borderColor = UIColor.unilifeblueDark.cgColor
            imgUserProfile.layer.borderWidth = 2.0
            tbl?.tableFooterView = UIView()
            tbl?.estimatedRowHeight = 44.0
            tbl?.rowHeight = UITableView.automaticDimension
            self.tbl?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        tbl?.layer.removeAllAnimations()
        heightOFtbl?.constant = self.tbl?.contentSize.height ?? 0.0
        UIView.animate(withDuration: 0.5) {
            self.loadViewIfNeeded()
            
        }
    }
    
    /*
    @IBAction func click_save()
    {
        
        let getQuestion:String = self.txtQuestionType.text ?? ""
        if(getQuestion.trim().count > 0)
        {
            var aryofData:[String:Any] = [String:Any]()
                   
                   for i in 0..<ApplicationManager.instance.aryPoll.count
                   {
                       let index = IndexPath(row: i, section: 0)
                       let getcell:PollAddOptionsCell? = self.tbl.cellForRow(at: index) as? PollAddOptionsCell
                       if(getcell != nil)
                       {
                           let getvalue = getcell?.txtOption.text ?? ""
                           if(getvalue.count > 0)
                           {
                               aryofData["\(aryofData.count + 1)"] = getvalue
                           }
                       }
                   }
                   
                   if(aryofData.count > 0)
                   {
                       self.connection_Poll(getDic: aryofData)
                   }else
                   {
                    Singleton.sharedInstance.customAlert(getMSG: msgEnterOption)
            }
        }else
        {
            Singleton.sharedInstance.customAlert(getMSG: msgEnterPoll)
        }
    }
    */
    @IBAction func click_group()
    {
        if(isGroup == true)
        {
            isGroup = false
        }else
        {
            isGroup = true
        }
        UpdateGroupUI()
    }
    
    func UpdateGroupUI()
    {
        if(isGroup == true)
        {
            imgCheckBox.image = UIImage.init(named: "isselected")
        }else
        {
            imgCheckBox.image = UIImage.init(named: "isnotselected")
        }
    }
}

extension PollVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
            return ApplicationManager.instance.aryPoll.count
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "PollAddOptionsCell") as! PollAddOptionsCell
        cell.btnCancel.tag = indexPath.row
        cell.txtOption.tag = indexPath.row
        if(indexPath.row == (ApplicationManager.instance.aryPoll.count - 1))
        {
            cell.btnAdd.isHidden = false
            cell.btnCancel.isHidden = true
        }else
        {
            cell.btnAdd.isHidden = true
            cell.btnCancel.isHidden = false
        }
        cell.txtOption.text = ApplicationManager.instance.aryPoll[indexPath.row].optionName ?? ""
        cell.txtOption.placeholder = "Option " + "\(indexPath.row + 1)"
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




//------------------------------------------------------
// MARK: API     ------------------------------------------------------
//------------------------------------------------------

extension PollVC
{
    func connection_Poll(getDic:[String:Any])
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
                "question":self.txtQuestionType.text ?? "",
                "options":getDic,
                "group_id" :""
                ] as [String : Any]
            
            
            Indicator.shared.showProgressView(self.view)
        //ApplicationManager.instance.startloading()
         print(params)
            print(UserData().userId)
            print(ConstantsHelper.create_pollURL)
            WebServiceManager.shared.callWebService_Home(ConstantsHelper.create_pollURL, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
          
                if(response is NSDictionary)
                {
                 //  print(response)
                    let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                    if(status == true)
                    {
                        self.navigationController?.popViewController(animated: true)
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
    
}



extension PollVC:UITextFieldDelegate
{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // this method get called when you tap "Go"
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let nsString = NSString(string: textField.text!)
        let newText = nsString.replacingCharacters(in: range, with: string)
        
        if (textField == txtQuestionType) {
            if(newText.count > 50)
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
    
}
