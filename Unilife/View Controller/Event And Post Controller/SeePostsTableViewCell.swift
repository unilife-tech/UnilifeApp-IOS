//
//  SeePostsTableViewCell.swift
//  Unilife
//
//  Created by Apple on 26/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit
import iCarousel
import  SDWebImage

class SeePostsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var addNewPost_btn: SetButton!
    
    @IBOutlet weak var userProfile_ImageView: CircleImage!
    
    @IBOutlet weak var userName_lbl: UILabel!
    
    @IBOutlet weak var userNameLbl_Height: NSLayoutConstraint!
    
    @IBOutlet weak var postAddedTime_lbl: UILabel!
    
    @IBOutlet weak var userEducation_lbl: UILabel!
    
    @IBOutlet weak var postImage_Slider: iCarousel!
    
    @IBOutlet weak var like_btn: UIButton!
    
    @IBOutlet weak var comment_btn: UIButton!
    
    @IBOutlet weak var send_btn: UIButton!
    
    @IBOutlet weak var likesCount_lbl: UILabel!
    
    @IBOutlet weak var postDescription_lbl: UILabel!
    
    @IBOutlet weak var viewAllComment_btn: UIButton!
    
    @IBOutlet weak var postTime_lbl: UILabel!
    
    @IBOutlet weak var postCount_PageControl: UIPageControl!
    
    @IBOutlet weak var profile_btn: UIButton!
    
    @IBOutlet weak var profileName_btn: UIButton!
    
    @IBOutlet weak var postSlider_Height: NSLayoutConstraint!
    
    @IBOutlet weak var postCountPageControl_height: NSLayoutConstraint!
    
    @IBOutlet weak var postCountPageControl_Width: NSLayoutConstraint!
    
    @IBOutlet weak var comment_View: UIView!
    
    @IBOutlet weak var commentUserName_lbl: UILabel!
    
    @IBOutlet weak var commentUserTag_lbl: UILabel!
    
    @IBOutlet weak var commentUserprofile_Image: CircleImage!
    
    @IBOutlet weak var showComment_btn: UIButton!
    
    @IBOutlet weak var seeAllPost_CollectionView: UICollectionView!
    
    @IBOutlet weak var viewLikes_btn: UIButton!
    
    @IBOutlet weak var groupNmae_ImageView: UIImageView!
    
    @IBOutlet weak var groupName_lbl: UILabel!
    
    @IBOutlet weak var groupNameLabel_height: NSLayoutConstraint!
    
    @IBOutlet weak var groupNameImageView_Height: NSLayoutConstraint!
    
    @IBOutlet weak var eductionUniversity_Image: UIImageView!
    
    @IBOutlet weak var educationUniversityImage_height: NSLayoutConstraint!
    
    @IBOutlet weak var educationUniversityImage_Width: NSLayoutConstraint!
    
    @IBOutlet weak var educationLabel_top: NSLayoutConstraint!
    
    @IBOutlet weak var educationbottom_down: NSLayoutConstraint!
    
    @IBOutlet weak var groupImageView_Width: NSLayoutConstraint!
    
    @IBOutlet weak var education_View: UIView!
    
    @IBOutlet weak var educationView_height: NSLayoutConstraint!
    
    @IBOutlet weak var group_View: UIView!
    
    @IBOutlet weak var threeDot_btn: UIButton!
    
    @IBOutlet weak var delete_btn: UIButton!
    
    @IBOutlet weak var deleteButton_Width: NSLayoutConstraint!
    
    @IBOutlet weak var description_btn: UIButton!
    
    
    
    // MARK: - Variable
    
    var postImage = [UIImage(named: "Sliderbig-2.png"), UIImage(named: "Sliderbig.png")]
    
    var postImageData = [[String: AnyObject]]()
    
    var storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    var nav: UINavigationController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.postImage_Slider.type = .linear
        
        self.postImage_Slider.delegate = self
        
        self.postImage_Slider.dataSource = self
        
        self.postImage_Slider.bounces = false
        
        self.postImage_Slider.clipsToBounds = true
        
        self.postImage_Slider.layer.masksToBounds = true
        
        self.seeAllPost_CollectionView.register(UINib(nibName: "SeePosts", bundle: nil), forCellWithReuseIdentifier: "SeePostCollectionViewCell")
        
        self.seeAllPost_CollectionView.delegate = self
        
        self.seeAllPost_CollectionView.dataSource = self
        
        self.postCount_PageControl.numberOfPages = self.postImageData.count
        
        self.postImage_Slider.reloadData()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

