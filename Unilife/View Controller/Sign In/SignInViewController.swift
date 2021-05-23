//
//  SignInViewController.swift
//  Unilife
//
//  Created by promatics on 21/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    
   // @IBOutlet weak var userName_textField: AppDefaultTextField!
    
    //@IBOutlet weak var enterPassword_textField: AppDefaultTextField!
    @IBOutlet weak var userName_textField: UITextField!
    
    @IBOutlet weak var enterPassword_textField: UITextField!
    
    @IBOutlet weak var back_btn: UIButton!
    
    var condition = ""
    
    // MARK: - Variable
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        img1.layer.cornerRadius = 10
        img2.layer.cornerRadius = 10
        
        
        img1.layer.borderColor = UIColor.white.cgColor
        img2.layer.borderColor = UIColor.white.cgColor
        
        
        img1.layer.borderWidth = 2
        img2.layer.borderWidth = 2
        
        
        
     //   self.userName_textField.text = "james.oesten@gmail.com"
     //   self.enterPassword_textField.text = "nishant@123"
        
        let placeHolderColor:UIColor = UIColor(red: 157/255.0, green: 157/255.0, blue: 157/255.0, alpha: 1.0)
               
              
               
        userName_textField.attributedPlaceholder = NSAttributedString(string: "Enter Full Name",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])
               
        enterPassword_textField.attributedPlaceholder = NSAttributedString(string: "Enter Password",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])
    }
    
    deinit {
        
        print(#file)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if self.condition == "Signup" {
            
            self.back_btn.isUserInteractionEnabled = false
            
        }else {
            
            self.back_btn.isUserInteractionEnabled = true
        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    // MARK: - Validation
    
    func validation() {
        
        var message = ""
        
        if self.userName_textField.text!.replacingOccurrences(of: " ", with: "") == ""  {
            
            message = "Please enter username or id"
            
        }
//                    else if Validation().isValidEmail(self.userName_textField.text!) {
//                        message = "Please enter valid username or id"
//                    }
            
        else if self.enterPassword_textField.text!.replacingOccurrences(of: " ", with: "") == "" {
            
            message = "Plesae enter password"
            
        }
            
        else {
            
            SignIn()
        }
        
        if message != "" {
            
            self.showDefaultAlert(Message: message)
        }
    }
    
    // MARK: - Sign In Service Response
    
    func SignIn() {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["username": self.userName_textField.text!, "password": self.enterPassword_textField.text!] as [String: AnyObject]
        
        print(param)
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "login", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                     UserDefaults.standard.setValue((NSKeyedArchiver.archivedData(withRootObject: receviedData["data"]  as! [String: AnyObject])), forKey: "userData")
                    
                    if ((receviedData as? [String: AnyObject])? ["university"] as? String) == nil {
                        
                        Singleton.sharedInstance.universityName = ""
                        
                    }else {
                    
                    Singleton.sharedInstance.universityName = String(describing: (receviedData["university"] as! [String: AnyObject])["name"]!)
                        
                    }
                    
                    
                    UserDefaults.standard.set("", forKey: "universityName")
                    
                    Singleton.sharedInstance.loginAsType = (((receviedData as? [String: AnyObject])? ["data"] as? [String: AnyObject])? ["user_type"] as? String ?? "")
                    
//                    let data = Singleton()
//                    data
                    
                     self?.addDevice()
                    
                    if (((receviedData as? [String: AnyObject])? ["data"] as? [String: AnyObject])? ["otp_verify"] as? String ?? "") == "yes"{
                       
                    self?.showAlertWithAction(Title: "Unilife", Message: (receviedData["message"] as! String).capitalized , ButtonTitle: "Ok", outputBlock: {
                        
                        Switcher.afterLogin()
                        //
                        //                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
                        //
                        //                    self.navigationController?.pushViewController(vc, animated: true)
                        
                    })
                        
                    }else {
                        
                    let vc = self?.storyboard?.instantiateViewController(withIdentifier: "OtpViewController") as! OtpViewController
                        
                    vc.controller = self!
                        
                    vc.condition = "login"
                        
                    vc.user_id = String((((receviedData as? [String: AnyObject])? ["data"] as? [String: AnyObject])? ["id"] as? Int ?? -1))
                        print(receviedData)
                    //UserData().image
                        
                    self?.present(vc, animated: true, completion: nil)
                    }
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
                
                
            }
            
            
        }
        
        
    }
    
    
    // MARK: - Add Device
    
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
    
    
    // MARK: - Button Action
    
    
    @IBAction func tapSignIn_btn(_ sender: Any) {
        
        self.validation()
        
        
    }
    
    @IBAction func tapForgotPassword_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        
        self.navigationController?.pushViewController(vc, animated: true )
    }
    
    @IBAction func tapSignUp_btn(_ sender: Any) {
        
        let vc = kLoginStoryBoard.instantiateViewController(withIdentifier: "RegistrationVC_New3") as! RegistrationVC_New3
                   self.navigationController?.pushViewController(vc, animated: true)
                   
        
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
//
//        self.navigationController?.pushViewController(vc, animated: true )
    }
    
    @IBAction func tapBack_btn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
