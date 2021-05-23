//
//  ViewController.swift
//  BMPG
//
//  Created by developer on 07/05/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit
import ContactsUI
import MessageUI

class AddNewContact_New11: UIViewController {

    let kButtonColor:UIColor = UIColor(red: 156 / 255.0, green: 81 / 255.0, blue: 25 / 255.0, alpha: 1.0)
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var img1: UIImageView!
    
    var arySearch:[ContactModel] = [ContactModel]()
    var issearch:Bool = false
    var devicesContacs:[ContactModel] = [ContactModel]()
    var serverContacs:[ContactModel] = [ContactModel]()
    
    var aryServerUserPhone:NSArray = NSArray()
    var uniID:String = ApplicationManager.instance.reg_Dic["universityid"] ?? ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        img1.layer.cornerRadius = 5
        img1.layer.borderColor = UIColor.white.cgColor
        img1.layer.borderWidth = 2
        let placeHolderColor:UIColor = UIColor(red: 9/255.0, green: 60/255.0, blue: 95/255.0, alpha: 1.0)
        txtSearch.attributedPlaceholder = NSAttributedString(string: "Search..",
                                                                                attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])
        
        connection_getListOFUniversity()
    }

    @IBAction func click_Back()
    {
           self.navigationController?.popViewController(animated: true)
    }
    
    
   
  
    @IBAction func click_Skip()
    {
           Switcher.afterLogin()
    }
    
    
    func getContacts() {
        let store = CNContactStore()
        
        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
            
            store.requestAccess(for: CNEntityType.contacts) { (isGranted, error) in
              //  print(isGranted)
                if(error == nil)
                {
                   if(isGranted == true)
                   {
                      self.retrieveContactsWithStore(store: store)
                    }else
                   {
                           
                    }
                }else
                {
                   
                    
                }
            }
            
           
        } else if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            self.retrieveContactsWithStore(store: store)
        }else
        {
            self.OpenContactSettingAlert()

        }
    }
    func OpenContactSettingAlert()
    {
        let alert = UIAlertController(title: "Unilife", message: kmsgSettingContact, preferredStyle: UIAlertController.Style.alert)
           
               let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                          UIAlertAction in
                       guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                           return
                       }
                       if UIApplication.shared.canOpenURL(settingsUrl) {
                           UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                               print("Settings opened: \(success)") // Prints true
                           })
                       }
                      }
             alert.addAction(okAction)
             alert.view.tintColor = UIColor.appSkyBlue
             self.present(alert, animated: true, completion: nil)
        
        
        
      
        
    }
    
    
    
    func retrieveContactsWithStore(store: CNContactStore) {
          //  print("Featching the rrquest")
        self.devicesContacs.removeAll()
        self.serverContacs.removeAll()
        
            do {
                        let keys = [
                            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                            CNContactPhoneNumbersKey,
                            CNContactEmailAddressesKey,
                            ] as [Any]
                        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
                        do {
                            try store.enumerateContacts(with: request){
                                (contact, stop) in
                                // Array containing all unified contacts from everywhere
                              //  contacts.append(contact)
                                for phoneNumber in contact.phoneNumbers {
                                    if let number = phoneNumber.value as? CNPhoneNumber, let label = phoneNumber.label {
                                        //print("label-->",label)
                                        
    //                                    print(contact.givenName)
    //                                    print(contact.familyName)
                                      //  if(label == "_$!<Home>!$_" || label == "_$!<Work>!$_" || label == "_$!<Mobile>!$_" || label == "_$!<Main>!$_" )
                                        
                                      //  let localizedLabel = CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label)
                                        //print(localizedLabel)
                                      //  let getEmailaddress = contact.emailAddresses.first
                                       // let dic:NSMutableDictionary = NSMutableDictionary()
                                        var myDict = Dictionary<String, Any>()
    //                                    dic.setValue(number.stringValue, forKey: "Phone")
    //                                    dic.setValue(getEmailaddress?.value ?? "", forKey: "Email")
    //                                    print(dic)
                                        let phone1:String = number.stringValue.replacingOccurrences(of: "(", with: "", options: NSString.CompareOptions.literal, range:nil)
                                         let phone2:String = phone1.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range:nil)
                                        let phone3:String = phone2.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range:nil)
                                         let phone4:String = phone3.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range:nil)
                                        if(phone4.count > 9)
                                        {
                                            var username = ""
                                            if (contact.givenName.count > 0) && (contact.familyName.count > 0)
                                            {
                                                 username = contact.givenName + " " + contact.familyName
                                            }else if (contact.givenName.count > 0)
                                            {
                                                username = contact.givenName
                                            }else if (contact.familyName.count > 0)
                                            {
                                                username = contact.familyName
                                            }
                                            
                                          
                                          myDict["phone"] = phone4
                                        //  myDict["email"] = getEmailaddress?.value ?? ""
    //                                      myDict["type"] = localizedLabel
                                            
                                          myDict["name"] = username
                                            ////.. 1 add friend , 2 not in u r school , 100 already requested ,  0 invit (not registerd in Unilife )
                                            var type:Int = 0
                                            var id:String = ""
                                            let predicateBottom = NSPredicate(format: "SELF.phone == '\(phone4)'")
                                           let getArrayOFmatch = self.aryServerUserPhone.filtered(using: predicateBottom) as? NSArray ?? NSArray()
                                            
                                            if(getArrayOFmatch.count > 0)
                                            {
                                                let getDic:NSDictionary = getArrayOFmatch.object(at: 0) as? NSDictionary ?? NSDictionary()
                                                
                                                let university_school_id = getDic.value(forKey: "university_school_id") as? String ?? ""
                                                 let school = getDic.value(forKey: "school") as? String ?? ""
                                                
                                               // print("---->",university_school_id)
                                                //if(self.uniID == university_school_id)
                                                if(school == "same")
                                                {
                                                     type = 1  ////.. add Friend
                                                }else
                                                {
                                                    type = 2   ////... not in u r school
                                                }
                                                id = getDic.value(forKey: "id") as? String ?? ""
                                                myDict["type"] = type
                                                myDict["id"] = id
                                                //self.serverContacs.add(myDict)
                                                
                                                let contactModel = ContactModel.init(dictionary: myDict)
                                                self.serverContacs.append(contactModel)
                                            }else
                                            {
                                                myDict["type"] = type
                                                myDict["id"] = id
                                                let contactModel = ContactModel.init(dictionary: myDict)
                                                self.devicesContacs.append(contactModel)
                                            }
                                           
                                            
                                            
                                        }
                                        
                                    }
                                }
                            }
                            //print(contacts)
                         //   print(devicesContacs)
                            
                            self.serverContacs = self.serverContacs + self.devicesContacs
                            //addObjects(from: self.devicesContacs as [ContactModel])
                            //self.serverContacs.add
                            //addObjects(from: self.devicesContacs as [ContactModel])
                           // self.devicesContacs.removeAllObjects()
                            self.devicesContacs.removeAll()
                            self.devicesContacs = self.serverContacs
                            
                         DispatchQueue.main.async {
                            self.tbl.reloadData()
                            }
                        } catch {
                            print("unable to fetch contacts")
                        }
     
            } catch {
                print(error)
            }
        }
    
    
    @IBAction func click_AddFriend(sender:UIButton)
    {
       
        ////.. 1 add friend , 2 not in u r school , 100 already requested ,  0 invit (not registerd in Unilife )
        var getDic:ContactModel?
        if(issearch == true)
        {
                getDic = self.arySearch[sender.tag]
        }else
        {
                getDic = self.devicesContacs[sender.tag]
           
            
        }
        
        if(getDic?.id?.count ?? 0 > 0) ///... add friend
        {
            if(getDic?.type == 1)
         {
            sendRequestService(request_id:Int(getDic?.id ?? "0") ?? 0,getIndex:sender.tag)
         }
        }else if(getDic?.type == 0) ///... invite Friends
        {
            self.shareOnMobile(getPhone: getDic?.phone ?? "")
        }
        
        
        /*
       var getDic:NSDictionary = NSDictionary()
        if(issearch == true)
        {
            getDic = self.arySearch.object(at: sender.tag) as? NSDictionary ?? NSDictionary()
        }else
        {
            getDic = self.devicesContacs.object(at: sender.tag) as? NSDictionary ?? NSDictionary()
            }
        
        let getId:String = getDic.value(forKey: "id") as? String ?? ""
         let getType:Int = getDic.value(forKey: "type") as? Int ?? 100
        if(getId.count > 0)
        {
           if(getType == 1)
         {
            sendRequestService(request_id:Int(getId) ?? 0,getIndex:sender.tag)
         }
        }
        */
        
    }
    
    func sendRequestService(request_id: Int,getIndex:Int) {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId,"request_id": "\(request_id)" ]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "send_friend_request", params: param as [String: AnyObject]) {[weak self]
            (receviedData) in
            
            //print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                     var getDic:ContactModel?
                    if(self?.issearch == true)
                           {
                                   getDic = self?.arySearch[getIndex]
                               let getindex_Local = self?.devicesContacs.index(of: getDic!)
                               getDic?.type = 100
                            var getDic_main:ContactModel = self?.devicesContacs[getindex_Local ?? 0] ?? ContactModel(dictionary: [String:Any]())
                               getDic_main.type = 100
                           }else
                           {
                                   getDic = self?.devicesContacs[getIndex]
                               getDic?.type = 100
                               
                           }
                           
                           self?.tbl.reloadData()
                    
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
         //      let predicateBottom = NSPredicate(format: "SELF.name contains[c] '\(getText)' or SELF.phone contains[c] '\(getText)'")
            let getd:[ContactModel] = self.devicesContacs.filter { ($0.name?.localizedCaseInsensitiveContains("\(getText)") ?? false) || ($0.phone?.localizedCaseInsensitiveContains("\(getText)") ?? false) }
                //self.devicesContacs.filtered(using: predicateBottom) as? [ContactModel] ?? [ContactModel]()
            self.arySearch.removeAll()
            self.arySearch = getd
        }
           
        self.tbl.reloadData()
       }
    
    func shareOnMobile(getPhone:String)
    {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        
        composeVC.recipients = [getPhone]
        let getDetails = kInviteMessage
       // userFUllName = userFUllName + " invited you to \(self.getEventName). See \(EventURL) for details"
        composeVC.body = getDetails
      
        // let image:UIImage = UIImage(named: "TestImage")!
        //UIImageJPEGRepresentation(image!, 1)
       // composeVC.addAttachmentData(dataImage!, typeIdentifier: "image/png" ,filename: "ImageUout.png")
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
    
    
     }


