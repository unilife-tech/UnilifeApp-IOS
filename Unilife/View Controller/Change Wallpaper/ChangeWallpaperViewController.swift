//
//  ChangeWallpaperViewController.swift
//  Unilife
//
//  Created by Apple on 03/09/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit
import TOCropViewController

class ChangeWallpaperViewController: UIViewController {
    
    // MARK: - Outlet
    let imgBGName = "unilifeBackgroundImage_fileDiractry.png"
    @IBOutlet weak var changeWallpaperImage_View: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    
    // MARK: - Variable
    
    let image_picker = UIImagePickerController()
    
    var cropStyle:TOCropViewCroppingStyle?
    
    var cropViewController = TOCropViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        btnDelete.isHidden = true
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
           let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(imgBGName)
           let image    = UIImage(contentsOfFile: imageURL.path)
           if(image != nil)
           {
                self.changeWallpaperImage_View.image = image
                btnDelete.isHidden = false
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true
        
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Chat", titlePosition: .Middle, right: .Icon, rightButtonIconOrTitle: "dots_icon", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {
            
            
            guard let popoverContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestReceviedPopUpViewController") as? RequestReceviedPopUpViewController else {return}
            
            popoverContent.controller = self
            
            popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
            
            popoverContent.preferredContentSize = CGSize(width: 200, height: 200)
            
            let popOver = popoverContent.popoverPresentationController
            
            popOver?.delegate = self
            //
            popOver?.sourceView = self.navigationItem.rightBarButtonItem?.customView  as! UIView
            //
            popOver?.sourceRect = (self.navigationItem.rightBarButtonItem?.customView  as AnyObject).bounds
            //
            popOver?.permittedArrowDirections = [.up, .right]
            
            
            self.present(popoverContent, animated: true, completion: nil)
            
            
            
        })
        
    }
    
    
    // MARK: - Upload Chat Wallpaper
    
    func uploadWallpaper() {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId, "type": "image"]
        
        let name = String(describing: Date().toMillis()!) + UserData().userId + "image.jpeg"
        
        Singleton.sharedInstance.connection.startConnectionWithSingleFile(FileData: self.changeWallpaperImage_View.image!.jpegData(compressionQuality: 0.8) as! Data, FileName: name, FileType: "image/jpg", FileParam: "image", getUrlString: "user_chat_wallpaper", params: param as [String: AnyObject]) { (receviedData,responseCode) in
            
             Indicator.shared.hideProgressView()
            
            if responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self.showAlertWithAction(Title: "Unilife", Message: "Wallpaper Changed Successfully;", ButtonTitle: "Ok", outputBlock: {
                        
                        self.navigationController?.popViewController(animated: true)
                    })
                    
                    
                }else {
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
                
            }else {
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
                
            }
            
        }
    }
    
    // MARK: - Button Action
    
    
    @IBAction func tapChangeWallpaper_btn(_ sender: Any) {
        if self.changeWallpaperImage_View.image == UIImage(named: "add-post"){
            
            self.showDefaultAlert(Message: "Please select image to set wallpaper")
        }else if (self.changeWallpaperImage_View.image == nil)
        {
             self.showDefaultAlert(Message: "Please select image to set wallpaper")
        }
        
        else {
            
            //self.uploadWallpaper()
            ////..... save locally
          //  DeleteimageAlready()
            
            //DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            // create a name for your image
                let fileURL = documentsDirectoryURL.appendingPathComponent(self.imgBGName)
            print(fileURL)
            print(self.changeWallpaperImage_View.image)
           // if !FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try self.changeWallpaperImage_View.image!.pngData()!.write(to: fileURL)
                        print("Image Added Successfully")
                    self.btnDelete.isHidden = false
                    
                    
                    self.showAlertWithAction(Title: "Unilife", Message: "Wallpaper Changed Successfully", ButtonTitle: "Ok", outputBlock: {
                                          
                                          self.navigationController?.popViewController(animated: true)
                                      })
                    
                    
                    } catch {
                        print(error)
                    }
//                } else {
//
//                    print("Image alredy exist")
//                ////.... Need to update
//            }
            
         //   }
            
            
        }
        
        
    }
    
    @IBAction func addImage_btn(_ sender: Any) {
        
        self.showPicker()
    }
    
    
    @IBAction func clickDelete(_ sender: Any) {
        
//        let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//                  // create a name for your image
//        let fileURL = documentsDirectoryURL.appendingPathComponent(imgBGName)
        

       let fileManager = FileManager.default
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        let documentsPath = documentsUrl.path

        do {
            if let documentPath = documentsPath
            {
                let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                for fileName in fileNames {
                    
                    if (fileName == imgBGName)
                    {
                        let filePathName = "\(documentPath)/\(fileName)"
                        try fileManager.removeItem(atPath: filePathName)
                        break
                    }
                }

                self.showAlertWithAction(Title: "Unilife", Message: "Wallpaper Delete Successfully;", ButtonTitle: "Ok", outputBlock: {
                                      
                                      self.navigationController?.popViewController(animated: true)
                                  })
                
            }

        } catch {
            print("Could not clear temp folder: \(error)")
        }
        
        
        
       
        
    }
    
    
    
    func DeleteimageAlready()
    {
        let fileManager = FileManager.default
               let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
               let documentsPath = documentsUrl.path

               do {
                   if let documentPath = documentsPath
                   {
                       let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                       for fileName in fileNames {
                           print(fileName)
                           if (fileName == imgBGName)
                           {
                               let filePathName = "\(documentPath)/\(fileName)"
                               try fileManager.removeItem(atPath: filePathName)
                               break
                           }
                       }

                     
                       
                   }

               } catch {
                   print("Could not clear temp folder: \(error)")
               }
    }
    
}

