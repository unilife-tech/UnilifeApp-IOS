//
//  ViewController.swift
//  Trendy
//
//  Created by developer on 17/04/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit

class SearchChatVC: UIViewController {

    @IBOutlet weak var txtSearch: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearch.layer.cornerRadius = 35/2
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        imageView.image = UIImage.init(named: "Symbol_search")
        imageView.contentMode = .center
        txtSearch.leftView = imageView;
        txtSearch.leftViewMode = UITextField.ViewMode.always
        
        if #available(iOS 13, *) {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = true
           //self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
      }
       
    @IBAction func clickBack()
    {
        self.navigationController?.popViewController(animated: true)
    }

}