// MARK: - ICarousel Delegate And DataSoucre

extension SeePostsTableViewCell: iCarouselDelegate, iCarouselDataSource {
    
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        
        return postImageData.count
        
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        let sliderView = Bundle.main.loadNibNamed("postSlider", owner: self, options: nil)?.first as! PostSlider
        
        sliderView.frame = self.postImage_Slider.frame
        
        
        
        //
        //
        //        sliderView.sliderImage.sd_setImage(with: URL(string: postImageUrl + String(describing: (self.postImageData[index])["attachment"]!)), placeholderImage: UIImage(named: ""))
        //
        //
        
        let fileUrl = String(describing: (self.postImageData[index])["attachment"]!).replacingOccurrences(of: " ", with: "%20")
        
        let url : URL = URL(string: postImageUrl + fileUrl)!
        
        if(String(describing: (self.postImageData[index])["attachment_type"]!) == "image"){
            
            sliderView.postSliderPlayVideo_btn.isHidden = true
            
            
            //            sliderView.postSlider_ImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            //            sliderView.postSlider_ImageView.translatesAutoresizingMaskIntoConstraints = true
            
            sliderView.postSlider_ImageView.contentMode = .scaleAspectFill
            
            sliderView.clipsToBounds = true
            //
            //            sliderView.postSlider_ImageView.clipsToBounds = true
            
            sliderView.postSlider_VideoView.isHidden = true
            
            sliderView.postSlider_ImageView.contentMode = .scaleAspectFit
            
            sliderView.postSlider_ImageView.clipsToBounds = true
            
            sliderView.postSlider_ImageView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            
            //sliderView.postSlider_ImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "noimage_icon"))
            
            sliderView.postSlider_ImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "noimage_icon"), options: .highPriority) {(image, error, type, url) in
                
                
                
                let ratio = (image?.size.width ?? 1.0 )/(image?.size.height ?? 1.0)
                
                //                print(ratio)
                //
                //                sliderView.postSlider_ImageView.image =  self.ResizeImage(image: image ?? UIImage(named: "noimage_icon")!, targetSize: CGSize(width:  self.postImage_Slider.frame.width , height:  self.postImage_Slider.frame.height))
                
                let image = image ?? UIImage(named: "noimage_icon")!
                
                let newImage = image.resize(withSize: CGSize(width: self.postImage_Slider.frame.width, height: 400), contentMode: .contentAspectFill)
                
                sliderView.postSlider_ImageView.image = newImage
                
            }
            
        }else if(String(describing: (self.postImageData[index])["attachment_type"]!) == "doc"){
            
            //                    self.imageView.isHidden = true
            //                    self.videoViewer.isHidden = true
            //                    webView.loadRequest(URLRequest(url: url))
            
        }else if(String(describing: (self.postImageData[index])["attachment_type"]!) == "video"){
            
            sliderView.postSliderPlayVideo_btn.isHidden = false
            
            sliderView.postSliderPlayVideo_btn.currentImage?.withRenderingMode(.alwaysTemplate)
            
            sliderView.postSliderPlayVideo_btn.imageView?.tintColor = UIColor.white
            
            sliderView.postSlider_ImageView.contentMode = .scaleAspectFill
            
            sliderView.clipsToBounds = true
            
            sliderView.postSliderPlayVideo_btn.tag = index
            
            sliderView.postSliderPlayVideo_btn.addTarget(self, action: #selector(tapPlayVideo_btn(_:)), for: .touchUpInside)
            
            sliderView.postSlider_VideoView.isHidden = true
            
            sliderView.postSlider_ImageView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            sliderView.postSlider_ImageView.sd_setImage(with: URL(string: postImageUrl + String(describing: (self.postImageData[index])["thumbnail"]!)), placeholderImage: UIImage(named: "noimage_icon"))
            
        }
        
        return sliderView
        
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        
        if(String(describing: (self.postImageData[index])["attachment_type"]!) == "image"){
            
            let vc = self.storyBoard.instantiateViewController(withIdentifier: "OpenFullImageViewController") as! OpenFullImageViewController
            
            
            
            // vc.controller = self
            
            vc.productImageUrl = postImageUrl +  String(describing: (self.postImageData[index])["attachment"]!)
            
            vc.condition = ""
            self.nav.presentedViewController?.definesPresentationContext = true
            self.nav.presentedViewController?.providesPresentationContextTransitionStyle = true
            
            self.nav.present(vc, animated: true, completion: nil)
            
        }else {
            
            let vc = self.storyBoard.instantiateViewController(withIdentifier: "OpenFullImageViewController") as! OpenFullImageViewController
            
            vc.condition = "video"
            
            vc.videoUrl = postImageUrl +  String(describing: (self.postImageData[index])["attachment"]!)
            
            self.nav.presentedViewController?.definesPresentationContext = true
            self.nav.presentedViewController?.providesPresentationContextTransitionStyle = true
            
            self.nav.present(vc, animated: true, completion: nil)
            
            
        }
        
        
    }
    
    func carouselDidScroll(_ carousel: iCarousel) {
        
        self.postCount_PageControl.currentPage = carousel.currentItemIndex
        
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        switch option {
        case .spacing:
            return 1.1
        default:
            return value
        }
        
    }
    
    // MARK: - Button ACtion
    
    @objc func tapPlayVideo_btn(_ sender: UIButton) {
        
        let vc = self.storyBoard.instantiateViewController(withIdentifier: "OpenFullImageViewController") as! OpenFullImageViewController
        
        vc.condition = "video"
        
        vc.videoUrl = postImageUrl +  String(describing: (self.postImageData[sender.tag])["attachment"]!)
        
        self.nav.presentedViewController?.definesPresentationContext = true
        self.nav.presentedViewController?.providesPresentationContextTransitionStyle = true
        
        self.nav.present(vc, animated: true, completion: nil)
        
    }
    
}



