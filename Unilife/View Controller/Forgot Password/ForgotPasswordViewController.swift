//
//  ForgotPasswordViewController.swift
//  Unilife
//
//  Created by promatics on 21/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    // MARK: - Outlet
    
    
    @IBOutlet var universityOrSchoolEmail_textField: AppDefaultTextField!
    
    
    @IBOutlet var send_btn: SetButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    deinit {
        print(#file)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    // MARK: - Validation
    
    func validation() {
        
        var message = ""
        
        if self.universityOrSchoolEmail_textField.text!.replacingOccurrences(of: "", with: "") == "" {
            
            message = "Please enter university or school email"
            
            
        }else if !Validation().isValidEmail(self.universityOrSchoolEmail_textField.text!) {
            
            message = "Please enter valid university or school email"
        }else {
            
            forgotPassword()
        }
        
        if message != "" {
            
            self.showDefaultAlert(Message: message)
        }
        
        
    }
    
    // MARK: - Forgot Password Service Response
    
    
    func forgotPassword() {
        
        Indicator.shared.showProgressView(self.view)
         Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "forget_password/\(self.universityOrSchoolEmail_textField.text!)") {[weak self] (receviedData) in
            
            print(receviedData)
            
            guard let self = self else {
                return
            }
            
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self.showAlertWithAction(Title: "Unilife", Message: ((receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found"), ButtonTitle: "Ok", outputBlock: {
                        
                    self.navigationController?.popViewController(animated: true)
                    })
                    
                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                
                self.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
            
        }
        
        
    }
    
    
    
    
    // MARK: - Button Action
    
    @IBAction func tapSend_btn(_ sender: Any) {
        
        self.validation()
    }
    
    @IBAction func tapBack_btn(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
    }
    
    
}