extension AddNewContact_New11:UITextFieldDelegate
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

extension AddNewContact_New11:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if(issearch == true)
        {
            return self.arySearch.count
        }
        return self.devicesContacs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        var getDic:ContactModel?
               if(issearch == true)
               {
                    getDic = self.arySearch[indexPath.row]
               }else
               {
                    getDic = self.devicesContacs[indexPath.row]
               }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegisSearchUserCell") as! RegisSearchUserCell
       // let getDic:NSDictionary = self.aryData.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
        let getname:String = getDic?.name ?? ""
        let getphone:String = getDic?.phone ?? ""
        let gettype:Int = getDic?.type ?? 0
        ////.. 1 add friend , 2 not in u r school , 100 already requested ,  0 invit (not registerd in Unilife )
        if(gettype == 1)  ///... Add friend
        {
            cell.btnAddFriend.backgroundColor = UIColor.unilifeblueDark
            cell.btnAddFriend.setTitle("Add Friend", for: .normal)
            cell.btnAddFriend.setTitleColor(UIColor.white, for: .normal)
            cell.btnNotINSchool.isHidden = true
            cell.btnAddFriend.isHidden = false
        }else if(gettype == 2)  ///... Not in your school
        {
            
            cell.btnNotINSchool.isHidden = false
            cell.btnAddFriend.isHidden = true
            
        }else if(gettype == 100)  ///... Add friend requested
        {
            cell.btnAddFriend.setTitle("Requested", for: .normal)
            cell.btnAddFriend.backgroundColor = UIColor.gray
            cell.btnAddFriend.setTitleColor(UIColor.white, for: .normal)
            cell.btnNotINSchool.isHidden = true
            cell.btnAddFriend.isHidden = false
        }else  ///... Invite
        {
            cell.btnAddFriend.backgroundColor = UIColor.unilifegrayButtonInvite
            cell.btnAddFriend.setTitle("Invite", for: .normal)
            cell.btnAddFriend.setTitleColor(UIColor.white, for: .normal)
            
            cell.btnAddFriend.isHidden = false
            cell.btnNotINSchool.isHidden = true
        }
        
        
      
        /*
        let img:String = getDic.value(forKey: "profile_image") as? String ?? ""
        if(img.count > 0)
        {
        // cell.imgUser.sd_setImage(with: URL(string: profileImageUrl + img), placeholderImage: UIImage(named: "noimage_icon"))
        }else
        {
        //    cell.imgUser.image = UIImage(named: "noimage_icon")
            
        }
        */
        // let id:Int = getDic.value(forKey: "id") as? Int ?? 0
        cell.imgUser?.setImage_Small_Patron_Profile(string: getname, color: kButtonColor, circular: true)
        cell.lblName.text = getname
        
        cell.lblPhone.text = getphone
        cell.imgUser.layer.cornerRadius = 40/2
        cell.imgUser.layer.borderColor = UIColor.white.cgColor
        cell.imgUser.layer.borderWidth = 2.0
        
        
        cell.btnAddFriend.layer.cornerRadius = 5
        cell.btnNotINSchool.layer.cornerRadius = 5
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



extension AddNewContact_New11
{
    func connection_getListOFUniversity()
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
         print(params)
        print(UserData().userId)
          print(ConstantsHelper.phone_number_get_univ_wise)
          WebServiceManager.shared.callWebService_Home(ConstantsHelper.phone_number_get_univ_wise, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
              
            
              
              if(response is NSDictionary)
              {
                  
                 print(response)
                  let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                  if(status == true)
                  {
                    
                     //  let getMessage = (response as! NSDictionary).value(forKey: "message") as? String ?? ""
                     // Singleton.sharedInstance.customAlert(getMSG: getMessage)
                    
                    self.aryServerUserPhone = (response as! NSDictionary).value(forKey: "data") as? NSArray ?? NSArray()
                    DispatchQueue.main.async {
                        self.getContacts()
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





extension AddNewContact_New11:MFMessageComposeViewControllerDelegate
{

func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    
   // self.navigationController?.popViewController(animated: true)
    self.dismiss(animated: true, completion: nil)
    }
}
