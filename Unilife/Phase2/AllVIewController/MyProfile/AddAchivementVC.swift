//
//  ViewController.swift
//  Trendy
//
//  Created by developer on 17/04/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit
import IQDropDownTextField

class AddAchivementVC: UIViewController {

   @IBOutlet weak var lblTitle: UILabel!
     @IBOutlet weak var btnAddEdit: UIButton!
    
    @IBOutlet weak var txtCertificate: UITextField!
    @IBOutlet weak var txtOffered: UITextField!
    @IBOutlet weak var txtDate: IQDropDownTextField!
    @IBOutlet weak var txtDuration: IQDropDownTextField!
    var isEdit:Bool = false
    var getDetail:NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
      
        self.txtDuration.itemList = ["1 Month","2 Month","3 Month","6 Month","1 Year"]
        
        var aryYear = Array<String>()
        let today = Date()
         let dt = DateFormatter()
         dt.dateFormat = "yyyy"
         let todayYear:String = dt.string(from: today)
         let todayYearInt:Int = Int(todayYear) ?? 0
         
         let previousY:Int = todayYearInt - 60
         let LastY:Int = todayYearInt + 7
         
         //let theYarray = Array(previousY...LastY)
         let tempary = Array(previousY...LastY)
         let theYarray = tempary.reversed()
        
         aryYear = theYarray.compactMap{String($0)}
         txtDate.itemList = aryYear
        
        if(self.isEdit == true)
        {
         
            self.lblTitle.text = "Edit Achievements"
            self.btnAddEdit.setTitle("Edit", for: .normal)
            self.txtCertificate.text = getDetail.value(forKey: "certificate_name") as? String ?? ""
            self.txtOffered.text = getDetail.value(forKey: "offered_by") as? String ?? ""
            let dateOffered = getDetail.value(forKey: "offered_date") as? String ?? ""
            let duration = getDetail.value(forKey: "duration") as? String ?? ""
            self.txtDate.setSelectedItem(dateOffered, animated: false)
            self.txtDuration.setSelectedItem(duration, animated: false)
            
        }
    }


    override func viewWillAppear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = true
           self.navigationController?.setNavigationBarHidden(true, animated: true)
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        
       }
    
  
    @IBAction func click_Back(_ sender: Any) {
              
              self.navigationController?.popViewController(animated: true)
          }
    
    @IBAction func click_update()
    {
        if(isEdit == true)
        {
            self.connection_EditAchivement()
        }else
        {
        connection_UpdateProfile()
        }
    }
    
   
}









//------------------------------------------------------
// MARK: API     ------------------------------------------------------
//------------------------------------------------------

extension AddAchivementVC
{
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
            "certificate_name":self.txtCertificate.text ?? "",
            "offered_by":self.txtOffered.text ?? "",
            "offered_date":self.txtDate.selectedItem ?? "",
            "duration":self.txtDuration.selectedItem ?? "",
            "type":"save"
            ] as [String : Any]
        
        
        Indicator.shared.showProgressView(self.view)
        //ApplicationManager.instance.startloading()
        print(params)
        //  print(ConstantsHelper.Profile_highlight)
        WebServiceManager.shared.callWebService_Home(ConstantsHelper.user_achievements, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
            
            
            
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
                Indicator.shared.hideProgressView()
                
                
                Singleton.sharedInstance.customAlert(getMSG: API_FAILED)
            }
            
            
        }
        
    }
    
    func connection_EditAchivement()
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
        
        
        let getid = getDetail.value(forKey: "id") as? String ?? ""
        
        let params = [
            "certificate_name":self.txtCertificate.text ?? "",
            "offered_by":self.txtOffered.text ?? "",
            "offered_date":self.txtDate.selectedItem ?? "",
            "duration":self.txtDuration.selectedItem ?? "",
            "type":"update",
            "id":getid
            ] as [String : Any]
        
        
        Indicator.shared.showProgressView(self.view)
        //ApplicationManager.instance.startloading()
        print(params)
        //  print(ConstantsHelper.Profile_highlight)
        WebServiceManager.shared.callWebService_Home(ConstantsHelper.user_achievements, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
            
            
            
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
                Indicator.shared.hideProgressView()
                
                
                Singleton.sharedInstance.customAlert(getMSG: API_FAILED)
            }
            
            
        }
        
    }
    
    
    
}
