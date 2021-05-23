//
//  CommentsTableViewCell.swift
//  Unilife
//
//  Created by Apple on 28/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userProfile_ImageView: CircleImage!
    
    @IBOutlet weak var userName_lbl: UILabel!
    
    @IBOutlet weak var heart_btn: UIButton!
    
    @IBOutlet weak var userHasTagName_lbl: UILabel!
    
    @IBOutlet weak var commentDescription_lbl: UILabel!
    
    @IBOutlet weak var commentTime_lbl: UILabel!
    
    @IBOutlet weak var commentLike_lbl: UILabel!
    
    @IBOutlet weak var reply_btn: UIButton!
    
    @IBOutlet weak var replyComment_TableView: UITableView!
    
    @IBOutlet weak var replyCommentTableView_height: NSLayoutConstraint!
    
    @IBOutlet weak var viewAllPreviousReply_lbl: UILabel!
    
    @IBOutlet weak var viewAllPreviousReply_btn: UIButton!
    
    @IBOutlet weak var viewAllLike_btn: UIButton!
    
    
    
    // MARK: - Variable
    
    var replyCommentArray = [[String: AnyObject]]()
    
    var filterCommentArray = [[String: AnyObject]]()
    
    var commentId = ""
    
     var storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    var nav: UINavigationController!
    
    //    var dataArray =  [[String: AnyObject]]() {
    //
    //        didSet {
    //
    //            self.replyCommentArray = dataArray
    //
    //            print("data Array : - \(dataArray)")
    //        }
    //    }
    //
    //
    //    var comment_id: String = "" {
    //
    //        didSet {
    //
    //            self.commentId = comment_id
    //
    //            self.filterCommentArray = self.replyCommentArray.filter{String(describing: $0["comment_id"]!) == self.commentId}
    //
    //
    //            print(comment_id)
    //        }
    //    }
    //
    //    var cellIndex: Int = -1 {
    //
    //        didSet {
    //
    //    self.viewAllPreviousReply_btn.removeTarget(self, action: #selector(reply_btn(_:)), for: .touchUpInside)
    //
    //     self.viewAllPreviousReply_btn.tag = cellIndex
    //
    //     self.viewAllPreviousReply_btn.addTarget(self, action: #selector(reply_btn(_:)), for: .touchUpInside)
    //
    //            print("IndexPath : -\(cellIndex)")
    //        }
    //    }
    
    
    // MARK: - Default View
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print(self.filterCommentArray)
        
        self.replyComment_TableView.delegate = self
        
        self.replyComment_TableView.dataSource = self
        
        
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateReplyCommentTable(){
        var frame = self.replyComment_TableView.frame
        frame.size.height = self.replyComment_TableView.contentSize.height
        self.replyComment_TableView.frame = frame
        //   self.replyComment_TableView.reloadData()
        self.replyComment_TableView.layoutIfNeeded()
        self.replyCommentTableView_height.constant = CGFloat(self.replyComment_TableView.contentSize.height)
    }
    
    
    func viewData() {
        self.filterCommentArray = self.replyCommentArray.filter{String(describing: $0["comment_id"]!) == self.commentId}
        
        //   self.replyComment_TableView.reloadData()
        
    }
    
}


// MARK: - Table View Delegate