// MARK: - Collection View Delegate

extension SeePostsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.postImageData.count
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.seeAllPost_CollectionView.dequeueReusableCell(withReuseIdentifier: "SeePostCollectionViewCell", for: indexPath) as! SeePostCollectionViewCell
        
        cell.singlePostData = self.postImageData[indexPath.row]
        
        cell.tag = indexPath.row
        
        return cell
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if(String(describing: (self.postImageData[indexPath.row])["attachment_type"]!) == "image"){
            
            let vc = self.storyBoard.instantiateViewController(withIdentifier: "OpenFullImageViewController") as! OpenFullImageViewController
            
            
            
            // vc.controller = self
            
            vc.productImageUrl = postImageUrl +  String(describing: (self.postImageData[indexPath.row])["attachment"]!)
            
            vc.condition = ""
            self.nav.presentedViewController?.definesPresentationContext = true
            self.nav.presentedViewController?.providesPresentationContextTransitionStyle = true
            
            self.nav.present(vc, animated: true, completion: nil)
            
        }else {
            
            let vc = self.storyBoard.instantiateViewController(withIdentifier: "OpenFullImageViewController") as! OpenFullImageViewController
            
            vc.condition = "video"
            
            vc.videoUrl = postImageUrl +  String(describing: (self.postImageData[indexPath.row])["attachment"]!)
            
            self.nav.presentedViewController?.definesPresentationContext = true
            self.nav.presentedViewController?.providesPresentationContextTransitionStyle = true
            
            self.nav.present(vc, animated: true, completion: nil)
            
            
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width), height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        self.postCount_PageControl.currentPage = indexPath.row
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    // MARK: - Get Image Size
    
    
    
}



// MARK: - Image Extension
extension UIImage {
    enum ContentMode {
        case contentFill
        case contentAspectFill
        case contentAspectFit
    }
    
    func resize(withSize size: CGSize, contentMode: ContentMode = .contentAspectFill) -> UIImage? {
        let aspectWidth = size.width / self.size.width
        let aspectHeight = size.height / self.size.height
        
        switch contentMode {
        case .contentFill:
            return resize(withSize: size)
        case .contentAspectFit:
            let aspectRatio = min(aspectWidth, aspectHeight)
            return resize(withSize: CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio))
        case .contentAspectFill:
            let aspectRatio = max(aspectWidth, aspectHeight)
            return resize(withSize: CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio))
        }
    }
    
    private func resize(withSize size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    
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
