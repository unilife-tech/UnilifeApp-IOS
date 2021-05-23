//
//  ViewController.swift
//  BMPG
//
//  Created by developer on 07/05/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit

class RegistrationVC_New6: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func click_Back()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func click_section(sender:UIButton)
    {
        switch sender.tag {
        case 0:
            ApplicationManager.instance.reg_Dic["type"] = "male"
                 gotoNext()
            case 1:
                ApplicationManager.instance.reg_Dic["type"] = "female"
                     gotoNext()
            case 2:
                ApplicationManager.instance.reg_Dic["type"] = ""
                     gotoNext()
        default:
            print("--")
        }
    }
    
    func gotoNext()
         {
             
             let vc = kLoginStoryBoard.instantiateViewController(withIdentifier: "RegistrationVC_New7") as! RegistrationVC_New7
             self.navigationController?.pushViewController(vc, animated: true)
         }
}

