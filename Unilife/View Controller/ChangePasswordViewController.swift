//
//  ChangePasswordViewController.swift
//  Unilife
//
//  Created by Apple on 07/12/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var oldPassword_TextField: AppDefaultTextField!
    
    @IBOutlet weak var newPassword_textField: AppDefaultTextField!
    
    @IBOutlet weak var confirmPassword_textField: AppDefaultTextField!

    @IBOutlet weak var changePassword_btn: SetButton!
    
    
    // MARK: - Variable
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = UIColor.appSkyBlue
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Change Password", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    @IBAction func tapChangePassword_btn(_ sender: Any) {
        
        var message = ""
        
        if self.oldPassword_TextField.text!.replacingOccurrences(of: " ", with: "") == ""{
            
    message = "Please enter old password"
        }else if self.confirmPassword_textField.text!.replacingOccurrences(of: " ", with: "") == ""{
            
        message = "Please enter confirm password "
        }else if confirmPassword_textField.text!.replacingOccurrences(of: " ", with: "") != oldPassword_TextField.text?.replacingOccurrences(of: " ", with: "") {
            
        message = "old password and confirm password does not match"
        }
        
        else if self.newPassword_textField.text!.replacingOccurrences(of: " ", with: "") == "" {
            
        message = "Please enter new password "
         
        }else if self.newPassword_textField.text!.count < 6
        {
            
            message = "Password should not be less than 6 characters"
        }else {
            
         changePassword()
            
        }
        
        if message != ""{
            
        self.showDefaultAlert(Message: message)
        }
    }
    
    
    func changePassword(){
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId,"current_password": self.oldPassword_TextField.text!,"change_password": self.newPassword_textField.text!] as! [String: AnyObject] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "change_user_password", params: param as [String: AnyObject]) { (receviedData) in
            
    print(receviedData)
            
    Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1{
                
                if receviedData["response"] as? Bool == true {
                    
                    
                    self.showAlertWithAction(Title: "Unilife", Message: "Password Changed Successfully", ButtonTitle: "Ok"){
                        
                        
                    self.navigationController?.popViewController(animated: true)
                    }
                    
                    
                }else {
                    
                    
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
                
            }else {
                
        self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
                
                
            }
            
            
        }
    }
    

}
