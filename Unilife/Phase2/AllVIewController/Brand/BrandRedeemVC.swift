//
//  ViewController.swift
//  Trendy
//
//  Created by developer on 17/04/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit

class BrandRedeemVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtRedeem: UITextField!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblDiscount: UILabel!
    
    var getTitle:String = ""
    var getID:Int = 0
    var getDic:NSDictionary = NSDictionary()
    var code:String  = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
         lblTitle.text = self.getTitle
        
        let discount_message = getDic.value(forKey: "discount_message") as? String ?? ""
        self.code = getDic.value(forKey: "code") as? String ?? ""
        self.txtRedeem.text = self.code
        self.lblDiscount.text = discount_message
        imgUserProfile.sd_setImage(with: URL(string: profileImageUrl + UserData().image), placeholderImage: UIImage(named: "noimage_icon"))
        
    }
    override func viewWillAppear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = true
           //self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
           
           
       }

    @IBAction func click_Back()
       {
           self.navigationController?.popViewController(animated: true)
       }
    
     @IBAction func click_CopyRedeem()
     {
        let pasteboard = UIPasteboard.general
        pasteboard.string = self.code
        
         self.navigationController?.view.makeToast("code copied", duration: 2.0, position: .top)
    }
    
    @IBAction func click_Redeem()
        {
            
            
            let online_redeem_link = getDic.value(forKey: "online_redeem_link") as? String ?? ""
            if(online_redeem_link.count > 0)
            {
                if let url = NSURL(string:online_redeem_link)
                {
                     UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                 }else
                {
                 self.localAlert(getMSG: "Link not valid")
                 }
            }else
            {
                self.localAlert(getMSG: "Link not valid")
            }
          // connection_doReedeem()
       }
    
    func localAlert(getMSG:String)
    {
           let alert = UIAlertController(title: msgTitle, message: getMSG, preferredStyle: UIAlertController.Style.alert)
                 alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                 
                 alert.view.tintColor = UIColor.appSkyBlue
                 
           self.present(alert, animated: true, completion: nil)
    }
}



//------------------------------------------------------
// MARK: API     ------------------------------------------------------
//------------------------------------------------------

extension BrandRedeemVC
{
    func connection_doReedeem()
        {
            //.... check inter net
            
            let status = Reach().connectionStatus()
            switch status {
            case .unknown, .offline:
                //print("Not connected")
                
               Singleton.sharedInstance.customAlert(getMSG: FAILED_INTERNET)
                
                return
            case .online(.wwan):
                print("")
            case .online(.wiFi):
                print("")
            }
         
            let params = [
                "type":"online",
                "code":self.code,
                "brand_id":getID
                ] as [String : Any]
            Indicator.shared.showProgressView(self.view)
        //ApplicationManager.instance.startloading()
      print(params)
            print(ConstantsHelper.redeem_voucher)
            WebServiceManager.shared.callWebService_Home(ConstantsHelper.redeem_voucher, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
                
              
                
                if(response is NSDictionary)
                {
                    
                   print(response)
                    let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                    if(status == true)
                    {
                        
                        let getMessage = (response as! NSDictionary).value(forKey: "message") as? String ?? ""
                        
                        self.navigationController?.popViewController(animated: true)
                      Singleton.sharedInstance.customAlert(getMSG: getMessage)
                      
                        
                    }else
                    {
                        let getMessage = (response as! NSDictionary).value(forKey: "message") as? String ?? ""
                       Singleton.sharedInstance.customAlert(getMSG: getMessage)
                        
                    }
                }else
                {
                    Indicator.shared.hideProgressView()
                    
                  
                    Singleton.sharedInstance.customAlert(getMSG: API_FAILED)
                }
                
                
            }
            
        }
}
