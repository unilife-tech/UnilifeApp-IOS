//
//  SignUpViewController.swift
//  Unilife
//
//  Created by promatics on 21/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var selectUserType_textField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var enterUserNameOrId_textField: AppDefaultTextField!
    
    @IBOutlet weak var selectUniversityOrSchool_textField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var universityOrSchoolEmail_textField: AppDefaultTextField!
    
    @IBOutlet weak var enterPassword_textField: AppDefaultTextField!
    
    @IBOutlet weak var enterConfirmPassword_textField: AppDefaultTextField!
    
    @IBOutlet weak var selectUserType_TableView: UITableView!
    
    @IBOutlet weak var selectUniversity_TableView: UITableView!
    
    @IBOutlet weak var selectUserType_btn: UIButton!
    
    @IBOutlet weak var selectUniversity_btn: UIButton!
    
    @IBOutlet weak var create_btn: SetButton!
    
    @IBOutlet weak var signIn_btn: UIButton!
    
    
    // MARK: - Variable
    
    var selectUserType = ""
    var selectUniversityOrSchoolType = ""
    var universityListingArray = [[String: AnyObject]]()
    var selectUserTypeArray = ["Student", "Staff ", "Teacher"]
    
    var selectUniversityDomain = ""
    
    // MARK: - View Default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectUserType_TableView.delegate = self
        
        self.selectUserType_TableView.dataSource = self
        
        self.selectUniversity_TableView.delegate = self
        
        self.selectUniversity_TableView.dataSource = self
        
        self.selectUserType_TableView.layer.borderColor = UIColor.appDarKGray.cgColor
        self.selectUserType_TableView.layer.borderWidth = 1
        
        self.selectUniversity_TableView.layer.borderColor = UIColor.appDarKGray.cgColor
        self.selectUniversity_TableView.layer.borderWidth = 1
        
        
        self.selectUniversity_TableView.register(UINib(nibName: "SelectUniversityCell", bundle: nil), forCellReuseIdentifier: "SelectUniversityTableViewCell")
        
        self.selectUserType_TableView.register(UINib(nibName: "SelectUniversityCell", bundle: nil), forCellReuseIdentifier: "SelectUniversityTableViewCell")
        
        universityListing()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    deinit {
        print(#file)
    }
    
    // MARK: - Sign Up Service Response
    
    
    func signUp() {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_type": self.selectUserType,"username":self.enterUserNameOrId_textField.text! ,"university_school_id": self.selectUniversityOrSchoolType,"university_school_email": self.universityOrSchoolEmail_textField.text!,"password": self.enterPassword_textField.text!] as [String: AnyObject]
        
        print(param)
        
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "signup", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    //                    UserDefaults.standard.setValue((NSKeyedArchiver.archivedData(withRootObject: receviedData["data"]  as! [String: AnyObject])), forKey: "userData")
                    
                    
                    
                    self?.showAlertWithAction(Title: "Unilife", Message: "Signup successfully", ButtonTitle: "OK", outputBlock: {
                        
                        // successfull
                        
                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "OtpViewController") as! OtpViewController
                        
                        vc.user_id = String(describing: (receviedData["data"] as! [String: AnyObject])["id"]!)
                        
                        vc.controller = self!
                        
                        if let key = UserDefaults.standard.value(forKey: "signUpTime") as? String {
                            if key == "second" {
                                
                            } else {
                                
                                // UserDefaults.standard.set("first", forKey: "signUpTime")
                                
                            }
                        } else {
                            UserDefaults.standard.set("first", forKey: "signUpTime")
                        }
                        
                        self?.present(vc, animated: true, completion: nil)
                        
                        
                        //                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "OtpViewController") as! OtpViewController
                        //
                        //                    self?.present(vc, animated: true, completion: nil)
                    })
                    
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
                
            }else {
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
                
                
            }
            
        }
        
    }
    
    // MARK: - University Listing Response
    
    func universityListing() {
        
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "send_university") {[weak self] (receviedData) in
            
            print(receviedData)
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self?.universityListingArray = receviedData["data"] as! [[String: AnyObject]]
                    
                    self?.selectUniversity_TableView.reloadData()
                    
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                    
                }
                
            }else {
                
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
                
                
            }
            
        }
        
        
    }
    
    
    // MARK: - Validation
    
    func validation() {
        
        var message = ""
        
        //        let selectUniversityEmail = self.universityOrSchoolEmail_textField.text!
        
        //let selectUniversityArray1  =  Array(self.universityOrSchoolEmail_textField.text!)
        
        if self.selectUserType_textField.text!.replacingOccurrences(of: " ", with: "") == "" {
            
            message = "Please select user type "
            
        }
            
        else if self.enterUserNameOrId_textField.text!.replacingOccurrences(of: " ", with: "") == "" {
            
            message = "Please enter username or id"
        }
            
        else if selectUniversityOrSchool_textField.text!.replacingOccurrences(of: " ", with: "") == "" {
            
            message = "Please select university or school"
        }
            
        else if self.universityOrSchoolEmail_textField.text!.replacingOccurrences(of: " ", with: "") == "" {
            
            message = "Please enter university or school email"
        }
            
            
        else if !Validation().isValidEmail(self.universityOrSchoolEmail_textField.text!){
            
            message = "Please enter valid university or school email"
            
        }
            
        else if !self.universityOrSchoolEmail_textField.text!.contains(self.selectUniversityDomain) {
            
            message = "Please enter valid university or school email"
            
        }
            
        else if Array(self.universityOrSchoolEmail_textField.text!).first == "@"  {
            
            message = "Please enter valid user name with university email"
            
        }
            
        else if !self.universityOrSchoolEmail_textField.text!.contains(self.selectUniversityDomain) {
            
            message = "Please enter valid university or school email"
            
        }
            
        else if Array(self.universityOrSchoolEmail_textField.text!).first == "@"  {
            
            message = "Please enter valid user name with university email"
            
        }
            
        else if self.enterPassword_textField.text!.replacingOccurrences(of: " ", with: "") == "" {
            
            message = "Please enter password"
        }
            
        else if self.enterConfirmPassword_textField.text!.replacingOccurrences(of: " ", with: "") == "" {
            
            message = "Please confirm password"
        }
            
        else if self.enterPassword_textField.text! != self.enterConfirmPassword_textField.text! {
            
            message = "Password and confirm password should be same"
        }else if self.enterPassword_textField.text!.count < 6
        {
            
            message = "Password should not be less than 6 characters"
        }
            
        else {
            
            signUp()
            
        }
        
        if message != "" {
            
            self.showDefaultAlert(Message: message)
        }
        
        
        
        
    }
    
    
    
    // MARK: - Button Action
    
    
    @IBAction func tapCreate_btn(_ sender: Any) {
        
        self.validation()
        
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtpViewController") as! OtpViewController
        //
        //        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    @IBAction func tapSignIn_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func tapBack_btn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tapSelectUser_btn(_ sender: Any) {
        
        if selectUserType_TableView.isHidden {
            
            self.selectUserType_TableView.isHidden = false
            
        }else {
            
            self.selectUserType_TableView.isHidden = true
            
        }
    }
    
    
    @IBAction func tapSelectUniversity_btn(_ sender: Any) {
        
        //        if selectUniversity_TableView.isHidden {
        //
        //            self.selectUniversity_TableView.isHidden = false
        //
        //        }else {
        //
        //            self.selectUniversity_TableView.isHidden = true
        //
        //        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowUniversityListViewController") as! ShowUniversityListViewController
        
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}

