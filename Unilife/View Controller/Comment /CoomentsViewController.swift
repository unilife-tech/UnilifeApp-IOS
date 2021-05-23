//
//  CoomentsViewController.swift
//  Unilife
//
//  Created by Apple on 28/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class CoomentsViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var commentListing_TableView: UITableView!
    
    @IBOutlet weak var comment_textView: GrowingTextView!
    
    @IBOutlet weak var comment_View: UIView!
    
    @IBOutlet weak var commentUserName_lbl: UILabel!
    
    @IBOutlet weak var commentUserTag_lbl: UILabel!
    
    @IBOutlet weak var commentUserprofile_Image: CircleImage!
    
    
    // MARK: - Variable
    
    var postId = ""
    
    var comment_id = ""
    
    var commentListArray = [[String: AnyObject]]()
    
    var condition = ""
    
    var buttonConditionTap = ""
    
    var replyTableHide : [Int] = [ ]
    
    var subReplyCommentId = ""
    
    var subReplyCommentCondition = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.commentUserName_lbl.text! = UserData().name
        self.commentUserTag_lbl.text! =  "@" + UserData().name
        
        if UserData().image == "" {
            
            self.commentUserprofile_Image.image = UIImage(named: "noimage_icon")
        }else {
            
            self.commentUserprofile_Image.sd_setImage(with: URL(string: profileImageUrl + UserData().image), placeholderImage: UIImage(named: "noimage_icon"))
            
        }
        
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "replyComment"), object: nil)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "replyComment"), object: nil, queue: nil) { (Notification) in
            self.condition = "reply"
            self.commentListing()
            
        }
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "replySubComment"), object: nil)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "replySubComment"), object: nil, queue: nil){ (Notification) in
            
            self.subReplyCommentId =  ((Notification.userInfo?["data"] as? [String: AnyObject])? ["subCommentId"] as? String ?? "")
            
            self.subReplyCommentCondition = ((Notification.userInfo?["data"] as? [String: AnyObject])? ["type"] as? String ?? "")
            
            self.comment_textView.text! = "@" +  ((Notification.userInfo?["data"] as? [String: AnyObject])? ["UserName"] as? String ?? "")
            
            
        }
        
        self.commentListing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Comments", titlePosition: .Middle, right: .Icon, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
        
        
    }
    
    deinit {
        print(#file)
    }
    
    // MARK: - Button Action
    
    
    
    @IBAction func addPost_btn(_ sender: Any) {
        
        if  self.buttonConditionTap == "Reply" {
            
            if self.comment_textView.text! == "" {
                
                self.showDefaultAlert(Message: "Please add comment")
                
            }else {
                
                self.replyToComment(user_id: UserData().userId, comment_id: self.comment_id, reply: self.comment_textView.text!)
            }
            
        }else if self.subReplyCommentCondition == "ReplySubComment"{
            
            if self.comment_textView.text! == "" {
                
                self.showDefaultAlert(Message: "Please add comment")
                
            }else {
                
                self.replyToComment(user_id: UserData().userId, comment_id: self.subReplyCommentId, reply: self.comment_textView.text!)
                
                
            }
            
        }else {
            
            if self.comment_textView.text! == "" {
                
                self.showDefaultAlert(Message: "Please add comment")
                
            }else {
                
                self.addComment()
            }
            
        }
    }
    
}

// MARK: - Table View Delegate And Data Source


