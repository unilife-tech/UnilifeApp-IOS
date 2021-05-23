//
//  ViewController.swift
//  Liqtrade
//
//  Created by developer on 25/06/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit

class CommingSoon: UIViewController {

    var getText:String = ""
    @IBOutlet weak var lblTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if(getText.count > 0)
        {
            lblTitle.text = getText
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
       self.tabBarController?.tabBar.isHidden = true
    }
    @IBAction func clickBack()
    {
        self.navigationController?.popViewController(animated: true)
    }

}