extension CommentsTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filterCommentArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.replyComment_TableView.dequeueReusableCell(withIdentifier: "ReplyCommentTableViewCell") as! ReplyCommentTableViewCell
        
        
        cell.replyComment_lbl.text! = String(describing: (filterCommentArray[indexPath.row])["reply"]!)
        
        cell.replyCommentUserName_lbl.text! = String(describing: ((self.filterCommentArray[indexPath.row])["reply_by_user"] as! [String: AnyObject])["username"]!)
        
        cell.replyCommentUserTag_lbl.text! = "@" + String(describing: ((self.filterCommentArray[indexPath.row])["reply_by_user"] as! [String: AnyObject])["username"]!)
        
        cell.replyCommentTime_lbl.text! = dateCalculator1(createdDate: String(describing: (self.filterCommentArray[indexPath.row])["created_at"]!))
        
        
        if String(describing: ((self.filterCommentArray[indexPath.row])["reply_by_user"] as! [String: AnyObject])["profile_image"]!) == "" {
            
            cell.replyCommentProfile_ImageView.image = UIImage(named: "noimage_icon")
            
            
        }else {
            
            cell.replyCommentProfile_ImageView.sd_setImage(with: URL(string: profileImageUrl + String(describing: ((self.filterCommentArray[indexPath.row])["reply_by_user"] as! [String: AnyObject])["profile_image"]!)), placeholderImage: UIImage(named: "noimage_icon"))
        }
        
        if ((filterCommentArray[indexPath.row])["user_reply_liked"] as! [[String: AnyObject]]).count == 0 {
            
            cell.heart_btn.setImage(UIImage(named: "hrt-30"), for: .normal)
            
            
        }else {
            
            cell.heart_btn.setImage(UIImage(named: "hrtRed_Icon"), for: .normal)
            
        }
        
        cell.replyCommentLike_lbl.text! = String(describing: ((filterCommentArray[indexPath.row])["reply_liked"] as! [[String: AnyObject]]).count) + " Likes"
        
        cell.heart_btn.tag = indexPath.row
        cell.heart_btn.addTarget(self, action: #selector(self.tapLike_btn(_:)), for: .touchDown)
        
        cell.viewAllReplyLike_btn.tag = indexPath.row
        
        cell.viewAllReplyLike_btn.addTarget(self, action: #selector(viewAllLike(_:)), for: .touchUpInside)
        
        cell.replyCommentReply_btn.tag = indexPath.row
        cell.replyCommentReply_btn.addTarget(self, action: #selector(reply_btn(_:)), for: .touchUpInside)
        
        return cell
        
    }
    
    // MARK: - Button Action
    
    @objc func tapLike_btn(_ sender: UIButton) {
        
        self.likeComment(user_id: UserData().userId, reply_id: String(describing: (self.filterCommentArray[sender.tag])["id"]!))
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    // MARK: - Button Action
    
    @objc func reply_btn(_ sender: UIButton) {
        
        let data = ["type": "ReplySubComment", "subCommentId": String(describing: (self.filterCommentArray[sender.tag])["comment_id"]!), "UserName": (((self.filterCommentArray[sender.tag])["reply_by_user"] as? [String: AnyObject])? ["username"] as? String ?? "")] as [String: Any]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "replySubComment"), object: nil, userInfo: ["data": data])
        
    }
   
    @objc func viewAllLike(_ sender: UIButton) {
        
        
        let vc = self.storyBoard.instantiateViewController(withIdentifier: "LikesViewController") as! LikesViewController
        
        vc.Id = String(describing: (self.filterCommentArray[sender.tag])["id"]!)
        
        vc.condition = "Reply"
        
        self.nav.pushViewController(vc, animated: true)
    }
    
}

extension CommentsTableViewCell {
    
    func likeComment(user_id: String, reply_id: String) {
        
        Indicator.shared.showProgressView(self.nav.view)
        
        let param = ["user_id": UserData().userId, "reply_id": reply_id]
        
        print(param)
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "like_unlike_reply", params: param as [String: AnyObject]) { (receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if  Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "replyComment"), object: nil, userInfo: nil)
                    
                }else {
                    
                    self.nav.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                }
                
            }else {
                
                self.nav.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
        }
        
    }
   
    // MARK: - Calculate Total days
    
    func dateCalculator1(createdDate : String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let now = Date()
        let create = dateFormatter.date(from: createdDate)
        if create != nil{
            let calendar = Calendar.current
            let createdComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: create!, to: now)
            var year = createdComponents.year!
            var month = createdComponents.month!
            var day = createdComponents.day!
            var hour = createdComponents.hour!
            var minutes = createdComponents.minute!
            var seconds = createdComponents.second!
            if(year ==  0){
                
                if(month == 0){
                    if (day == 0){
                        if(hour == 0){
                            if(minutes == 0){
                                return ("\(seconds) sec ago ")
                            }
                            else if (minutes == 1){
                                return ("\(minutes) min ago")
                            }
                            else{
                                return ("\(minutes) min ago")
                            }
                        }
                        else if(hour == 1){
                            return ("\(hour) hr ago ")
                        }
                        else{
                            return ("\(hour) hr ago")
                        }
                    }
                    else if (day == 1){
                        return ("\(day) day ago ")
                    }
                    else{
                        return ("\(day) days ago")
                    }
                }
                else if (month == 1){
                    return ("\(month) month-\(day) day ago")
                }
                else{
                    return ("\(month) months-\(day) days ago")
                }
            }
            else  if(year ==  1){
                return ("\(year) year-\(month) month-\(day) day ago")
            }
            else{
                return ("\(year) years-\(month) months-\(day) days ago")
            }
        }
            
        else{
            return ""
        }
        
    }
}




