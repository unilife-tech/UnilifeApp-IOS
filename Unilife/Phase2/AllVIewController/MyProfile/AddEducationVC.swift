//
//  ViewController.swift
//  Trendy
//
//  Created by developer on 17/04/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit
import IQDropDownTextField

class AddEducationVC: UIViewController {

   @IBOutlet weak var lblTitle: UILabel!
     @IBOutlet weak var btnAddEdit: UIButton!
    
    @IBOutlet weak var txtCollegeName: UITextField!
    @IBOutlet weak var txtConcentration: UITextField!
    @IBOutlet weak var txtDegree: UITextField!
    @IBOutlet weak var txtClub: UITextField!
    @IBOutlet weak var txtGrade: UITextField!
    
    @IBOutlet weak var txtStartDate: IQDropDownTextField!
    @IBOutlet weak var txtEndDate: IQDropDownTextField!
    var isEdit:Bool = false
    var getDetail:NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let df = DateFormatter()
        df.dateFormat = kShowDateFormate//"MMM dd, YYYY" ... this formate is not working bug in file
        
        self.txtStartDate.dropDownMode = IQDropDownMode.datePicker
        self.txtStartDate.isOptionalDropDown = false
        self.txtStartDate.dateFormatter = df
        
        self.txtEndDate.dropDownMode = IQDropDownMode.datePicker
        self.txtEndDate.isOptionalDropDown = false
        self.txtEndDate.dateFormatter = df
        
        if(self.isEdit == true)
            {
                print(getDetail)
                self.lblTitle.text = "Edit Education"
                self.btnAddEdit.setTitle("Edit", for: .normal)
                
                self.txtCollegeName.text = getDetail.value(forKey: "college_name") as? String ?? ""
                self.txtConcentration.text = getDetail.value(forKey: "concentration") as? String ?? ""
                self.txtDegree.text = getDetail.value(forKey: "degree") as? String ?? ""
                self.txtClub.text = getDetail.value(forKey: "club_society") as? String ?? ""
                self.txtGrade.text = getDetail.value(forKey: "grade") as? String ?? ""
                let getSDate:String = getDetail.value(forKey: "start_date") as? String ?? ""
                let getEDate:String = getDetail.value(forKey: "end_date") as? String ?? ""
                
                
                let dateFormateForToday = DateFormatter()
                //dateFormateForToday.timeZone = TimeZone(identifier: getTimeZone)
                dateFormateForToday.dateFormat = "yyyy/MM/dd"
                dateFormateForToday.calendar = Calendar(identifier: .iso8601)
                dateFormateForToday.locale = Locale(identifier: "en_US_POSIX")
                dateFormateForToday.timeZone = TimeZone(secondsFromGMT: 0)
                if(getSDate.count > 0)
                {
                let SDate:Date = dateFormateForToday.date(from: getSDate) ?? Date()
                    self.txtStartDate.date = SDate
                }
                
                if(getEDate.count > 0)
                {
                let EDate:Date = dateFormateForToday.date(from: getEDate) ?? Date()
                    self.txtEndDate.date = EDate
                }
            }
    }


    override func viewWillAppear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = true
           //self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
       }
    
  
    @IBAction func click_Back(_ sender: Any) {
              
              self.navigationController?.popViewController(animated: true)
          }
    
    @IBAction func click_update()
    {
        if(isEdit == true)
        {self.connection_EditEducation()
            
        }else
        {
        connection_UpdateEducation()
        }
    }
    
   
}







//------------------------------------------------------
// MARK: API     ------------------------------------------------------
//------------------------------------------------------

extension AddEducationVC
{
    func connection_UpdateEducation()
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
            
            let getstartDate:Date = self.txtStartDate.date ?? Date()
                       let getendDate:Date = self.txtEndDate.date ?? Date()
                       let df = DateFormatter()
                       df.dateFormat = kSendFormate
                       let sDate:String = df.string(from: getstartDate)
                       let eDate:String = df.string(from: getendDate)
        
            let grade = self.txtGrade.text ?? ""
            let college_name = self.txtCollegeName.text ?? ""
            let concentration = self.txtConcentration.text ?? ""
            let degree = self.txtDegree.text ?? ""
            let club_society = self.txtClub.text ?? ""
            
            
            let params = [
              "college_name":college_name.trim(),
              "concentration":concentration.trim(),
              "degree":degree.trim(),
              "club_society":club_society.trim(),
              "grade":grade.trim(),
              "start_date":sDate,
              "end_date":eDate,
              "type":"save"
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
    
    
    func connection_EditEducation()
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
          
          let getstartDate:Date = self.txtStartDate.date ?? Date()
                     let getendDate:Date = self.txtEndDate.date ?? Date()
                     let df = DateFormatter()
                     df.dateFormat = kSendFormate
                     let sDate:String = df.string(from: getstartDate)
                     let eDate:String = df.string(from: getendDate)
      
          let grade = self.txtGrade.text ?? ""
          let college_name = self.txtCollegeName.text ?? ""
          let concentration = self.txtConcentration.text ?? ""
          let degree = self.txtDegree.text ?? ""
          let club_society = self.txtClub.text ?? ""
          
          let getid = getDetail.value(forKey: "id") as? String ?? ""
          let params = [
            "college_name":college_name.trim(),
            "concentration":concentration.trim(),
            "degree":degree.trim(),
            "club_society":club_society.trim(),
            "grade":grade.trim(),
            "start_date":sDate,
            "end_date":eDate,
            "type":"update",
            "id":getid
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