extension SignUpViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == selectUniversity_TableView {
            
            return universityListingArray.count
            
            
        }else {
            
            return self.selectUserTypeArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == selectUniversity_TableView {
            
            let cell = self.selectUniversity_TableView.dequeueReusableCell(withIdentifier: "SelectUniversityTableViewCell") as! SelectUniversityTableViewCell
            
            cell.selectUniversity_lbl.text! = String(describing: (self.universityListingArray[indexPath.row])["name"]!).capitalized
            
            
            cell.selectUniversityButton_Width.constant = 0
            cell.selectUniversity_btn.isHidden = true
            return cell
            
        }else {
            
            let cell = self.selectUserType_TableView.dequeueReusableCell(withIdentifier: "SelectUniversityTableViewCell") as! SelectUniversityTableViewCell
            
            cell.selectUniversity_lbl.text! = self.selectUserTypeArray[indexPath.row]
            
            cell.selectUniversityButton_Width.constant = 0
            cell.selectUniversity_btn.isHidden = true
            
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == selectUniversity_TableView {
            
            selectUniversityOrSchool_textField.text! = String(describing: (self.universityListingArray[indexPath.row])["name"]!)
            
            
            Singleton().universityName =  String(describing: (self.universityListingArray[indexPath.row])["name"]!)
            
            selectUniversityOrSchoolType = String(describing: (self.universityListingArray[indexPath.row])["id"]!)
            
            self.universityOrSchoolEmail_textField.text! = ""
            
            self.universityOrSchoolEmail_textField.text! = String(describing: ((self.universityListingArray[indexPath.row])["university_domain"] as! [String: AnyObject])["domain"]!)
            
            self.selectUniversityDomain = String(describing: ((self.universityListingArray[indexPath.row])["university_domain"] as! [String: AnyObject])["domain"]!)
            self.selectUniversity_TableView.isHidden = true
            
        }else {
            self.selectUserType_textField.text! = self.selectUserTypeArray[indexPath.row]
            
            // ["Student", "Staff Facility", "Teacher"]
            
            if (self.selectUserTypeArray[indexPath.row]) == "Student" {
                
                self.selectUserType = "0"
            }else if self.selectUserTypeArray[indexPath.row]  == "Staff Facility" {
                self.selectUserType = "1"
                
            }else {
                self.selectUserType = "2"
                
            }
            
            self.selectUserType_TableView.isHidden = true
            
        }
    }
    
}

extension SignUpViewController: selectUniversityName{
    func select(universityName: String, universityDomin: String, universityId: String) {
        selectUniversityOrSchool_textField.text! = universityName
        
        
        Singleton().universityName =  universityName
        
        selectUniversityOrSchoolType = universityId
        
        self.universityOrSchoolEmail_textField.text! = ""
        
        self.universityOrSchoolEmail_textField.text! = universityDomin
        
        self.selectUniversityDomain = universityDomin
       // self.universityOrSchoolEmail_textField.text! = universityName
    }
    
 
}


