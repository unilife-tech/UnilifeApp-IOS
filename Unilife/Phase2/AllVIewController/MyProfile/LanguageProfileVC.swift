//
//  ViewController.swift
//  Trendy
//
//  Created by developer on 17/04/20.
//  Copyright © 2020 developer. All rights reserved.
//





import UIKit

class LanguageProfileVC: UIViewController {

    @IBOutlet weak var tagLanguage: TagListView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var viwNewSkillAdd: UIView!
    @IBOutlet weak var lblNewSkills: UILabel!
    var getAlreadyValue:[String] =  [String]()
    var selectedSkills:NSMutableArray = NSMutableArray()
    
    let kplaceHolderColor:UIColor = UIColor(red: 0 / 255.0, green: 108 / 255.0, blue: 181 / 255.0, alpha: 1.0)
    var aryAllSkills:NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedSkills.removeAllObjects()
        if(getAlreadyValue.count > 0)
        {
            for i in 0..<getAlreadyValue.count
            {
                selectedSkills.add(getAlreadyValue[i])
            }
        }
        
        viwNewSkillAdd.isHidden = true
        tbl?.tableFooterView = UIView()
        tbl?.estimatedRowHeight = 44.0
        tbl?.rowHeight = UITableView.automaticDimension
        tbl.isHidden = true
        
        
        txtSearch.attributedPlaceholder = NSAttributedString(string: "Search For Others",
                                                             attributes: [NSAttributedString.Key.foregroundColor: self.kplaceHolderColor])
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 10, width: 40, height: 40))
        imageView.image = UIImage.init(named: "ic_zoom_out_24px")
        
        imageView.contentMode = .center
        txtSearch.leftView = imageView;
        txtSearch.leftViewMode = UITextField.ViewMode.always
        txtSearch.layer.cornerRadius = 40/2
        if #available(iOS 13, *) {
                       
                       imageView.translatesAutoresizingMaskIntoConstraints = false
                       imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
                       imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
        
        
        
//        selectedSkills.add("English")
//        selectedSkills.add("Spanish")
//        selectedSkills.add("Turkish")
  
        self.tagLanguage.addTags(selectedSkills as! [String])
        tagLanguage.delegate = self
        
    }


    override func viewWillAppear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = true
           //self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
       }
    
    @IBAction func click_Back(_ sender: Any) {
              
              self.navigationController?.popViewController(animated: true)
          }
    
    @IBAction func click_AddNew(){
        let getlang = self.txtSearch.text ?? ""
        if(getlang.count > 0)
        {
               if(!selectedSkills.contains(getlang))
               {
                 self.tagLanguage.addTag(getlang)
                   self.selectedSkills.add(getlang)
               }
               self.tbl.isHidden = true
              self.viwNewSkillAdd.isHidden = true
               self.txtSearch.text = ""
        }
    }
    
    @IBAction func click_Save()
    {
        
        connection_AddSkills()
        /*
        if(selectedSkills.count > 0)
        {
           connection_AddSkills()
        }else
        {
            Singleton.sharedInstance.customAlert(getMSG: msgInvalidSkills)
        }
      */
    }
    
}

extension LanguageProfileVC:TagListViewDelegate
{
    // MARK: TagListViewDelegate
       func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
           print("Tag pressed: \(title), \(sender)")
           //tagView.isSelected = !tagView.isSelected
       }
       
       func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
           print("Tag Remove pressed: \(title), \(sender)")
           sender.removeTagView(tagView)
        self.selectedSkills.remove(title)
       }
}

extension LanguageProfileVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
            return self.aryAllSkills.count
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell") as! LanguageCell
        let getDic:NSDictionary = self.aryAllSkills.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
        
        cell.lblTitle.text = getDic.value(forKey: "language_name") as? String ?? ""
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
         let getDic:NSDictionary = self.aryAllSkills.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
        
        let getlang = getDic.value(forKey: "language_name") as? String ?? ""
        if(!selectedSkills.contains(getlang))
        {
          self.tagLanguage.addTag(getlang)
            self.selectedSkills.add(getlang)
        }
        self.tbl.isHidden = true
        self.viwNewSkillAdd.isHidden = true
        self.txtSearch.text = ""
        
    }
    
    
}



extension LanguageProfileVC:UITextFieldDelegate
{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // this method get called when you tap "Go"
        textField.resignFirstResponder()
        self.tbl.isHidden = true
        self.viwNewSkillAdd.isHidden = true
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let nsString = NSString(string: textField.text!)
        let newText = nsString.replacingCharacters(in: range, with: string)
        
       
          let aSet = NSCharacterSet(charactersIn:"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@._ ").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            if( string == numberFiltered)
            {
               // self.tbl.isHidden = false
                if(newText.count > 0)
                {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                       self.connection_SearchSkills(getText:newText)
                    }
                }else
                {
                    self.viwNewSkillAdd.isHidden = true
                    self.tbl.isHidden = true
                }
                return true
            }else
            {
                return false
            }
            
       
        
    }
    
}
//------------------------------------------------------
// MARK: API     ------------------------------------------------------
//------------------------------------------------------

extension LanguageProfileVC
{
    func connection_SearchSkills(getText:String)
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
            "search":getText,
           
            ] as [String : Any]
        
        
       // Indicator.shared.showProgressView(self.view)
        
        //print(params)
        //print(ConstantsHelper.user_languages)
        WebServiceManager.shared.callWebService_NoLoader(ConstantsHelper.user_languages, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
            
            
            
            if(response is NSDictionary)
            {
                
                print(response)
                let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                if(status == true)
                {
                    self.aryAllSkills = (response as! NSDictionary).value(forKey: "data") as? NSArray ?? NSArray()
                    
                    if(self.aryAllSkills.count > 0)
                    {
                        self.tbl.reloadData()
                        self.tbl.isHidden = false
                        self.viwNewSkillAdd.isHidden = true
                    }else
                    {
                        self.tbl.isHidden = true
                        self.viwNewSkillAdd.isHidden = false
                        self.lblNewSkills.text = "+ New Language  '\(getText)' "
                    }
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
    
    
    func connection_AddSkills()
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
        var skills:String = ""
        for i in 0..<selectedSkills.count
        {
            let sValue:String = self.selectedSkills.object(at: i) as? String ?? ""
            if(i == 0)
            {
                skills = sValue
            }else
            {
                skills = skills + "," + sValue
            }
        }
        
        
        let params = [
            "language_name":skills,
           
            ] as [String : Any]
        
        
       // Indicator.shared.showProgressView(self.view)
        
        print(params)
        print(ConstantsHelper.user_languages)
        WebServiceManager.shared.callWebService_NoLoader(ConstantsHelper.user_languages, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
            
            
            
            if(response is NSDictionary)
            {
                
                print(response)
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
              //  Indicator.shared.hideProgressView()
                
                
                Singleton.sharedInstance.customAlert(getMSG: API_FAILED)
            }
            
            
        }
        
    }
    
    
}

