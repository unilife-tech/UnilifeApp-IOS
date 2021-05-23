//
//  ContactUsViewController.swift
//  Unilife
//
//  Created by Sourabh Mittal on 29/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- Outlet's
    
    @IBOutlet weak var contactUsLbl: UILabel!
    @IBOutlet weak var queryFormLbl: UILabel!
    @IBOutlet weak var selectTypeConcern_Titlelbl: UILabel!
    
    @IBOutlet weak var selectTypeConcernValue_textField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var enterDescriptionOrText_TextView: GrowingTextView!
    
    @IBOutlet weak var selectSchoolOrUniversityTitle_lbl: UILabel!
    
    @IBOutlet weak var selectSchoolOrUniversityValue_textField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var universityOrSchoolEmailTitle_lbl: UILabel!
    
    @IBOutlet weak var universityOrSchoolEmailValue_TextField: AppDefaultTextField!
    
    @IBOutlet weak var subject_TextView: GrowingTextView!
    
    @IBOutlet weak var save_btn: SetButton!
    
    @IBOutlet weak var selectUniversity_TableView: UITableView!
    
    @IBOutlet weak var selectConcern_TableView: UITableView!
    
    @IBOutlet weak var selectConcernTableView_Height: NSLayoutConstraint!
    
    @IBOutlet weak var selectUniversityTableView_Height: NSLayoutConstraint!
    
    // MARK: - Variable
    
    var universityListingArray = [[String: AnyObject]]()
    
    var selectUniversityDomain = ""
    var selectUniversityOrSchoolType = ""
    var selectConcernType = ["Query","Report"]
    
    var type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectConcern_TableView.delegate = self
        
        self.selectConcern_TableView.dataSource = self
        
        self.selectUniversity_TableView.delegate = self
        
        self.selectUniversity_TableView.dataSource = self
        
        self.selectUniversity_TableView.isHidden = true
        self.selectConcern_TableView.isHidden = true
        
        self.selectUniversityTableView_Height.constant = 0
        self.selectConcernTableView_Height.constant = 0
        
        self.universityListing()
    }
    
    deinit {
        print(#file)
        
    self.universityListingArray = []
    
    }
    
    
    //MARK:- View Will Appear
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = UIColor.appSkyBlue
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        self.queryFormLbl.font = UIFont(name: "Arcon-Regular", size: 14.00)
        //        self.queryFormLbl.text = "Any Query then please feel free to ask by \n filling the *Contact Us* Form"
        self.queryFormLbl.textAlignment = .center
        //        self.queryFormLbl.textColor = UIColor(red: 85, green: 182, blue: 236, alpha: 1)
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Help ", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
        
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
        
        
    }
    
    // MARK: - Table Vew Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == selectConcern_TableView {
            
            return 2
        }else {
            
            return self.universityListingArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == selectConcern_TableView {
            
            let cell = self.selectConcern_TableView.dequeueReusableCell(withIdentifier: "SelectConcernTableViewCell") as! SelectConcernTableViewCell
            
            cell.selectConcern_lbl.text! = self.selectConcernType[indexPath.row]
            
            return cell
            
        }else {
            
            let cell = self.selectUniversity_TableView.dequeueReusableCell(withIdentifier: "SelectUniversityTableViewCell") as! SelectUniversityTableViewCell
            
            cell.selectUniversity_lbl.text! = String(describing: (self.universityListingArray[indexPath.row])["name"]!).capitalized
            
            return cell
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == selectConcern_TableView {
            
            self.selectTypeConcernValue_textField.text! = self.selectConcernType[indexPath.row]
            
            self.type = self.selectConcernType[indexPath.row]
            
            self.selectConcern_TableView.isHidden = true
            
            
        }else {
            
            self.selectSchoolOrUniversityValue_textField.text! = String(describing: (self.universityListingArray[indexPath.row])["name"]!)
            
            selectUniversityOrSchoolType = String(describing: (self.universityListingArray[indexPath.row])["id"]!)
            
            //            self.selectSchoolOrUniversityValue_textField.text! = ""
            
            self.universityOrSchoolEmailValue_TextField.text! = String(describing: ((self.universityListingArray[indexPath.row])["university_domain"] as! [String: AnyObject])["domain"]!)
            
            self.selectUniversityDomain = String(describing: ((self.universityListingArray[indexPath.row])["university_domain"] as! [String: AnyObject])["domain"]!)
            
            self.selectUniversity_TableView.isHidden = true
        }
    }
    
    // MARK: - Button Action
    
    @IBAction func tapSelectTypeOfConcern_btn(_ sender: Any) {
        
        if self.selectConcern_TableView.isHidden {
            
            self.selectConcern_TableView.isHidden = false
            
            self.selectConcernTableView_Height.constant = 60
            
        }else {
            
            self.selectConcern_TableView.isHidden = true
            
            self.selectConcernTableView_Height.constant = 0
        }
        
        
    }
    
    
    @IBAction func tapSelectUniversityOrSchool_btn(_ sender: Any) {
        
//        if self.selectUniversity_TableView.isHidden {
//
//            self.selectUniversity_TableView.isHidden = false
//
//            self.selectUniversityTableView_Height.constant = CGFloat(self.universityListingArray.count * 30)
//        }else {
//
//            self.selectUniversity_TableView.isHidden = true
//            self.selectUniversityTableView_Height.constant = 0
//
//        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowUniversityListViewController") as! ShowUniversityListViewController
               
               vc.delegate = self
               
               self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func tapSave_btn(_ sender: Any) {
        
        validations()
    }
    // MARK: - Validations
    
    func validations(){
        
        var message = ""
        
        if self.selectTypeConcernValue_textField.text!.replacingOccurrences(of: " ", with: "") == "" {
            
            message = "Please select type of concern "
        }else if self.enterDescriptionOrText_TextView.text!.replacingOccurrences(of: " ", with: "") == "" {
            
            message = "Please write description "
            
        }else if self.selectSchoolOrUniversityValue_textField.text!.replacingOccurrences(of: " ", with: "") == "" {
            
            message = "Please select university or school"
        }else if self.universityOrSchoolEmailValue_TextField.text!.replacingOccurrences(of: " ", with: "") == "" {
            
            message = "Please ennter university or school email "
        }else if !self.universityOrSchoolEmailValue_TextField.text!.contains(self.selectUniversityDomain) {
            
            message = "Please enter valid university or school email"
            
        }
            
        else if Array(self.universityOrSchoolEmailValue_TextField.text!).first == "@"  {
            
            message = "Please enter valid user name with university email"
            
        }
            
        else if self.subject_TextView.text! == ""{
            
            message = "Please enter subject"
        }else {
            
            contactUs()
        }
        
        if message != "" {
            
            self.showDefaultAlert(Message: message)
        }
    }
    
}

extension ContactUsViewController {
    
    // MARK: - Contact Us
    
    func contactUs() {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["type": self.type,"description": self.enterDescriptionOrText_TextView.text!,"user_id": UserData().userId,"subject": self.subject_TextView.text!] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "help", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            
            print(receviedData)
            
            
            guard let self = self else {
                return
            }
            
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1  {
                
                if receviedData["response"] as? Bool == true {
                    
                    //                 self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    self.showAlertWithAction(Title: "Unilife", Message: "Thanks for contacting us we will contact you shortly", ButtonTitle: "OK", outputBlock: {
                         self.navigationController?.popViewController(animated: true)
                        
                    })
                    
                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                }
                
                
            }else {
                
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
            }
            
            
        }
    }
    
    // MARK: - University Listing Response
    
    func universityListing() {
        
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "send_university") {[weak self] (receviedData) in
            
            print(receviedData)
            
            guard let self = self else {
                return
            }
            
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self.universityListingArray = receviedData["data"] as! [[String: AnyObject]]
                    
                    self.selectUniversity_TableView.reloadData()
                    
                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                
                self.showDefaultAlert(Message: receviedData["Error"] as! String)
               
            }
            
        }
        
    }
}

extension ContactUsViewController: selectUniversityName{

    func select(universityName: String, universityDomin: String, universityId: String) {
        
        self.selectSchoolOrUniversityValue_textField.text!  = universityName
        
        
      //  Singleton().universityName =  universityName
        
        selectUniversityOrSchoolType = universityId
        
       self.universityOrSchoolEmailValue_TextField.text! = ""
        
        self.universityOrSchoolEmailValue_TextField.text! = universityDomin
        
       // self.selectUniversityDomain = universityDomin
        // self.universityOrSchoolEmail_textField.text! = universityName
    }
}