extension CoomentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return commentListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.commentListing_TableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell") as! CommentsTableViewCell
        
        //        cell.commentDescription_lbl.attributedText = self.setAttributedLabelText(string_array: [ "when an unknown printer took a galley of type and scrambled it to make a type specimen book.", " It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. " , "It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum" ], color_array:  [ UIColor.appDarKGray, UIColor.appSkyBlue, UIColor.appDarKGray ] )
        
        cell.nav = self.navigationController
        
        cell.commentDescription_lbl.text! = String(describing: (commentListArray[indexPath.row])["comment"]!)
        
        cell.userName_lbl.text! = String(describing: ((self.commentListArray[indexPath.row])["comment_by_user"] as! [String: AnyObject])["username"]!)
        
        cell.userHasTagName_lbl.text! = "@" + String(describing: ((self.commentListArray[indexPath.row])["comment_by_user"] as! [String: AnyObject])["username"]!)
        
        cell.commentTime_lbl.text! = self.dateCalculator(createdDate: String(describing: (self.commentListArray[indexPath.row])["created_at"]!))
        
        
        if String(describing: ((self.commentListArray[indexPath.row])["comment_by_user"] as! [String: AnyObject])["profile_image"]!) == "" {
            
            cell.userProfile_ImageView.image = UIImage(named: "noimage_icon")
            
        }else {
            
            cell.userProfile_ImageView.sd_setImage(with: URL(string: profileImageUrl + String(describing: ((self.commentListArray[indexPath.row])["comment_by_user"] as! [String: AnyObject])["profile_image"]!)), placeholderImage: UIImage(named: "noimage_icon"))
        }
        
        if ((self.commentListArray[indexPath.row])["user_comment_liked"] as! [[String: AnyObject]]).count == 0 {
            
            cell.heart_btn.setImage(UIImage(named: "hrt-30"), for: .normal)
            
        }else {
            
            cell.heart_btn.setImage(UIImage(named: "hrtRed_Icon"), for: .normal)
            
        }
        
        //        cell.replyCommentArray = ((self.commentListArray[indexPath.row])["comment_reply"] as! [[String: AnyObject]])
        //
        //        cell.dataArray = ((self.commentListArray[indexPath.row])["comment_reply"] as! [[String: AnyObject]])
        
        //         cell.cellIndex = indexPath.row
        //
        //        cell.comment_id = String(describing: (self.commentListArray[indexPath.row])["id"]!)
        
        
        
        
        let filterCommentArray = ((self.commentListArray[indexPath.row])["comment_reply"] as! [[String: AnyObject]]).filter{String(describing: $0["comment_id"]!) == String(describing: (self.commentListArray[indexPath.row])["id"]!)}
        
        if filterCommentArray.count == 0 {
            
            // cell.replyCommentTableView_height.constant = 0
            
            cell.viewAllPreviousReply_lbl.isHidden = true
            cell.viewAllPreviousReply_btn.isHidden = true
            
        }else {
            
            //cell.replyCommentTableView_height.constant =
            
            cell.viewAllPreviousReply_lbl.isHidden = false
            cell.viewAllPreviousReply_btn.isHidden = false
            
        }
        
        cell.filterCommentArray = filterCommentArray
        
        cell.replyComment_TableView.reloadData()
        
        
        cell.commentLike_lbl.text! = String(((self.commentListArray[indexPath.row])["comment_liked"] as! [[String: AnyObject]]).count) + " Likes"
        
        cell.commentId = String(describing: (self.commentListArray[indexPath.row])["id"]!)
        
        cell.replyComment_TableView.reloadData()
        
        cell.heart_btn.tag = indexPath.row
        
        cell.heart_btn.addTarget(self, action: #selector(tapCommentLike_btn(_:)), for: .touchUpInside)
        
        cell.reply_btn.tag = indexPath.row
        cell.reply_btn.addTarget(self, action: #selector(tapCommentReply_btn(_:)), for: .touchUpInside)
        
        cell.viewAllPreviousReply_btn.tag = indexPath.row
        
        cell.viewAllPreviousReply_btn.addTarget(self, action: #selector(tapViewReply_btn(_:)), for: .touchUpInside)
        
        cell.viewAllLike_btn.tag = indexPath.row
        
        cell.viewAllLike_btn.addTarget(self, action: #selector(viewAllLike(_:)), for: .touchUpInside)
        
        if self.replyTableHide[indexPath.row] == 0 {
            
            cell.replyComment_TableView.isHidden = true
            
            cell.replyCommentTableView_height.constant = 0
            
        }else {
            
            cell.replyComment_TableView.isHidden = false
            
            
            var frame = cell.replyComment_TableView.frame
            frame.size.height = cell.replyComment_TableView.contentSize.height
            cell.replyComment_TableView.frame = frame
            //   self.replyComment_TableView.reloadData()
            cell.replyComment_TableView.layoutIfNeeded()
            cell.replyCommentTableView_height.constant = CGFloat(cell.replyComment_TableView.contentSize.height)
            
        }
        
        
        return cell
        
    }
    
    
    
    
    // MARK: - Button Action
    
    @objc func tapCommentLike_btn(_ sender: UIButton) {
        
        self.condition = "liked"
        
        self.likeComment(comment_id: String(describing: (self.commentListArray[sender.tag])["id"]!), user_id: UserData().userId)
    }
    
    @objc func tapCommentReply_btn(_ sender: UIButton) {
        
        //        self.commentListing_TableView.scrollToRow(at: IndexPath(item: (self.commentListArray.count - sender.tag), section: 0), at: .top, animated: true)
        self.buttonConditionTap = "Reply"
        
        self.comment_textView.text! = " @ " + String(describing: ((self.commentListArray[sender.tag])["comment_by_user"] as! [String: AnyObject])["username"]!)
        self.comment_id = String(describing: (self.commentListArray[sender.tag])["id"]!)
        
        self.commentListing_TableView.reloadData()
    }
    
    @objc func tapViewReply_btn(_ sender: UIButton) {
        
        //        self.comment_id = String(describing: (self.commentListArray[sender.tag])["id"]!)
        //
        //        self.commentListing_TableView.reloadData()
        
        
        if self.replyTableHide[sender.tag] == 0 {
            
            self.replyTableHide[sender.tag] = 1
            
        }else {
            
            self.replyTableHide[sender.tag] = 0
        }
        
        self.commentListing_TableView.reloadData()
        
    }
    
    
    @objc func viewAllLike(_ sender: UIButton) {
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LikesViewController") as! LikesViewController
        
        vc.Id = String(describing: (self.commentListArray[sender.tag])["id"]!)
        
        
        vc.condition = "Comment"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

// MARK: - Service Response
extension CoomentsViewController {
    
    // MARK: - Add Comment
    
    func addComment() {
        
        let param = ["user_id": UserData().userId, "post_id" : self.postId, "comment": self.comment_textView.text! ] as [String: AnyObject]
        
        print(param)
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "add_comment", params: param as [String: AnyObject]) {[weak self](receviedData) in
            
            print(receviedData)
            
            guard let self = self else {
                return
            }
            
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self.comment_textView.text! = ""
                    
                    
                    self.commentListing()
                    
                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
                
            }else {
                
                self.showDefaultAlert(Message: receviedData["Error"] as! String)
            }
            
        }
        
    }
    
    // MARK: - Comment Listing Response
    
    func commentListing(){
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId ,"post_id": self.postId] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "view_comments", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            
            // print(receviedData)
            
            guard let self = self else {
                return
            }
            
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    //self.replyTableHide.removeAll()
                    
                    self.commentListArray = receviedData["data"] as! [[String: AnyObject]]
                    
                    self.commentListing_TableView.delegate = self
                    
                    self.commentListing_TableView.dataSource = self
                    
                    self.commentListing_TableView.reloadData()
                    
                    //if (self.replyTableHide.isEmpty) {
                    
                    self.replyTableHide.removeAll()
                    
                    for _ in 0..<self.commentListArray.count {
                        
                        self.replyTableHide.append(0)
                        
                    }
                    
                    //}
                    
                    if self.condition == "liked" {
                        
                    }
                    else if self.condition == "reply" {
                        
                        
                    }
                    else {
                        
                        if self.commentListArray.count > 0 {
                            self.commentListing_TableView.scrollToRow(at: IndexPath(item: (self.commentListArray.count - 1), section: 0), at: .bottom, animated: true)
                            
                        }
                    }
                    
                    
                    
                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                }
                
                
            }else {
                
                
                self.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
            
        }
        
        
    }
    
    
    
    // MARK : - Like Comment
    func likeComment(comment_id: String, user_id: String) {
        
        //Indicator.shared.showProgressView(self.view)
        
        let param = ["comment_id": comment_id, "user_id": user_id] as [String: AnyObject]
        
        print(param)
        
        print(postId)
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "like_unlike_comment", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            
            print(receviedData)
            
            guard let self = self else {
                return
            }
            
            
            // Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self.commentListing()
                    
                    
                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
                
                
            }else {
                
                self.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
            
        }
        
    }
    
    
    // MARK: - Reply To Comment Service
    
    
    func replyToComment(user_id: String, comment_id: String, reply: String){
        
        let param = ["user_id": user_id, "comment_id": comment_id, "reply": reply] as [String: AnyObject]
        
        print(param)
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "reply_comment", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            
            print(receviedData)
            
            guard let self = self else {
                return
            }
            
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    if self.comment_textView.text.isEmpty {
                        
                    }
                    
                    self.comment_textView.text! = ""
                    
                    self.buttonConditionTap = ""
                    
                    self.commentListing()
                    
                    
                }else {
                    
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                    
                }
                
            }else {
                
                self.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
            
        }
        
        
    }
    
    
}

// MARK: - Scroll To Bottom

extension UITableView {
    
    func scrollToBottom(animated: Bool) {
        
        DispatchQueue.main.async {
            
            if self.contentSize.height > self.frame.height {
                
                // First figure out how many sections there are
                let lastSectionIndex = self.numberOfSections - 1
                
                // Then grab the number of rows in the last section
                let lastRowIndex = self.numberOfRows(inSection: lastSectionIndex) - 1
                
                // Now just construct the index path
                let pathToLastRow = NSIndexPath(row: lastRowIndex, section: lastSectionIndex)
                
                // Make the last row visible
                self.scrollToRow(at: pathToLastRow as IndexPath, at: UITableView.ScrollPosition.bottom, animated: false)
            }
        }
    }
}


