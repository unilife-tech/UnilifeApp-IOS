//
//  FeedBackViewController.swift
//  Unilife
//
//  Created by Apple on 21/11/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class FeedBackViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var starRating_View: FloatRatingView!
    
    @IBOutlet weak var writeFeedback_TextView: GrowingTextView!
    
    @IBOutlet weak var submit_btn: SetButton!
    
    // MARK: - Variable
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    deinit {
        
        print(#file)
    }
    
    // MARK: - Button Action
    
    
    @IBAction func tapSubmit_btn(_ sender: Any) {
        
        if self.starRating_View.rating.isZero{
            self.showDefaultAlert(Message: "Please select stars")
            
        }
        else {
            
            giveRating()
            
        }
        
        
    }
    
    
    @IBAction func tapBack_btn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}

extension FeedBackViewController{
    
    func giveRating() {
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId as AnyObject,
                     "rating": String(Float(starRating_View.rating)),
                     "feedback": self.writeFeedback_TextView.text!] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "get_feedback", params: param as [String: AnyObject]){[weak self] (receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true{
                    
                    self?.showAlertWithAction(Title: "Unilife", Message: ((receviedData as? [String: AnyObject])? ["data"] as? String ?? "Thank you for your feedback"), ButtonTitle: "Ok", outputBlock: {
                        
                        self?.navigationController?.popViewController(animated: true)
                        
                    })
                    
                    
                }else {
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                
                self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["Error"] as? String ?? "No data found")
            }
            
        }
    }
}
