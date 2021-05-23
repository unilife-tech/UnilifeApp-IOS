//
//  SelectSinInOrSignUpViewController.swift
//  Unilife
//
//  Created by promatics on 21/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class SelectSinInOrSignUpViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet var signForFree_btn: UIButton!
    
    @IBOutlet var signIn_btn: UIButton!
    
    ///... loginScreen
    @IBOutlet weak var collectionHeader: UICollectionView!

       var aryData:[String] = ["1 Splash","Background2","background3","Background4","Background5","Background6"]
       var aryInsideData:[String] = ["","IMG2","IMG3","IMG4","IMG5","IMG6"]
       var aryTitleData:[String] = ["","new way to communicate in uni. individual and group chat","Be updated on events \nand activities in Uni","Browse through your \nfriends profile","Exclusive Student \nDiscounts And Offers","Explore Student \nlifestyle contents"]
       
       @IBOutlet weak var pageContr: UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
   
//        override var prefersStatusBarHidden: Bool {
//
//               if #available(iOS 13, *) {
//
//                    return false
//
//               }else {
//               return false
//
//               }
//           }
//
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.signIn_btn.setTitle("Sign In", for: .normal)
        self.signIn_btn.titleLabel?.font = UIFont(name: "Arcon-Regular", size: 25)
       // let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
//        statusBar.isHidden = true
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
//        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
//        statusBar.isHidden = false
        
    }
    
    
    
    
    @IBAction func tapSingUp_btn(_ sender: Any) {
        
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        
    self.navigationController?.pushViewController(vc, animated: true )
    }
    
    
    
    
    @IBAction func tapSiginIn_btn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        
        self.navigationController?.pushViewController(vc, animated: true )
        
    }
    
    ////..... Login
    @IBAction func click_(sender:UIButton)
       {
           if(sender.tag == 0) ///.. login
           {
               let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
               self.navigationController?.pushViewController(vc, animated: true)
               
           }else    ////.... regis
           {
            
//            let vc = kLoginStoryBoard.instantiateViewController(withIdentifier: "AddNewContact_New11") as! AddNewContact_New11
//            self.navigationController?.pushViewController(vc, animated: true)
            
               let vc = kLoginStoryBoard.instantiateViewController(withIdentifier: "RegistrationVC_New3") as! RegistrationVC_New3
               self.navigationController?.pushViewController(vc, animated: true)
           }
       }
    
     
}


//------------------------------------------------------
// MARK: Collection View   ------
//------------------------------------------------------


extension SelectSinInOrSignUpViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.aryData.count
        
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoginIntroCell", for: indexPath as IndexPath) as! LoginIntroCell
        let getimg:String = self.aryData[indexPath.row]
        cell.imgBG.image = UIImage.init(named:getimg)
        let getimgInside:String = self.aryInsideData[indexPath.row]
        cell.img.image = UIImage.init(named:getimgInside)
        cell.btnLogin.layer.cornerRadius = 35/2
        cell.btnRegis.layer.cornerRadius = 35/2
        cell.btnRegis2.layer.cornerRadius = 35/2
        cell.btnRegis.layer.borderColor = UIColor.white.cgColor
        cell.btnRegis.layer.borderWidth = 2.0
        cell.btnRegis2.layer.borderColor = UIColor.black.cgColor
        cell.btnRegis2.layer.borderWidth = 2.0
        cell.lblTitle.text = aryTitleData[indexPath.row]
        
        if(indexPath.row == 0)
        {
            cell.viwBottom.isHidden = true
            ///.. this is for first cell
            cell.btnRegis.isHidden = false
            cell.btnRegis2.isHidden = true
            cell.lblUnilife.isHidden = false
            cell.lblSTudent.isHidden = false
            cell.imgICon.isHidden = false
            
        }else
        {
            cell.viwBottom.isHidden = false
            ///.. this is for first cell
            cell.btnRegis.isHidden = true
            cell.btnRegis2.isHidden = false
            cell.lblUnilife.isHidden = true
            cell.lblSTudent.isHidden = true
            cell.imgICon.isHidden = true
        }
            return cell
        
        
                
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: self.view.bounds.size.width, height: collectionView.frame.size.height)
        
    
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//------------------------------------------------------
// MARK: UIScrollViewDelegate   ------------------------------------------------------
//------------------------------------------------------

extension SelectSinInOrSignUpViewController:UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.tag == 1000)
        {
            let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
            if let ip = self.collectionHeader.indexPathForItem(at: center) {
                self.pageContr.currentPage = ip.row
                //self.currentPage = ip.row
            }
        }
        
    }
}
