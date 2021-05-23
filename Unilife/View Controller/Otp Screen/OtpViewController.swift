//
//  OtpViewController.swift
//  Unilife
//
//  Created by Promatics on 1/23/20.
//  Copyright © 2020 promatics. All rights reserved.
//

import UIKit

class OtpViewController: UIViewController {
    
    
    // MARK: - Outlet
    
    @IBOutlet weak var otp1_TextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var otp2_textField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var otp3_textField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var otp4_textField: SkyFloatingLabelTextField!
    
    // MARK: - Variable
    
    var user_id = ""
    
    var controller = UIViewController()
    
    var condition = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        otp1_TextField.delegate = self
        otp2_textField.delegate = self
        otp3_textField.delegate = self
        otp4_textField.delegate = self
        
        otp1_TextField.textAlignment = .center
        
        otp2_textField.textAlignment = .center
        
        otp3_textField.textAlignment = .center
        
        otp4_textField.textAlignment = .center
        
        
        
        otp1_TextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otp2_textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otp3_textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        otp4_textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
    }
    
    // MARK: - Button Action
    
    
    @IBAction func verifyOtp_btn(_ sender: Any) {
        
        if self.otp1_TextField.text!.replacingOccurrences(of: " ", with: "") == "" && self.otp2_textField.text!.replacingOccurrences(of: " ", with: "") == "" && self.otp3_textField.text!.replacingOccurrences(of: " ", with: "") == "" && self.otp4_textField.text!.replacingOccurrences(of: " ", with: "") == ""{
            
            self.showDefaultAlert(Message: "Please enter Otp")
            
        }else {
            self.verifyOtp()
            
        }
    }
    
    @IBAction func tapResend_btn(_ sender: Any) {
        
        self.resendOtp()
    }
    
    
    
    // MARK: - TextField Delegate
    
    
    @objc func textFieldDidChange(textField: UITextField){
        
        let text = textField.text
        
        if (text?.utf16.count ?? 0) >= 1{
            switch textField{
                
                
            case otp1_TextField:
                otp2_textField.becomeFirstResponder()
            case otp2_textField:
                otp3_textField.becomeFirstResponder()
            case otp3_textField:
                otp4_textField.becomeFirstResponder()
            case otp4_textField:
                otp4_textField.resignFirstResponder()
            default:
                break
            }
        }else{
            
        }
    }
    
    
    
    
}


extension OtpViewController: UITextFieldDelegate{
    
    
    // MARK: - Verify Otp Service Response
    
    func verifyOtp(){
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": self.user_id,"otp": self.otp1_TextField.text! + self.otp2_textField.text! + self.otp3_textField.text! + self.otp4_textField.text!] as [String: AnyObject]
        
        print(param)
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "user_otp_verify", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    print(receviedData)
                    
                    //                    UserDefaults.standard.setValue((NSKeyedArchiver.archivedData(withRootObject: receviedData["data"]  as! [String: AnyObject])), forKey: "userData")
                    
                    
                    
                    self?.showAlertWithAction(Title: "Unilife", Message: "OTP Verify Successfully", ButtonTitle: "OK", outputBlock: {
                        
                        // successfull
                        
                        if self?.condition == "login" {
                            
                            
                           Switcher.afterLogin()
                            
                        }else {
                        
                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "CompleteProfileViewController") as! CompleteProfileViewController
                        
                        vc.userId = self?.user_id ?? "-1"
                        
                        if let key = UserDefaults.standard.value(forKey: "signUpTime") as? String {
                            if key == "second" {
                                
                            } else {
                                
                                // UserDefaults.standard.set("first", forKey: "signUpTime")
                                
                            }
                        } else {
                            UserDefaults.standard.set("first", forKey: "signUpTime")
                        }
                        
                        self?.controller.navigationController?.pushViewController(vc, animated: true)
                           
                        }
                        
                         self?.dismiss(animated: true, completion: nil)
                        
                        
                        //                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "OtpViewController") as! OtpViewController
                        //
                        //                        self?.present(vc, animated: true, completion: nil)
                    })
                    
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
                
            }else {
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
                
                
            }
            
        }
        
    }
    
    // MARK: - Resend Otp Service
    
    func resendOtp(){
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "user_resend_otp/\(self.user_id)") {[weak self] (receviedData) in
            
            print(receviedData)
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self?.showAlertWithAction(Title: "Unilife", Message: "OTP Resend Successfully", ButtonTitle: "OK", outputBlock: {
                        
                    })
                    
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                    
                }
                
            }else {
                
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
                
                
            }
            
        }
        
        
    }
    
    // MARK: - TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.text = ""
    }
}
