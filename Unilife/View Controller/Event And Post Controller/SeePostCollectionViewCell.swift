//
//  SeePostCollectionViewCell.swift
//  Unilife
//
//  Created by Apple on 04/10/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit
import AVFoundation

class SeePostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userPost_ImageView: UIImageView!
    
    @IBOutlet weak var userPost_VideoView: AvpVideoPlayer!
    
    @IBOutlet weak var video_btn: UIButton!
    
    
    var singlePostData =  [String: AnyObject]() {
        
        didSet {
            
            setData()
        }
    }
    
    
    private func setData() {
        
        if ((self.singlePostData)["attachment_type"]! as! String) == "image" {
            self.video_btn.isHidden = true
            self.userPost_VideoView.isHidden = true
            self.userPost_ImageView.isHidden = false
            self.userPost_ImageView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            
            //            self.userPost_ImageView.sd_setImage(with: URL(string: (postImageUrl + ((self.singlePostData)["attachment"] as! String))), placeholderImage: UIImage(named: "picture"), options: [])
            
            
            self.userPost_ImageView.sd_setImage(with: URL(string: (postImageUrl + ((self.singlePostData)["attachment"] as! String))), placeholderImage: UIImage(named: "noimage_icon"), options: .highPriority) {(image, error, type, url) in
                
                
                
                let ratio = (image?.size.width ?? 1.0 )/(image?.size.height ?? 1.0)
                
                print(ratio)
                
                self.userPost_ImageView.image =  self.ResizeImage(image: image ?? UIImage(named: "noimage_icon")!, targetSize: CGSize(width:  300 , height: 630))
                
                //                let image = image ?? UIImage(named: "noimage_icon")!
                //
                //                let newImage = image.resize(withSize: CGSize(width: 300, height: 400), contentMode: .contentAspectFill)
                //
                //                self.userPost_ImageView.image = newImage
                
            }
            
        }else {
            self.video_btn.isHidden = false
            
            print("Got Video")
            
            self.userPost_VideoView.isHidden = false
            self.userPost_ImageView.isHidden = true
            self.userPost_VideoView.configure(url: postImageUrl + ((self.singlePostData)["attachment"] as! String))
            
            self.userPost_VideoView.isLoop = false
            
            self.userPost_VideoView.play()
            
        }
        
        //        case .none:
        //            print("None")
        
    }
    
}

extension SeePostCollectionViewCell{
    
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        
        let heightRatio = targetSize.height / image.size.height
        
        
        // Figure out what our orientation is, and use that to form the rectangle
        
        var newSize: CGSize
        
        if(widthRatio > heightRatio) {
            
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            
        } else {
            
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
            
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        
        image.draw(in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        print(newImage)
        
        return newImage ?? image
        
    }
}






