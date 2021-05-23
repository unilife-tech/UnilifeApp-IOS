//
//  ViewController.swift
//  BMPG
//
//  Created by developer on 07/05/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit

class LoginVC_New: UIViewController {

    @IBOutlet weak var collectionHeader: UICollectionView!

    var aryData:[String] = ["1 Splash","Background2","background3","Background4","Background5","Background6"]
    var aryInsideData:[String] = ["","IMG2","IMG3","IMG4","IMG5","IMG6"]
    var aryTitleData:[String] = ["","new way to communicate in uni. individual and group chat","Be updated on events \nand activities in Uni","Browse through your \nfriends profile","Exclusive Student \nDiscounts And Offers","Explore Student \nlifestyle contents"]
    
    @IBOutlet weak var pageContr: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        if UserDefaults.standard.value(forKey: "userData") != nil {
                    Switcher.afterLogin()
         }
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }

    func updateUI()
    {
  
    }
    
    
    @IBAction func click_(sender:UIButton)
    {
        ////... same code in another screen 
        if(sender.tag == 0) ///.. login
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else    ////.... regis
        {
//            let vc = kLoginStoryBoard.instantiateViewController(withIdentifier: "Registration_ContactVC") as! Registration_ContactVC
//            self.navigationController?.pushViewController(vc, animated: true)
          
            let vc = kLoginStoryBoard.instantiateViewController(withIdentifier: "RegistrationVC_New3") as! RegistrationVC_New3
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }

}




//------------------------------------------------------
// MARK: Collection View   ------
//------------------------------------------------------


extension LoginVC_New:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
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

extension LoginVC_New:UIScrollViewDelegate
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
