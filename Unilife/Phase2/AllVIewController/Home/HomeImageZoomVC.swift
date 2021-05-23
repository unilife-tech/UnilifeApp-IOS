//
//  ViewController.swift
//  Wefintext
//
//  Created by developer on 05/12/19.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit



class HomeImageZoomVC: UIViewController {

   
    
    @IBOutlet weak var imgMedicalImage2: SOXPanRotateZoomImageView!
    var getimg:UIImage? = nil
    var delegate:imgPopupProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.clear
        spawnImage()
        /*
        let df = DateFormatter()
       self.view.backgroundColor = UIColor.clear
               imgMedicalImage.image = getimg
               
               let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedMe))
               imgMedicalImage.isUserInteractionEnabled = true
               imgMedicalImage.addGestureRecognizer(tapGestureRecognizer)
               
               
                 let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(self.tappedMe))
               self.view.addGestureRecognizer(tapGestureRecognizer2)
        */
           }
           
           
           
           @objc func tappedMe()
           {
               if(delegate != nil)
               {
                   delegate?.gotobackDelegate()
               }
               self.dismiss(animated: true, completion: nil)
           }
    override func viewWillAppear(_ animated: Bool) {
        //self.view.backgroundColor = UIColor.clear
    }
    
    
    func spawnImage() {
         
//         let imageView = SOXPanRotateZoomImageView(image: getimg)
//         imageView.center = self.view.center
//         self.view.addSubview(imageView)
        imgMedicalImage2.image = getimg
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedMe))
                      imgMedicalImage2.isUserInteractionEnabled = true
                      imgMedicalImage2.addGestureRecognizer(tapGestureRecognizer)
                      
                      
                        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(self.tappedMe))
                      self.view.addGestureRecognizer(tapGestureRecognizer2)
     }
}
