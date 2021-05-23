//
//  ViewController.swift
//  BMPG
//
//  Created by developer on 07/05/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit
import IQDropDownTextField

class RegistrationVC_New7: UIViewController {
    
    @IBOutlet weak var txtDOB: IQDropDownTextField!
    @IBOutlet weak var img1: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UpdateUI()
    }
    
    func UpdateUI()
    {
        let df = DateFormatter()
        df.dateFormat = "MMM dd, yyyy"
        self.txtDOB.dropDownMode = IQDropDownMode.datePicker
        self.txtDOB.isOptionalDropDown = true
        self.txtDOB.dateFormatter = df
        img1.layer.cornerRadius = 5
        img1.layer.borderColor = UIColor.white.cgColor
        img1.layer.borderWidth = 2
    }
    
    @IBAction func click_Back()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func click_calendar()
    {
        self.txtDOB.becomeFirstResponder()
    }
    
    @IBAction func click_next()
    {
        let msg: String = self.validateTxtFields()
        if !(msg == "") {
            self.view.endEditing(true)
            self.showDefaultAlert(Message: msg)
        }
        else {
            self.gotoNext()
        }
    }
    
    func gotoNext()
    {
        let getdate:Date = self.txtDOB.date ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        ApplicationManager.instance.reg_Dic["dob"] = dateFormatter.string(from: getdate)
        let vc = kLoginStoryBoard.instantiateViewController(withIdentifier: "RegistrationVC_New8") as! RegistrationVC_New8
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func validateTxtFields() -> String {
        var msg: String = ""
        if textFieldValidation.instance.isTextFieldHasEmptyText(text: (self.txtDOB?.selectedItem ?? ""  )!)
        {
            msg = kmsgdob
        }
        return msg;
    }
}

