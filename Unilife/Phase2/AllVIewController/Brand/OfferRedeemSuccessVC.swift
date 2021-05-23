//
//  ViewController.swift
//  Trendy
//
//  Created by developer on 17/04/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit


class OfferRedeemSuccessVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    
    var getTitle:String = ""
    var getID:Int = 0
    var getDic:NSDictionary = NSDictionary()
   // var code:String  = ""
    var fourDigitNumber: String {
     var result = ""
     repeat {
         // Create a string with a random number 0...9999
         result = String(format:"%04d", arc4random_uniform(10000) )
     } while Set<Character>(result.characters).count < 4
     return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = self.getTitle
        self.lblCode.text = fourDigitNumber + "-" + fourDigitNumber + "-" + fourDigitNumber
            //getDic.value(forKey: "code") as? String ?? ""
    }

    @IBAction func click_Back()
         {
            var isfound:Bool = false
            if (self.navigationController != nil) {
                for vc in  self.navigationController!.viewControllers {
                    if vc is BrandDetails {
                        isfound = true
                        self.navigationController?.popToViewController(vc, animated: false)
                        break
                    }
                }
            }
            if(isfound == false)
            {
                self.navigationController?.popToRootViewController(animated: true)
            }
         }
    
    @IBAction func click_ShareWithFriends()
            {
               shareOnMobile()
            }
    
    
    func shareOnMobile()
       {
              let text =  kInviteMessage
                        let textShare = [ text ]
                        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
                        activityViewController.popoverPresentationController?.sourceView = self.view
                        self.present(activityViewController, animated: true, completion: nil)
       }
}



