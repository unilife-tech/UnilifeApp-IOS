//
//  ViewController.swift
//  BMPG
//
//  Created by developer on 07/05/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit

class RegistrationSearchPropertyVC: UIViewController {

    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var txtSearch: UITextField!
    
    
    @IBOutlet weak var txtUniversityName: UITextField!
    @IBOutlet weak var txtStxtUniversityDomain: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var viwPopup: UIView!
    @IBOutlet weak var imgPopup: UIView!
    
    var delegate:updateUnivercityProtocol?
    var aryData:NSArray = NSArray()
    var arySearch:NSArray = NSArray()
    var issearch:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateUI()
        connection_getProperty()
        
        self.viwPopup.isHidden = true
        self.imgPopup.isHidden = true
    }
    func UpdateUI()
          {
            tbl?.tableFooterView = UIView()
                tbl?.estimatedRowHeight = 44.0
                tbl?.rowHeight = UITableView.automaticDimension
            
          img1.layer.cornerRadius = 5
          img1.layer.borderColor = UIColor.white.cgColor
          img1.layer.borderWidth = 2
            
            
            img2.layer.cornerRadius = 5
              img2.layer.borderColor = UIColor.white.cgColor
              img2.layer.borderWidth = 2
            
            
            let placeHolderColor:UIColor = UIColor(red: 9/255.0, green: 60/255.0, blue: 95/255.0, alpha: 1.0)
                               
                              
                               
            txtSearch.attributedPlaceholder = NSAttributedString(string: "Search..",
                                                                                   attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])
            
            
            viwPopup.layer.cornerRadius = 5
            self.btnAdd.layer.cornerRadius = 5
            self.btnCancel.layer.cornerRadius = 5
          
          }

    @IBAction func click_Back()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func click_OpenPopupAddNew()
    {
        self.viwPopup.isHidden = false
        self.imgPopup.isHidden = false
    }
    @IBAction func click_Add()
    {
        
        let msg: String = self.validateTxtFields()
                         if !(msg == "") {
                             self.view.endEditing(true)
                             self.showDefaultAlert(Message: msg)
                         }
                         else {
                            
                            self.viwPopup.isHidden = true
                            self.imgPopup.isHidden = true
                            self.connection_AddUniversity()
                         }
                  
        

    }
    
    @IBAction func click_Cancel()
    {
        self.viwPopup.isHidden = true
         self.imgPopup.isHidden = true
    }
    
    func search(getText:String)
    {
        if(getText.count == 0)
        {
            self.issearch = false
        }else
        {
            self.issearch = true
            let predicateBottom = NSPredicate(format: "SELF.name contains[c] '\(getText)'")
            self.arySearch = self.aryData.filtered(using: predicateBottom) as? NSArray ?? NSArray()
            self.tbl.reloadData()
        }
    }
    
    
    
    func validateTxtFields() -> String {
        let getdomain:String = self.txtStxtUniversityDomain?.text ?? ""
                 var msg: String = ""
                 if textFieldValidation.instance.isTextFieldHasEmptyText(text: (self.txtUniversityName?.text!)!)
                 {
                    msg = kmsgUniversityname
                 }else if textFieldValidation.instance.isTextFieldHasEmptyText(text: (self.txtStxtUniversityDomain?.text!)!)
                 {
                    msg = kmsgDomain
                 }else if(getdomain.first != "@")
                 {
                   msg = kmsgDomainStartAtTheRate
                 }
                
              
                 return msg;
                 
                 
             }
    
   
}

extension RegistrationSearchPropertyVC:UITextFieldDelegate
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



extension RegistrationSearchPropertyVC:UITableViewDelegate,UITableViewDataSource
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UniverCityCell") as! UniverCityCell
        cell.lblName.text = getDic.value(forKey: "name") as? String ?? ""
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var getDic:NSDictionary = NSDictionary()
        if(issearch == true)
        {
            getDic = self.arySearch.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
        }else
        {
            getDic = self.aryData.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
        }
        //  let getDic:NSDictionary = self.aryData.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
        let getemail = getDic.value(forKey: "domains") as? String ?? ""
        let getID = getDic.value(forKey: "id") as? String ?? ""
        let getSName = getDic.value(forKey: "name") as? String ?? ""
        
        if(self.delegate != nil)
        {
            delegate?.selectedUnivercity(getName: getemail, getid: getID,getSchoolname:getSName)
        }
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

//------------------------------------------------------
// MARK: API     ------------------------------------------------------
//------------------------------------------------------

extension RegistrationSearchPropertyVC
{
    func connection_getProperty()
        {
            //.... check inter net
            ConstantsHelper.OtherUserID = -1
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
            print(ConstantsHelper.university_schools_list)
            WebServiceManager.shared.callWebService_OtherAuth(ConstantsHelper.university_schools_list, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
                
              
                
                if(response is NSDictionary)
                {
                    
                   print(response)
                    let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                    if(status == true)
                    {
                        self.aryData = (response as! NSDictionary).value(forKey: "data") as? NSArray ?? NSArray()
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
    
    func connection_AddUniversity()
      {
          //.... check inter net
          ConstantsHelper.OtherUserID = -1
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
            "name":self.txtUniversityName.text ?? "",
              "domain":self.txtStxtUniversityDomain.text ?? "",
          ]
          Indicator.shared.showProgressView(self.view)
      //ApplicationManager.instance.startloading()
    print(params)
          
          WebServiceManager.shared.callWebService_OtherAuth(ConstantsHelper.add_university, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
              
            
              
              if(response is NSDictionary)
              {
                  
                // print(response)
                  let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                  if(status == true)
                  {
                    
                   let university_id = (response as! NSDictionary).value(forKey: "university_id") as? Int ?? 0
                    //  print(university_id)
                    
                    if(self.delegate != nil)
                    {
                        self.delegate?.selectedUnivercity(getName: self.txtStxtUniversityDomain.text ?? "", getid: "\(university_id)",getSchoolname:self.txtUniversityName.text ?? "")
                    }
                           
                           self.navigationController?.popViewController(animated: true)
                    
                        Singleton.sharedInstance.customAlert(getMSG: "University added successfully.")
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