extension ChangeWallpaperViewController: UIPopoverPresentationControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.changeWallpaperImage_View.image = selectedImage
        /*
        cropStyle = TOCropViewCroppingStyle.default
        
        cropViewController.customAspectRatio = CGSize(width: self.changeWallpaperImage_View.frame.size.width, height: self.changeWallpaperImage_View.frame.size.height)
        
        
        cropViewController = TOCropViewController(croppingStyle: cropStyle!, image: selectedImage)
        
        cropViewController.toolbar.clampButtonHidden = true
        
        
        cropViewController.toolbar.rotateClockwiseButtonHidden = true
        
        cropViewController.cropView.setAspectRatio(CGSize(width: self.changeWallpaperImage_View.frame.size.width, height: self.changeWallpaperImage_View.frame.size.height  ), animated: true)
        
        
        cropViewController.cropView.aspectRatioLockEnabled = true
        
        cropViewController.toolbar.rotateButton.isHidden = true
        
        
        
        cropViewController.toolbar.resetButton.isHidden = true
        
        
        
        cropViewController.delegate = self
        
        
        */
        dismiss(animated: true, completion: nil)
        
        
        
     //   self.navigationController?.present(cropViewController, animated: true, completion: nil)
        
        
        
    }
    
    
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        
        
        
        self.changeWallpaperImage_View.contentMode = .scaleToFill
        self.changeWallpaperImage_View.image = image
        self.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    
    
    func showPicker(){
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            
            actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
                
                
                
                self.camera()
                
                
                
            }))
            
            
            
            actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: {(alert:UIAlertAction) -> Void in
                
                
                
                self.photolibrary()
                
                
                
            }))
            
            
            
        }else{
            
            
            
            actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: {(alert:UIAlertAction) -> Void in
                
                
                
                self.photolibrary()
                
                
                
            }))
            
            
            
        }
        
        
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        
        
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad{
            
            
            
            let popUp = UIPopoverController(contentViewController: actionSheet)
            
            
            
            popUp.present(from: CGRect(x: 15, y: self.view.frame.height - 150, width: 0, height: 0), in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
            
            
            
        }else{
            
            
            
            self.present(actionSheet, animated: true, completion: nil)
            
            
            
        }
        
        
        
    }
    
    
    
    func camera(){
        
        self.image_picker.sourceType = .camera
        
        self.image_picker.delegate = self
        
        present(image_picker, animated: true, completion: nil)
        
    }
    
    func photolibrary(){
        
        self.image_picker.sourceType = .photoLibrary
        
        self.image_picker.delegate = self
        
        present(image_picker, animated: true, completion: nil)
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}
