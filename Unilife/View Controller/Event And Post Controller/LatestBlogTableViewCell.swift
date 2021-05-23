//
//  LatestBlogTableViewCell.swift
//  Unilife
//
//  Created by Apple on 26/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class LatestBlogTableViewCell: UITableViewCell {
    
    @IBOutlet weak var blogViewAll_btn: SetButton!
    
    @IBOutlet weak var latestBlogsValue_lbl: UILabel!
    
    @IBOutlet weak var blogs_CollectionView: UICollectionView!
    
    @IBOutlet weak var show_View: UIView!
    
    @IBOutlet weak var latestBlogView_height: NSLayoutConstraint!
    
    @IBOutlet weak var point_ImageView: CircleImage!
    
    
    
    
    // MARK: - Variable

    var condition = "blogs"
    
    var blogsData : Blog?
    
    var offerData : [BrandOffer]?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.blogs_CollectionView.delegate = self
        
        self.blogs_CollectionView.dataSource = self
        
        self.blogs_CollectionView.register(UINib(nibName: "LatestBlogCollectionView", bundle: nil), forCellWithReuseIdentifier: "LatestBlogsCollectionViewCell")
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

extension LatestBlogTableViewCell:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if condition == "blogs" {
            
            if (self.blogsData?.categoriesBlog?.count ?? 0) > 6 {
                
              return 6
                
            }else {

            return self.blogsData?.categoriesBlog?.count ?? 0
                
            }

        }else {
            
            if (self.offerData?.count ?? 0 ) > 6 {
                
                return 6
                
            }else {
            
            return self.offerData?.count ?? 0
                
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.blogs_CollectionView.dequeueReusableCell(withReuseIdentifier: "LatestBlogsCollectionViewCell", for: indexPath) as! LatestBlogsCollectionViewCell
        
        
        if condition == "blogs" {
            
            
            cell.latestBlog_ImageView.sd_setImage(with: URL(string: blogImageUrl + (self.blogsData?.categoriesBlog?[indexPath.row].image ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
            
            cell.blogName_lbl.text = self.blogsData?.categoriesBlog?[indexPath.row].title ?? ""
            
       
        }else {
            
            cell.latestBlog_ImageView.sd_setImage(with: URL(string: offerImageUrl + (self.offerData?[indexPath.row].image ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
            
            
            cell.blogName_lbl.text = self.offerData?[indexPath.row].title ?? ""
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 140, height: 132)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if condition == "blogs" {
            
            let vc = self.viewContainingController()?.storyboard?.instantiateViewController(withIdentifier: "BlogDetailViewController") as! BlogDetailViewController
            
            vc.condition = "blogs"
            
            vc.blogsData = self.blogsData?.categoriesBlog![indexPath.row]
            
            self.viewContainingController()?.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            
            let vc = self.viewContainingController()?.storyboard?.instantiateViewController(withIdentifier: "RedeemCouponViewController") as! RedeemCouponViewController

            vc.condition = "offers"
            vc.offerData = self.offerData
            vc.indexToBeView = indexPath.row
            vc.offer_id = (self.offerData?[indexPath.row].id ?? 0)
            
            
            self.viewContainingController()?.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }

}


extension String {
    var html2Attributed: NSAttributedString? {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return nil
            }
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
}
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            
            //return NSAttributedString(string: "CHANGING")
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
