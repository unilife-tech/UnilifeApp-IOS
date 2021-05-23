//
//  ViewController.swift
//  BMPG
//
//  Created by developer on 07/05/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit

class RegistrationVC_New2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }


    @IBAction func click_Back()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func click_next()
    {
        let vc = kLoginStoryBoard.instantiateViewController(withIdentifier: "RegistrationVC_New3") as! RegistrationVC_New3
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

