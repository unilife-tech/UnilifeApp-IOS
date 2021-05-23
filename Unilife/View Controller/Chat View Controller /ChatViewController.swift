//
//  ChatViewController.swift
//  Unilife
//
//  Created by Apple on 29/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit
import SocketIO
import IQKeyboardManagerSwift
import TOCropViewController
import AVFoundation
import MobileCoreServices
import Photos
import Alamofire


import AudioPlayerManager


class ChatViewController: UIViewController {
    
    // MARK: - outlet
    ////... this is for delete swipe background color from table
    var timerCellSwipeButtons: Timer?
    @IBOutlet weak var viwNoRecord: UIView!
    var isKeybordUpByTextField:Bool = false
    @IBOutlet weak var chat_TableView: UITableView!
    @IBOutlet weak var viwChatOuter: UIView!
    @IBOutlet weak var message_TextView: GrowingTextView!
    
    @IBOutlet weak var bottom_View: UIView!
    
    @IBOutlet weak var heightOfTextView: NSLayoutConstraint!
    
    @IBOutlet weak var recordButton: LongPressRecordButton!
    
    @IBOutlet weak var backGroundImage_View: UIImageView!
    
    @IBOutlet weak var replyTop_View: SetView!
    
    @IBOutlet weak var replyUserName_lbl: UILabel!
    
    @IBOutlet weak var replyMediaName_lbl: UILabel!
    
    @IBOutlet weak var replyMediaImage_View: UIImageView!
    @IBOutlet weak var replyViwInside: UIView!
    @IBOutlet weak var replyMediaWidth_height: NSLayoutConstraint!
    
    @IBOutlet weak var crossReplyView_btn: UIButton!
    
    
   // @IBOutlet weak var replyUserImage_View: CircleImage!
    
    @IBOutlet weak var timer_lbl: UILabel!
    
    @IBOutlet weak var timer_view: UIView!
    @IBOutlet weak var slidLockrecord_view: UIView!
    @IBOutlet weak var slidSendAudio_view: UIView!
    @IBOutlet weak var record_leftArrow: UIImageView!
    @IBOutlet weak var record_BlinkRecorder: UIImageView!
    @IBOutlet weak var record_leftLbl: UILabel!
    @IBOutlet weak var recordCancelbtn: UIButton!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var UserImage: UIImageView!
    
  //  @IBOutlet weak var imgBackgroundAUdio: UIImageView!
  //  @IBOutlet weak var viwPlayAudio: UIView!
   // @IBOutlet weak var lblAudioTim: UILabel!
    //@IBOutlet weak var plySlider: UISlider!
    
    @IBOutlet weak var btnSent: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    //
    //senderAudio_Slider
    
    // MARK: - Variable
    
    //var keyBoardSetting = KeyboardSettings(bottomType: .categories)
    var keyBoardHeight = 0.0
    
    let manger = SocketManager(socketURL: URL(string: "http://15.206.103.14:3007")!, config: [.log(true), .compress])
    var socket: SocketIOClient!
    var receiverId = ""
    var senderId = ""
    var rooomId = ""
    var isRoomJoined = false
    var chatList: [String: ChatModelElement] = [String: ChatModelElement]()
    var chatTupleList : [(key : String , value : ChatModelElement)] = []
    var cropStyle: TOCropViewCroppingStyle?
    var cropViewController = TOCropViewController()
    var image_picker = UIImagePickerController()
    var imageData: Data!
    var imageName = ""
    var filePath = ""
    //var Data: NSData?
    var isImageUploaded = false
    var condition = ""
    var videoUrl = ""
    var currentDate = ""
    var mediaType = ""
    var roomJoinTimer: Timer?
    var senderName = ""
    var senderProfileImage = ""
    var recorder = KAudioRecorder.shared
    var chatFile: UploadableChat?
    var backGroundImageCondition = ""
    var groupId = ""
    var recevierName = ""
    var chat_id = ""
    var newTimer = Timer()
    // Keeep Track of last payed ausio
    var lastPalyedAudio: LastPalyedAudio?
    var secs = 00
    let imgBGName = "unilifeBackgroundImage_fileDiractry.png"
    
    @IBOutlet weak var botoomSpaceContent:NSLayoutConstraint?
    
    
    // MARK: - Default View
    override func viewDidLoad() {               
        super.viewDidLoad()
        viwNoRecord.isHidden = true
        replyViwInside.layer.cornerRadius = 5
        Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(self.alarmAlertActivate), userInfo: nil, repeats: true)
        slidLockrecord_view.isHidden = true
        slidLockrecord_view.roundCornersvg(corners: [.topLeft,.topRight], radius: 38/2)
      
        slidSendAudio_view.isHidden = true
      
       // setupAudioPlayer_locally()
        viwChatOuter.layer.cornerRadius = 20
      
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
              let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
              let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
              if let dirPath          = paths.first
              {
                 let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(imgBGName)
                 let image    = UIImage(contentsOfFile: imageURL.path)
                 if(image != nil)
                 {
                      self.backGroundImage_View.image = image
                      
                  }else
                 {
                    self.backGroundImage_View.image = UIImage.init(named: "Chat_BG")
                    
                }
              }
        
        
        
        
        // self.chat_TableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        self.replyTop_View.isHidden = true
        
        self.message_TextView.layer.cornerRadius = 15
        
        
        self.message_TextView.delegate = self
        
        self.chat_TableView.rowHeight = UITableView.automaticDimension
        
        self.chat_TableView.estimatedRowHeight = 90
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        self.chat_TableView.addGestureRecognizer(tap)
        self.message_TextView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOntextView)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeMode"), object: nil)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "changeMode"), object: nil, queue: nil) { (Notification) in
            
            self.getChat()
            
        }
        
        // groupChatDeleted
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "groupChatDeleted"), object: nil)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "groupChatDeleted"), object: nil, queue: nil) { (Notification) in
               self.getChat()
        }
        
        self.socketHandling()
        self.setupAudioPlayer()
        self.setupRecording()
        self.getChat()
        self.joinRoom()
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        let btn = chat_TableView
//                  .allSubViews //get all the subviews
//                  .first(where: {String(describing:type(of: $0)) ==  "UISwipeActionStandardButton"}) // get the first one that is a UISwipeActionStandardButton
//
//        //This UISwipeActionStandardButton has two subviews, I'm getting the one that is not a UILabel, in your case, since you've set the image,  you should get the one that is not an imageView
//        if let view = btn?.subviews.first(where: { !($0 is UILabel)})
//        {
//            view.backgroundColor = .clear //Change the background color of the gray uiview
//        }
//
//        if let view2 = btn?.subviews.first(where: { !($0 is UIView)})
//        {
//                   view2.backgroundColor = .clear //Change the background color of the gray uiview
//        }
//    }
    
    @objc func alarmAlertActivate(){
        UIView.animate(withDuration: 0.7) {
            self.record_BlinkRecorder.alpha = self.record_BlinkRecorder.alpha == 1.0 ? 0.0 : 1.0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        viwNoRecord.isHidden = true
        //print(self.patientDetails)
        self.tabBarController?.tabBar.isHidden = true
        IQKeyboardManager.shared.enable = false
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //self.setupAudioPlayer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
        //self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
   }
    
    // MARK: - KeyBoard Open And Close  function
    
    @objc func keyBoardWillShow(notification:NSNotification){
        
        if let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue  {
            let keyboardHeight = keyboardSize.height
            //print(keyboardHeight)
            if self.keyBoardHeight == 0.0{
                self.keyBoardHeight = Double(keyboardHeight)
                
            }
            self.chat_TableView.contentInset =  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.chat_TableView.scrollToBottom(animated: true)
        }
        
    }
    
    @objc func keyBoardWillHide(){
        
        UIView.animate(withDuration: 0.2, animations: {
            // For some reason adding inset in keyboardWillShow is animated by itself but removing is not, that's why we have to use animateWithDuration here
            self.chat_TableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        })
        
        self.chat_TableView.scrollToBottom(animated: true)
    }
    
    @objc func tapOntextView(tap: UITapGestureRecognizer){
        self.message_TextView.inputView = nil
        self.message_TextView.resignFirstResponder()
        self.message_TextView.becomeFirstResponder()
    }
    
    @objc func hideKeyBoard(){
        
        view.endEditing(true)
        
    }
    
    func timeFormatChange(date : String) ->  String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let appointmentDate = date
        let dateString = dateFormatter.date(from: appointmentDate)
        dateFormatter.dateFormat = "hh:mm a"
        let dateStringToSet = dateFormatter.string(from: dateString!)
        
        return dateStringToSet
        
    }
    
    // MARK: - Add Navigation
    
    func addNavigation(titleText: String, imageName: String) -> UIView {
        
        let dots_btn = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        //        videoButton.layer.cornerRadius = 25/2
        //        videoButton.layer.borderWidth = 2
        dots_btn.layer.borderColor = UIColor.white.cgColor
        dots_btn.setImage(UIImage(named: "dots_icon"), for: .normal)
        
      //  dots_btn.addTarget(self, action: #selector(tapThreeDot_btn), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: dots_btn)]
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        
        backButton.layer.borderColor = UIColor.white.cgColor
        backButton.tintColor = UIColor.white
        
      //  backButton.addTarget(self, action: #selector(tapNavBackBtn), for: .touchUpInside)
        backButton.setImage(UIImage(named: "backWhite_icon"), for: .normal)
        //  backButton.tintColor = UIColor.black
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: backButton)]
        
        // Creates a new UIView
        let titleView = UIView(frame: CGRect(x: -30, y: 0, width:  self.navigationController?.navigationBar.frame.size.width ?? 200.0, height:  self.navigationController?.navigationBar.frame.size.height ?? 35.0))
        
        // Creates a new text label
        let label = UILabel()
        label.text = titleText
        label.sizeToFit()
        label.center = titleView.center
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        label.font = UIFont(name: "SoinSansNeue-Bold", size: 15)
        
        // Creates the image view
        
        // Sets the image frame so that it's immediately before the text:
        let imageX = label.frame.origin.x - label.frame.size.height
        let imageY = label.frame.origin.y
        
        let imageWidth = label.frame.size.height  / 2
        let imageHeight = imageWidth
        
        //image.frame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
        
        
        let selectImage_btn = UIButton(frame: CGRect(x: imageX - 15, y: imageY, width: 400, height: 30))
        
        let image = UIImageView(frame: CGRect(x: imageX - 15, y: imageY, width: 30, height: 30))
        
        image.sd_setImage(with: URL(string: imageName), placeholderImage: UIImage(named: "noimage_icon"))
        
        // Maintains the image's aspect ratio:
        image.clipsToBounds = true
        image.contentMode = .scaleToFill
        image.frame.size.height = image.frame.width
        image.layer.cornerRadius = image.frame.width/2
        label.center.x = titleView.center.x
        label.numberOfLines = 0
        selectImage_btn.layer.cornerRadius = selectImage_btn.frame.width / 2
        selectImage_btn.center.x = titleView.center.x
        
        //  selectImage_btn.backgroundColor = UIColor.black
        
        //selectImage_btn.setTitle("OO", for: .normal)
        
        //        selectImage_btn.setTitleColor(UIColor.black, for: .normal)
        //        if self.groupId == "" {
        //            selectImage_btn.addTarget(self, action: #selector(tapSelectImage_btn(_:)), for: .touchUpInside)
        //
        //        }else {
        //          selectImage_btn.addTarget(self, action: #selector(tapSelectImage_btn(_:)), for: .touchUpInside)
        //
        //        }
        
     //   selectImage_btn.addTarget(self, action: #selector(tapSelectImage_btn(_:)), for: .touchUpInside)
        
        //image.contentMode = UIView.ContentMode.scaleAspectFit
        
        // Adds both the label and image view to the titleView
        titleView.addSubview(label)
        titleView.addSubview(image)
        titleView.addSubview(selectImage_btn)
        
        
        // Sets the titleView frame to fit within the UINavigation Title
        titleView.sizeToFit()
        
        // return titleView
        
        self.navigationItem.titleView = titleView
        
        return titleView
    }
    
    // MARK: - Socket Handling
    
    func socketHandling() {
        
        socket = manger.defaultSocket
        
        socket.connect()
        
        socket.on(clientEvent: .connect) {data, ack in
            
            print(" -----------------   sockect Connected --------------")
            
        }
        
        self.socket.on("message"){ (dataArray , ack) -> Void in
            
            //  if (String(describing: (dataArray.first as! NSDictionary)["sender_id"]!) != UserData().userId) {
            
            let jsonData = try? JSONSerialization.data(withJSONObject: dataArray.first as! NSDictionary, options: .prettyPrinted)
            
            let chatModle = try? JSONDecoder().decode(Chat.self, from: jsonData!)
            
            let chatData
                : ChatModelElement = [chatModle!]
            
            let date = Date()
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd"
            
            var arrayaaa = [Chat]()
            
            //            if let lastPlyayedAudio = self.lastPalyedAudio {
            //                self.lastPalyedAudio?.indexPath = IndexPath(row: (lastPlyayedAudio.indexPath.row + 1), section: lastPlyayedAudio.indexPath.section)
            //
            //                //self.chatList.insert(welcome[i], at: 0)
            //
            //
            ////                self.chatList[formatter.string(from: date)]?.insert(chatData.first!, at: 0)
            ////
            ////                self.chat_TableView.insertRows(at: [IndexPath(row: lastPlyayedAudio.indexPath.row, section: 0)], with: .bottom)
            //
            //                if let arrayChat = self.chatList[formatter.string(from: date)] as? ChatModel {
            //
            //                    if arrayChat.count != 0 {
            //                        arrayaaa = arrayChat
            //                    }
            //
            //                }
            //
            //                arrayaaa.append(chatData.first!)
            //
            //                self.chatList.updateValue(arrayaaa , forKey: formatter.string(from: date))
            //
            //            }else {
            
            if let arrayChat = self.chatList[formatter.string(from: date)] as? ChatModelElement {
                
                if arrayChat.count != 0 {
                    self.viwNoRecord.isHidden = true
                    arrayaaa = arrayChat
                }
                
            }
            
            arrayaaa.append(chatData.first!)
            
            self.chatList.updateValue(arrayaaa , forKey: formatter.string(from: date))
            
            /* Tuples using */
            
            if self.chatTupleList.contains(where: {$0.key == formatter.string(from: date)}) {
                
                guard let index = self.chatTupleList.firstIndex(where: {$0.key == formatter.string(from: date)}) else { print("key not found"); return }
                
                var tempChatData = self.chatTupleList[index].value
                
                tempChatData.append(chatData.first!)
                
                self.chatTupleList[index] = (key : formatter.string(from: date) , value : tempChatData)
                
            } else {
                //jdo data nai haiga
                self.chatTupleList.append(((key: formatter.string(from: date), value: [chatData.first!])))
            }
            
            /* Tuples end */
            
            
            //}
            
            
                self.chat_TableView.reloadData()
            
            self.chat_TableView.scrollToBottom(animated: true)
            
            // }
            
        }
        
        
        self.socket.on("uploadFileMoreDataReq") { (dataArray, ack) -> Void in
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            dateFormatter.dateFormat = "hh:mm a"
            self.currentDate = dateFormatter.string(from: Date())
            
            print("Data Array :- \(dataArray), ack:- \(ack)")
            
            var messageDict = [[String: AnyObject]]()
            
            if self.groupId == "" {
                
                if self.condition == "No" {
                    
                    messageDict = [["Name": self.imageName,
                                    "Size": self.imageData.count,
                                    "Data": self.imageData.base64EncodedString(options: .endLineWithLineFeed),
                                    "sender_id": Int(self.senderId)!,
                                    "receiver_id": Int(self.receiverId)!,
                                    "message_type": self.mediaType ,
                                    "room_id": self.rooomId,
                                    "flag": "send",
                                    "thumb": (self.generateThumbnail1(path: NSURL(string: self.videoUrl)! as URL)!).base64EncodedString(options: .endLineWithLineFeed),
                                    "filepath": self.filePath,
                                    "message": "Read Attachment",
                                    "group_id": self.groupId,
                                    "device_type": "ios",
                                    "chat_id": self.chat_id
                        
                        ]] as [[String : AnyObject]]
                    
                    
                }else {
                    messageDict = [["Name": self.imageName,
                                    "Size": self.imageData.count,
                                    "Data": self.imageData.base64EncodedString(options: .endLineWithLineFeed),
                                    "sender_id": Int(self.senderId)!,
                                    "receiver_id": Int(self.receiverId)!,
                                    "message_type": self.mediaType ,
                                    "room_id": self.rooomId,
                                    "flag": "send",
                                    "thumb": "",
                                    "filepath": self.filePath,
                                    "message": "Read Attachment",
                                    "group_id": self.groupId,
                                    "device_type": "ios",
                                    "chat_id": self.chat_id
                        
                        ]] as [[String : AnyObject]]
                    
                    
                }
                
            }else {
                
                if self.condition == "No" {
                    
                    messageDict = [["Name": self.imageName,
                                    "Size": self.imageData.count,
                                    "Data": self.imageData.base64EncodedString(options: .endLineWithLineFeed),
                                    "sender_id": Int(self.senderId)!,
                                    "receiver_id": "",
                                    "message_type": self.mediaType ,
                                    "room_id": self.rooomId,
                                    "flag": "send",
                                    "thumb": (self.generateThumbnail1(path: NSURL(string: self.videoUrl)! as URL)!).base64EncodedString(options: .endLineWithLineFeed),
                                    "filepath": self.filePath,
                                    "message": "Read Attachment",
                                    "group_id": self.groupId,
                                    "device_type": "ios",
                                    "chat_id": self.chat_id
                        
                        ]] as [[String : AnyObject]]
                    
                    
                }else {
                    messageDict = [["Name": self.imageName,
                                    "Size": self.imageData.count,
                                    "Data": self.imageData.base64EncodedString(options: .endLineWithLineFeed),
                                    "sender_id": Int(self.senderId)!,
                                    "receiver_id": "",
                                    "message_type": self.mediaType ,
                                    "room_id": self.rooomId,
                                    "flag": "send",
                                    "thumb": "",
                                    "filepath": self.filePath,
                                    "message": "Read Attachment",
                                    "group_id": self.groupId,
                                    "device_type": "ios",
                                    "chat_id": self.chat_id
                        
                        
                        ]] as [[String : AnyObject]]
                    
                    
                }
                
            }
            
            //            let predicateFormat = NSPredicate(format: "Name = %@",self.imageName)
            //
            ////            let chatData
            ////                : ChatModel = [chatModle!]
            //
            //            let date = Date()
            //
            //            let formatter = DateFormatter()
            //
            //            formatter.dateFormat = "yyyy-MM-dd"
            //
            //            var result = formatter.string(from: date)
            //
            //            let jsonData = try? JSONSerialization.data(withJSONObject: messageDict[0] as NSDictionary, options: .prettyPrinted)
            //
            //            let chatModle = try? JSONDecoder().decode(ChatModelElement.self, from: jsonData!)
            //
            //            let dataa = self.chatList[result]?.filter({$0.message == self.imageName ? true : false})
            //
            //            if dataa?.count == 0 {
            //                //hani
            //            } else {
            //                //haigi hai
            //            }
            
            self.message_TextView.text! = ""
            
            self.chat_TableView.scrollToBottom(animated: true)
            
            self.socket.emitWithAck("uploadFileChuncks", messageDict).timingOut(after: 0) {data in
                
            }
            
            self.chat_id = ""
            
            self.chat_TableView.reloadData()
            
        }
        
        self.socket.on("uploadFileCompleteRes") { ( dataArray, ack) -> Void in
            
            //print("Data Array :- \(dataArray), ack:- \(ack)")
            
            if String(describing: (dataArray[0] as! NSDictionary)["IsSuccess"]!) == "1"{
                
                //                    // (dataArray[0] as! NSDictionary)["update"] as! NSDictionary
                //
                //                    let jsonData = try? JSONSerialization.data(withJSONObject: (dataArray[0] as! NSDictionary)["update"] as! NSDictionary, options: .prettyPrinted)
                //
                //                    let chatModle = try? JSONDecoder().decode(ChatModelElement.self, from: jsonData!)
                //
                //                    let chatData
                //                        : ChatModel = [chatModle!]
                //
                //                    let date = Date()
                //
                //                    let formatter = DateFormatter()
                //
                //                    formatter.dateFormat = "yyyy-MM-dd"
                //
                //                    var arrayaaa = [ChatModelElement]()
                //
                //                    if let arrayChat = self.chatList[formatter.string(from: date)] as? ChatModel {
                //
                //                        if arrayChat.count != 0 {
                //                            arrayaaa = arrayChat
                //                        }
                //
                //                    }
                //
                //                    arrayaaa.append(chatData.first!)
                //
                //                    self.chatList.updateValue(arrayaaa , forKey: formatter.string(from: date))
                //                    self.chat_TableView.scrollToBottom(animated: true)
            }
            
            self.chat_TableView.reloadData()
            
        }
        
    }
    
    func joinRoom() {
        
        self.roomJoinTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (_) in
            
            if(self.roomJoinTimer != nil){
                
                self.socket.emit("room join", with: [["room_id": self.rooomId,"sender_id": self.senderId,"receiver_id": self.receiverId] as Any])
                
                self.socket.on("room join", callback: { (_ , _) in
                    
                    print(" -----------------   room Joined --------------")
                    
                    self.roomJoinTimer?.invalidate()
                    self.roomJoinTimer = nil
                    self.isRoomJoined = true
                    
                })
                
            }
            
        })
        
    }
    
    // MARK: - Check File Extension
    
    
    func checkFileExtension(index : Int, indexSection:Int) -> String{
        
        
        if let  file = self.chatTupleList[indexSection].value[index].message {
            
            
            if let fileExtension = NSURL(fileURLWithPath: file).pathExtension{
                
                //print(fileExtension)
                
                if(fileExtension == "jpg" || fileExtension == "png" || fileExtension == "jpeg"){
                    
                    return "img"
                    
                }else if(fileExtension == "pdf"){
                    
                    return "doc"
                    
                }else if(fileExtension == "mp4"){
                    
                    return "vid"
                    
                }else if(fileExtension == "m4a") || ((fileExtension == "mp3")){
                    
                    return "aud"
                    
                }else if (fileExtension == "gif"){
                    
                    return "gif"
                }
                
            }
            
        }
        
        return ""
    }
    
    func checkFileExtensionWithName(file : String) -> String{
        
        if let fileExtension = NSURL(fileURLWithPath: file).pathExtension{
            
            
            
            if(fileExtension == "jpg" || fileExtension == "png" || fileExtension == "jpeg"){
                
                return "img"
                
            }else if(fileExtension == "pdf"){
                
                return "doc"
                
            }else if(fileExtension == "mp4"){
                
                return "vid"
                
            }else if(fileExtension == "m4a"){
                
                return "aud"
                
            }else if (fileExtension == "gif"){
                
                return "gif"
            }
            
        }
        
        return ""
    }
    
    
    @objc func tapViewFile_btn(_ sender: UIButton){
        
        let file = self.checkFileExtension(index: sender.tag, indexSection: Int(sender.accessibilityHint!)!)
        
        if (file != "") {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatFilePickerViewController") as! ChatFilePickerViewController
            
            if(file == "img"){
                
                vc.fileType = "img"
                
            }else if(file == "doc"){
                
                vc.fileType = "doc"
                
            }else if(file == "vid"){
                
                vc.fileType = "vid"
                
            }
            
            vc.filePath =   ((self.chatTupleList[Int(sender.accessibilityHint!)!].value[sender.tag].message ?? ""))
            
            //            self.navigationController?.present(vc, animated: true, completion: nil)
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
    }
    
    // MARK: - Button Action
    ////... click on back button
    @IBAction func tapNavBackBtn(_ sender: UIButton) {
        
        self.socket.emit("room leave",["room_id":self.rooomId, "sender_id": self.senderId])
        
        self.navigationController?.popViewController(animated: true)
    }
    //.... click on image and name
    @IBAction func tapSelectImage_btn(_ sender: UIButton){
        
        self.view.endEditing(true)
        
        if self.groupId != "" {
            /*
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupInfoViewController") as! GroupInfoViewController
            vc.room_id = self.rooomId
            vc.group_id = self.groupId
            self.navigationController?.pushViewController(vc, animated: true)
            */
            let vc = kPhase2toryBoard.instantiateViewController(withIdentifier: "GroupDetailVC") as! GroupDetailVC
            vc.getUserImg = self.UserImage.image
            vc.getName = self.lblName.text ?? ""
            vc.group_id = self.groupId
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }else {
            
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SingleUserChatInfoViewController") as! SingleUserChatInfoViewController
//
//            vc.userImage = self.senderProfileImage
//            vc.userName = self.senderName
//
//            self.navigationController?.pushViewController(vc, animated: true)
            
            
            let vc = kPhase2toryBoard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            vc.getUserID =  Int(self.receiverId) ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    ///.. click Three dots
    @IBAction func tapThreeDot_btn(_ sender: UIButton) {
        
        let vc = kPhase2toryBoard.instantiateViewController(withIdentifier: "ContactInfoVC") as! ContactInfoVC
        vc.getUserImg = self.UserImage.image
        vc.getName = self.lblName.text ?? ""
        vc.receiverId = self.receiverId
        vc.groupId = self.groupId
        /////.... This is new 
        vc.room_id = self.rooomId
        vc.group_id = self.groupId
        self.navigationController?.pushViewController(vc, animated: true)
        return
        
        
        guard let popoverContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestReceviedPopUpViewController") as? RequestReceviedPopUpViewController else {return}
        
        if self.groupId != "" {
            
            popoverContent.conditionChatController = "ChatGroupController"
            popoverContent.groupId = self.groupId
        }else {
            
            popoverContent.conditionChatController = "ChatController"
            
        }
        
        popoverContent.controller = self
        
        popoverContent.blockId = self.receiverId
        
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
        
        popoverContent.preferredContentSize = CGSize(width: 200, height: 100)
        
        let popOver = popoverContent.popoverPresentationController
        
        popOver?.delegate = self
        //
        popOver?.sourceView = sender as! UIButton
            //self.navigationItem.rightBarButtonItem?.customView  as! UIView
        //
        popOver?.sourceRect = (sender as! UIButton).bounds
        //    (self.navigationItem.rightBarButtonItem?.customView  as AnyObject).bounds
        //
        popOver?.permittedArrowDirections = [.up, .right]
        
        self.present(popoverContent, animated: true, completion: nil)
    }
    
    
    
    @IBAction func tapSend_btn(_ sender: Any) {
        
        if self.message_TextView.text!.replacingOccurrences(of: " ", with: "") == "" {
            
            self.showToast(message: "Type your text")
        }else {
            
            
            
            
            ///.... this code for stop keboard dismiss
                   self.isKeybordUpByTextField = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                              self.isKeybordUpByTextField = false
                          }
            
            let text = self.message_TextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if text != "" {
                var sendText:String = text
                if(text.containsEmoji)
                {
                    let escapedString = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                   
                    sendText = escapedString ?? ""
                }
                
                
                self.mediaType = "text"
                
                let messageDict = ["message": sendText,"sender_id":self.senderId,"receiver_id": self.receiverId, "group_id": self.groupId,
                                   "chat_id": self.chat_id]
                
                    
                self.message_TextView.text! = ""
                self.socket.emitWithAck("message", messageDict).timingOut(after: 0){ data in
                    
                }
                
                self.chat_id = ""
                self.replyTop_View.isHidden = true
                
            }
            
        }
        
    }
    
    
    @IBAction func tapOpenCamera_btn(_ sender: Any) {
        
        self.view.endEditing(true)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            camera()
            
        }
    }
    
    
    
    @IBAction func tapAttachment_btn(_ sender: Any) {
        self.view.endEditing(true)
        self.showAttachFileOption()
    }
    
    
    
    @IBAction func tapCross_btn(_ sender: Any) {
        self.chat_id = ""
        self.replyTop_View.isHidden = true
    }
    
    
    @IBAction func clickPlayAudio_beforSend()
     {
        
         if let url = self.recorder.url {
           AudioPlayerManager.shared.play(urlString: self.recorder.url?.absoluteString ?? "")
        }
     }
    
    
 
    
  
    
    /*
    func setupAudioPlayer_locally() {
        
        // Listen to the player state updates. This state is updated if the play, pause or queue state changed.
        AudioPlayerManager.shared.addPlayStateChangeCallback(self, callback: { [weak self] (track: AudioTrack?) in
            
            self?.upadteButtonState()
            
        })
        // Listen to the playback time changed. Thirs event occurs every `AudioPlayerManager.PlayingTimeRefreshRate` seconds.
        AudioPlayerManager.shared.addPlaybackTimeChangeCallback(self, callback: { [weak self] (track: AudioTrack?) in
            
            self?.updatePlaybackTime_locally(track)
        })
        
    }
    
    
    func updatePlaybackTime_locally(_ track: AudioTrack?) {
            DispatchQueue.main.async {
                
                self.lblAudioTim.text = track?.displayableTimeLeftString()
                    //track?.displayableDurationString() ?? "-:-"
                self.plySlider.value = track?.currentProgress() ?? 0
            }
    }
    
    */
    
    
    @IBAction func click_Video_calling(sender:UIButton)
    {
//        let VC = kPhase2toryBoard.instantiateViewController(withIdentifier: "CommingSoon") as! CommingSoon
//        self.navigationController?.pushViewController(VC, animated: true)
        
        guard let popoverContent = kPhase2toryBoard.instantiateViewController(withIdentifier: "CommingSoon") as? CommingSoon else {return}
              
              popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
                popoverContent.preferredContentSize = CGSize(width: 200, height: 40)
              let popOver = popoverContent.popoverPresentationController
              
              popOver?.delegate = self
              //
              popOver?.sourceView = sender
              //
              
              // popOver?.sourceView = sender
              popOver?.sourceRect = sender.bounds
              //
              popOver?.permittedArrowDirections = [.up]
              popOver?.backgroundColor = UIColor(red: 106/255, green: 162/255, blue: 185/255, alpha: 1.0)
              
              self.present(popoverContent, animated: true, completion: nil)
        
    }
    
    
     @IBAction func click_Extra_Bottom_buttons(sender:UIButton)
        {
    //        let VC = kPhase2toryBoard.instantiateViewController(withIdentifier: "CommingSoon") as! CommingSoon
    //        self.navigationController?.pushViewController(VC, animated: true)
            
            guard let popoverContent = kPhase2toryBoard.instantiateViewController(withIdentifier: "CommingSoon") as? CommingSoon else {return}
                  
                  popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
            if(sender.tag == 1) || (sender.tag == 5)
            {
                popoverContent.preferredContentSize = CGSize(width: 100, height: 40)
            }else
            {
                popoverContent.preferredContentSize = CGSize(width: 200, height: 40)
            }
                  let popOver = popoverContent.popoverPresentationController
                  
                  popOver?.delegate = self
                  //
                  popOver?.sourceView = sender
                  //
                  
                  // popOver?.sourceView = sender
                  popOver?.sourceRect = sender.bounds
                  //
                  popOver?.permittedArrowDirections = [.down]
                 popOver?.backgroundColor = UIColor(red: 106/255, green: 162/255, blue: 185/255, alpha: 1.0)
                  self.present(popoverContent, animated: true, completion: nil)
            
        }
    
}

extension ChatViewController:UIScrollViewDelegate
{
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.tag == 1000)
        {
            if(self.isKeybordUpByTextField == false)
            {
              //self.view.endEditing(true)
                self.message_TextView.resignFirstResponder()
                
                self.chat_id = ""
                self.replyTop_View.isHidden = true
            }
      
        }
    }
    /*
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(scrollView.tag == 1000)
        {
            print("Yesss---")
            //self.view.endEditing(true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.view.endEditing(true)
                print("--ooooo")
                /*
                if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0) {
                    //print("up")
                    self.view.endEditing(true)
                }
                else {
                    //print("down")
                    self.view.endEditing(true)
                }
                */
            }
        }
    }
    */

}

// MARK: - Table View Delegate

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.chatTupleList.count
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 60))
        // view.transform = CGAffineTransform(scaleX: -1, y: 1)
        
        //            let questionImage = UIImageView(frame: CGRect(x: 10, y: 0, width: 30, height: 30))
        
        let sectionname = UILabel(frame: CGRect(x:  0, y: 0, width: (tableView.frame.size.width), height: 40))
        sectionname.numberOfLines = 0
        
        sectionname.text =  self.chatTupleList[section].key
        
        sectionname.font = UIFont(name: "Arcon-Regular", size: 15)
        
        if  self.backGroundImageCondition == "black" {
            
            sectionname.backgroundColor = UIColor.clear
            sectionname.textColor = UIColor.white
            
        }else {
            sectionname.backgroundColor = UIColor.clear
            sectionname.textColor = UIColor.appDarKGray
        }
        
        
        sectionname.textAlignment = .center
        
        view.addSubview(sectionname)
        
        
        self.view.addSubview(view)
        
        return view
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.chatTupleList.count == 0)
        {
            //... this is group data
            //self.viwNoRecord.isHidden = false
           
        }else
        {
            self.viwNoRecord.isHidden = true
        }
        return self.chatTupleList[section].value.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.chat_TableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell2") as! ChatTableViewCell
        
        // self.self.chatTupleList[indexPath.section].value[indexPath.row].
        
        
        
        if (self.chatTupleList[indexPath.section].value[indexPath.row].senderID ?? -91) ==  Int(UserData().userId) {
            
            if let type = (self.chatTupleList[indexPath.section].value[indexPath.row].messageType) {
                
                if type == "text" {
                    
                    let cell = self.chat_TableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell2") as! ChatTableViewCell
                    
                    cell.userName_lbl.text! = UserData().name
                    
                    
                   // imgUserProfile.sd_setImage(with: URL(string: profileImageUrl + UserData().image), placeholderImage: UIImage(named: "noimage_icon"))
                    //       self.lblname.text = UserData().name
                    
                    let getMessage:String = self.chatTupleList[indexPath.section].value[indexPath.row].message ?? ""
                    cell.sendMessageUser_lbl.text! = getMessage.removingPercentEncoding ?? ""
                    cell.sendMessageUserImage_View.sd_setImage(with: URL(string:  profileImageUrl + UserData().image), placeholderImage: UIImage(named: "noimage_icon"))
                    
                   
                    
                    
                    cell.sendMessageTime_lbl.text! = timeFormatChange(date: self.chatTupleList[indexPath.section].value[indexPath.row].createdAt ?? "")
                    /*
                    if  self.backGroundImageCondition == "black" {
                        cell.sendMessageTime_lbl.tintColor = UIColor.white
                        cell.sendMessageTime_lbl.textColor = UIColor.white
                        print("*************" + self.backGroundImageCondition)
                        
                        
                    }else if self.backGroundImageCondition == "white"  {
                        
                        cell.sendMessageTime_lbl.textColor = UIColor.appDarKGray
                    }else {
                        cell.sendMessageTime_lbl.textColor = UIColor.appDarKGray
                        
                    }
                    
                    */
                    cell.replyImage_View.isHidden = true
                    if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide == nil {
                        
                       // print("Chat slider nil-->",indexPath.row)
                        
                        cell.reply_View.isHidden = true
                        
                 //       cell.replyView_height.constant = 0
                        
                    }else {
                      //  print("Chat slider NOT ****>",indexPath.row)
                        cell.reply_View.isHidden = false
                        
                 //       cell.replyView_height.constant = 40
                        
                        cell.replyImageView_width.constant = 32
                        cell.replyImage_View.isHidden = false
                        
                        if (self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "") == "image"{
                            
                            
                            cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                            
                            cell.reply_lbl.text = "Image"
                            
                            
                        }else if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "video"{
                            
                            cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.thumb ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                            
                            cell.reply_lbl.text = "Video"
                            
                            
                        } else if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "gif"{
                            
                            cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                            
                            cell.reply_lbl.text = "Gif"
                            
                        }else if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "text"{
                            
                            cell.replyImageView_width.constant = 0
                            cell.replyImage_View.isHidden = true
                            let getMessage:String = self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? ""
                            cell.reply_lbl.text = getMessage.removingPercentEncoding ?? ""
                            
                        }else if (self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "") == "audio" {
                            
                            cell.replyImage_View.image = UIImage(named: "microphone_White")
                            
                            cell.reply_lbl.text = "Audio Message"
                        }
                        
                    }
                    
                    return cell
                    
                }else {
                    
                    let file = checkFileExtension(index: indexPath.row, indexSection: indexPath.section)
                    
                    if file != "" {
                        
                        let cell = self.chat_TableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell3") as! ChatTableViewCell
                        cell.imgVideoBackground?.isHidden = true
                        if (file == "img"){
                            
                            cell.userName_lbl.text! = UserData().name
                            cell.sendUserImage_View.sd_setImage(with: URL(string: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                            
                            cell.sendMessageTime_lbl.text! = timeFormatChange(date: self.chatTupleList[indexPath.section].value[indexPath.row].createdAt ?? "")
                            
                            cell.sendMessageUserImage_View.sd_setImage(with: URL(string:  profileImageUrl + UserData().image), placeholderImage: UIImage(named: "noimage_icon"))
                            
                            if  self.backGroundImageCondition == "black" {
                                cell.sendMessageTime_lbl.tintColor = UIColor.white
                                cell.sendMessageTime_lbl.textColor = UIColor.white
                                
                                
                                
                            }else if self.backGroundImageCondition == "white"  {
                                
                                cell.sendMessageTime_lbl.textColor = UIColor.appDarKGray
                            }else {
                                cell.sendMessageTime_lbl.textColor = UIColor.appDarKGray
                                
                            }
                            
                            if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide == nil {
                                
                                cell.reply_View.isHidden = true
                                
                                cell.replyView_height.constant = 0
                                
                            }else {
                                
                                cell.reply_View.isHidden = false
                                
                                cell.replyView_height.constant = 40
                                
                                if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "image"{
                                    
                                    
                                    cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                    
                                    cell.reply_lbl.text = "Image"
                                    
                                    
                                }else if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "video"{
                                    
                                    cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.thumb ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                    
                                    cell.reply_lbl.text = "Video"
                                    
                                    
                                } else if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "gif"{
                                    
                                    cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                    
                                    cell.reply_lbl.text = "Gif"
                                    
                                }else if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "text"{
                                    
                                    cell.replyImageView_width.constant = 0
                                    
                                    cell.reply_lbl.text = self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? ""
                                    
                                }else if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "audio" {
                                    
                                    cell.replyImage_View.image = UIImage(named: "microphone_White")
                                    cell.reply_lbl.text! = "Voice Message"
                                    
                                }
                                
                            }
                            
                        }else if (file == "vid") {
                            cell.imgVideoBackground?.isHidden = false
                            cell.userName_lbl.text! = UserData().name
                            cell.sendUserImage_View.sd_setImage(with: URL(string: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].thumb ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                            
                            cell.sendMessageTime_lbl.text! = timeFormatChange(date: self.chatTupleList[indexPath.section].value[indexPath.row].createdAt ?? "")
                            
                            cell.sendMessageUserImage_View.sd_setImage(with: URL(string:  profileImageUrl + UserData().image), placeholderImage: UIImage(named: "noimage_icon"))
                            
                            if  self.backGroundImageCondition == "black" {
                                cell.sendMessageTime_lbl.tintColor = UIColor.white
                                cell.sendMessageTime_lbl.textColor = UIColor.white
                                
                                
                                
                            }else if self.backGroundImageCondition == "white"  {
                                
                                cell.sendMessageTime_lbl.textColor = UIColor.appDarKGray
                            }else {
                                cell.sendMessageTime_lbl.textColor = UIColor.appDarKGray
                                
                            }
                            
                            if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide == nil {
                                
                                cell.reply_View.isHidden = true
                                
                                cell.replyView_height.constant = 0
                                
                            }else {
                                
                                cell.reply_View.isHidden = false
                                
                                cell.replyView_height.constant = 40
                                
                                if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "image"{
                                    
                                    
                                    cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                    
                                    cell.reply_lbl.text = "Image"
                                    
                                    
                                }else if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "video"{
                                    
                                    cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.thumb ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                    
                                    cell.reply_lbl.text = "Video"
                                    
                                    
                                } else if (self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "") == "gif"{
                                    
                                    cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                    
                                    cell.reply_lbl.text = "Gif"
                                    
                                }else if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "text"{
                                    
                                    cell.replyImageView_width.constant = 0
                                    
                                    cell.reply_lbl.text = self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? ""
                                    
                                }else if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "audio" {
                                    
                                    cell.replyImage_View.image = UIImage(named: "microphone_White")
                                    
                                    cell.reply_lbl.text = "Voice Message"
                                }
                                
                            }
                            
                        }else if file == "aud" {
                            
                            
                            
                            let cell =  self.chat_TableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell5") as! ChatTableViewCell
                            
                            cell.userName_lbl.text! = UserData().name
                            
                            cell.chatListElement = self.chatTupleList[indexPath.section].value[indexPath.row]
                            
                            cell.delegate = self
                            
                            cell.cellType = "sender"
                            
                            cell.sendMessageUserImage_View.sd_setImage(with: URL(string:  profileImageUrl + UserData().image), placeholderImage: UIImage(named: "noimage_icon"))
                            
                            if  self.backGroundImageCondition == "black" {
                                
                                cell.sendMessageTime_lbl.textColor = UIColor.white
                                
                                cell.senderAudioTime_lbl.textColor = UIColor.appDarKGray
                                
                            }else if self.backGroundImageCondition == "white" {
                                
                                cell.sendMessageTime_lbl.textColor = UIColor.appDarKGray
                                
                                cell.senderAudioTime_lbl.textColor = UIColor.appDarKGray
                            }else {
                                
                                cell.sendMessageTime_lbl.textColor = UIColor.appDarKGray
                                
                                cell.senderAudioTime_lbl.textColor = UIColor.white
                            }
                            
                            
                            if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide == nil {
                                
                                cell.reply_View.isHidden = false
                                
                                cell.replyView_height.constant = 0
                                
                            }else {
                                
                                cell.reply_View.isHidden = false
                                
                                cell.replyView_height.constant = 0
                                
                                if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "image"{
                                    
                                    
                                    cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                    
                                    cell.reply_lbl.text = "Image"
                                    
                                    
                                }else if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "video"{
                                    
                                    cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.thumb ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                    
                                    cell.reply_lbl.text = "Video"
                                    
                                    
                                } else if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "gif"{
                                    
                                    cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                    
                                    cell.reply_lbl.text = "Gif"
                                    
                                }else if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "text"{
                                    
                                    cell.replyImageView_width.constant = 0
                                    
                                    cell.reply_lbl.text = self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? ""
                                    
                                }else if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "audio" {
                                    
                                    cell.replyImage_View.image = UIImage(named: "microphone_White")
                                    
                                    cell.reply_lbl.text = "Voice Message"
                                }
                                
                            }
                            
                            return cell
                            
                        }else if(file == "doc"){
                            
                            
                            cell.userName_lbl.text! = UserData().name
                            
                            cell.sendUserImage_View.image = UIImage(named: "pdf_icon")
                            
                            cell.sendMessageTime_lbl.text! = timeFormatChange(date: self.chatTupleList[indexPath.section].value[indexPath.row].createdAt ?? "")
                            
                            cell.sendMessageUserImage_View.sd_setImage(with: URL(string:  profileImageUrl + UserData().image), placeholderImage: UIImage(named: "noimage_icon"))
                            
                            if  self.backGroundImageCondition == "black" {
                                cell.sendMessageTime_lbl.tintColor = UIColor.white
                                cell.sendMessageTime_lbl.textColor = UIColor.white
                                
                                
                                
                            }else if self.backGroundImageCondition == "white"  {
                                
                                cell.sendMessageTime_lbl.textColor = UIColor.appDarKGray
                                
                                
                            }else {
                                cell.sendMessageTime_lbl.textColor = UIColor.appDarKGray
                                
                            }
                            
                            
                            if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide == nil {
                                
                                cell.reply_View.isHidden = false
                                
                                cell.replyView_height.constant = 0
                                
                            }else {
                                
                                cell.reply_View.isHidden = false
                                
                                cell.replyView_height.constant = 40
                                
                                if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "image"{
                                    
                                    
                                    cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                    
                                    cell.reply_lbl.text = "Image"
                                    
                                    
                                }else if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "video"{
                                    
                                    cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.thumb ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                    
                                    cell.reply_lbl.text =  "Video"
                                    
                                    
                                } else if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "gif"{
                                    
                                    cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                    
                                    cell.reply_lbl.text =  "Gif"
                                    
                                }else if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "text"{
                                    
                                    cell.replyImageView_width.constant = 0
                                    
                                    cell.reply_lbl.text = self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? ""
                                    
                                }else if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "audio" {
                                    
                                    cell.replyImage_View.image = UIImage(named: "microphone_White")
                                    
                                    cell.reply_lbl.text = "Voice Message"
                                }
                                
                            }
                            
                        }else if (file == "gif"){
                            
                            cell.userName_lbl.text! = UserData().name
                            
                            //                            let gifURL = chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? "")
                            //
                            //                            let imageURL = UIImage.gif(url: gifURL)
                            //
                            //                            let gifImage = UIImageView(image: imageURL)
                            //
                            //                            cell.sendUserImage_View.image = gifImage.image
                            
                            
                            
                            //                            cell.sendUserImage_View.image = UIImage.gif(url: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? ""))
                            ////
                            //                            cell.sendUserImage_View.image =  UIImageView(image:imageURL)
                            
                            let filePath = self.getSaveFileUrl(fileName: (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? ""))
                            
                            if String(describing: filePath).contains((self.chatTupleList[indexPath.section].value[indexPath.row].message ?? "")) {
                                
                                let gifData = try? Data(contentsOf: filePath)
                                
                                if gifData != nil {
                                    
                                    cell.sendUserImage_View.image = UIImage.gif(data: gifData!)
                                    
                                    
                                    
                                } else {
                                    self.startDownload(url: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? ""), imageView: cell.sendUserImage_View)
                                    
                                }
                                
                                
                            } else {
                                
                                self.startDownload(url: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? ""), imageView: cell.sendUserImage_View)
                                
                            }
                            
                            cell.sendMessageTime_lbl.text! = timeFormatChange(date: self.chatTupleList[indexPath.section].value[indexPath.row].createdAt ?? "")
                            
                            cell.sendMessageUserImage_View.sd_setImage(with: URL(string:  profileImageUrl + UserData().image), placeholderImage: UIImage(named: "noimage_icon"))
                            
                            if  self.backGroundImageCondition == "black" {
                                cell.sendMessageTime_lbl.tintColor = UIColor.white
                                cell.sendMessageTime_lbl.textColor = UIColor.white
                                
                                
                                
                            }else if self.backGroundImageCondition == "white"  {
                                
                                cell.sendMessageTime_lbl.textColor = UIColor.appDarKGray
                                
                                
                            }else {
                                cell.sendMessageTime_lbl.textColor = UIColor.appDarKGray
                                
                            }
                            
                            
                            if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide == nil {
                                
                                cell.reply_View.isHidden = false
                                
                                cell.replyView_height.constant = 0
                                
                            }else {
                                
                                cell.reply_View.isHidden = false
                                
                                cell.replyView_height.constant = 40
                                
                                if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "image"{
                                    
                                    
                                    cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                    
                                    cell.reply_lbl.text = "Image"
                                    
                                    
                                }else if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "video"{
                                    
                                    cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.thumb ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                    
                                    cell.reply_lbl.text = "Video"
                                    
                                    
                                } else if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "gif"{
                                    
                                    cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                    
                                    cell.reply_lbl.text = "Gif"
                                    
                                }else if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "text"{
                                    
                                    cell.replyImageView_width.constant = 0
                                    
                                    cell.reply_lbl.text = self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? ""
                                    
                                }else if self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "audio" {
                                    
                                    cell.replyImage_View.image = UIImage(named: "microphone_White")
                                    
                                    cell.reply_lbl.text = "Voice Message"
                                }
                                
                            }
                            
                        }
                        
                        cell.openMediaType_btn.tag = indexPath.row
                        
                        cell.openMediaType_btn.accessibilityHint = "\(indexPath.section)"
                        
                        
                        cell.openMediaType_btn.addTarget(self, action: #selector(tapViewFile_btn(_:)), for: .touchUpInside)
                        
                        
                        
                        return cell
                        
                    }
                    
                }
                
            }
            
        }else {
            
            ///..... getting message
            if self.chatTupleList[indexPath.section].value[indexPath.row].messageType  != "" {
                
                if  self.chatTupleList[indexPath.section].value[indexPath.row].messageType ?? "" == "text" {
                    
                    let cell = self.chat_TableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell1") as! ChatTableViewCell
                    
                    let getMessage:String = self.chatTupleList[indexPath.section].value[indexPath.row].message ?? ""
                    cell.receviedMessage_lbl.text! = getMessage.removingPercentEncoding ?? ""
                    
                    cell.receviedMessageTime_lbl.text! = timeFormatChange(date: self.chatTupleList[indexPath.section].value[indexPath.row].createdAt ?? "")
                    
                    
                    
                    if  self.backGroundImageCondition == "black" {
                        
                        // cell.receviedMessageTime_lbl.textColor = UIColor.appDarKGray
                        
                    }else {
                        
                        // cell.receviedMessageTime_lbl.textColor = UIColor.appDarKGray
                    }
                    
                    if self.groupId == "" {
                        
//                        cell.receviedImageViewReceiver_Height.constant = 0
//
//                        cell.receviedMessageUserImage_View.isHidden = true
                        
                       // cell.receviedImageViewReceiver_Height.constant = 40
                        
                        cell.receviedMessageUserImage_View.isHidden = false
                        
                        cell.userName_lbl.text! = self.senderName
                         
                        cell.receviedMessageUserImage_View.sd_setImage(with: URL(string: profileImageUrl + self.senderProfileImage), placeholderImage: UIImage(named: "noimage_icon"))
                        
                        let messageDict = ["room_id": self.chatTupleList[indexPath.section].value[indexPath.row].roomID ?? "", "receiver_id":UserData().userId] as [String: AnyObject]
                        
                        self.socket.emitWithAck("seen", messageDict).timingOut(after: 0){ data in
                            
                        }
                    }else {
                        
                        
                        
                       // cell.receviedImageViewReceiver_Height.constant = 40
                        
                        cell.receviedMessageUserImage_View.isHidden = false
                        
                        cell.userName_lbl.text! = (self.chatTupleList[indexPath.section].value[indexPath.row].senderUserChat?.username ?? "")
                        
                        cell.receviedMessageUserImage_View.sd_setImage(with: URL(string: profileImageUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].senderUserChat?.profileImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                        
                        let messageDict = ["room_id": (self.chatTupleList[indexPath.section].value[indexPath.row].roomID ?? ""), "sender_id":UserData().userId ] as [String: AnyObject]
                        
                        
                        self.socket.emitWithAck("seen_chat", messageDict).timingOut(after: 0){ data in
                            
                        }
                        
                    }
                    
                    cell.replyImage_View.isHidden = true
                    if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide == nil {
                        
                        cell.reply_View.isHidden = true
                        
                       // cell.replyView_height.constant = 0
                        
                    }else {
                        
                        cell.reply_View.isHidden = false
                        
                      //  cell.replyView_height.constant = 40
                        
                        if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "image"{
                            
                            
                            cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                            
                            cell.reply_lbl.text = "Image"
                            cell.replyImage_View.isHidden = false
                            
                        }else if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "video"{
                            
                            cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.thumb ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                            
                            cell.reply_lbl.text = "Video"
                            
                            
                        } else if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "gif"{
                            
                            cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                            
                            cell.reply_lbl.text = "Gif"
                            
                        }else if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "text"{
                            
                           // cell.replyImageView_width.constant = 0
                            let getMessage:String = self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? ""
                                              
                            cell.reply_lbl.text = getMessage.removingPercentEncoding ?? ""
                            
                        }else if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "audio" {
                            
                            cell.replyImage_View.image = UIImage(named: "microphoneThemeColor")
                            
                            cell.reply_lbl.text = "Voice Message"
                        }
                        
                    }
                    
                    return cell
                    
                }else {
                    
                    
                    let file = checkFileExtension(index: indexPath.row, indexSection: indexPath.section)
                    
                    if file != "" {
                        
                        let cell = self.chat_TableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell4") as! ChatTableViewCell
                        
                        cell.imgVideoBackground?.isHidden = true
                        if (file == "img"){
                            
                            cell.receviedImage_View.sd_setImage(with: URL(string: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                            
                            cell.receviedMessageTime_lbl.text! = timeFormatChange(date: self.chatTupleList[indexPath.section].value[indexPath.row].createdAt ?? "")
                            
                            //                            cell.receviedMessageUserImage_View.sd_setImage(with: URL(string: profileImageUrl + self.senderProfileImage), placeholderImage: UIImage(named: "noimage_icon"))
                            
                            if  self.backGroundImageCondition == "black" {
                                
                                // cell.receviedMessageTime_lbl.textColor = UIColor.appDarKGray
                                
                            }else {
                                
                                // cell.receviedMessageTime_lbl.textColor = UIColor.appDarKGray
                            }
                            
                            
                            if self.groupId == "" {
//                                cell.receviedImageViewReceiver_Height.constant = 0
//
//                                cell.receviedMessageUserImage_View.isHidden = true
                                
                               // cell.receviedImageViewReceiver_Height.constant = 40
                                
                                cell.receviedMessageUserImage_View.isHidden = false
                                
                                cell.userName_lbl.text! = self.senderName
                                
                                cell.receviedMessageUserImage_View.sd_setImage(with: URL(string: profileImageUrl + self.senderProfileImage), placeholderImage: UIImage(named: "noimage_icon"))
                                
                                let messageDict = ["room_id": self.chatTupleList[indexPath.section].value[indexPath.row].roomID ?? "", "receiver_id":UserData().userId] as [String: AnyObject]
                                
                                self.socket.emitWithAck("seen", messageDict).timingOut(after: 0){ data in
                                    
                                }
                            }else {
                                
                              //  cell.receviedImageViewReceiver_Height.constant = 40
                              
                                cell.receviedMessageUserImage_View.isHidden = false
                                cell.userName_lbl.text! = (self.chatTupleList[indexPath.section].value[indexPath.row].senderUserChat?.username ?? "")
                                
                                cell.receviedMessageUserImage_View.sd_setImage(with: URL(string: profileImageUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].senderUserChat?.profileImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                
                                let messageDict = ["room_id": (self.chatTupleList[indexPath.section].value[indexPath.row].roomID ?? ""), "sender_id":UserData().userId ] as [String: AnyObject]
                                
                                
                                self.socket.emitWithAck("seen_chat", messageDict).timingOut(after: 0){ data in
                                    
                                }
                                
                            }
                            
                            
                            if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide == nil {
                                
                                cell.reply_View.isHidden = false
                                
                                cell.replyView_height.constant = 0
                                
                            }else {
                                
                                cell.reply_View.isHidden = false
                                
                                cell.replyView_height.constant = 40
                                
                                if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "image"{
                                    
                                    
                                    cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                    
                                    cell.reply_lbl.text = "Image"
                                    
                                    
                                }else if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "video"{
                                    
                                    cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.thumb ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                    
                                    cell.reply_lbl.text = "Video"
                                    
                                    
                                } else if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "gif"{
                                    
                                    cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                    
                                    cell.reply_lbl.text = "Gif"
                                    
                                }else if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "text"{
                                    
                                    cell.replyImageView_width.constant = 0
                                    
                                    let getMessage:String = self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? ""
                                    cell.reply_lbl.text = getMessage.removingPercentEncoding ?? ""
                                    
                                }else if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "audio" {
                                    
                                    cell.replyImage_View.image = UIImage(named: "microphoneThemeColor")
                                    
                                    cell.reply_lbl.text = "Voice Message"
                                }
                                
                            }
                            
                            
                            
                            //                            let messageDict = [["room_id": self.chatTupleList[indexPath.section].value[indexPath.row].roomID ?? "" ]] as [[String: AnyObject]]
                            //
                            //                            self.socket.emitWithAck("seen", messageDict).timingOut(after: 0){ data in
                            //
                            //
                            //                            }
                            
                        }else if (file == "vid") {
                            
                            cell.imgVideoBackground?.isHidden = false
                            
                            cell.receviedImage_View.sd_setImage(with: URL(string: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].thumb ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                            
                            cell.receviedMessageTime_lbl.text! = timeFormatChange(date: self.chatTupleList[indexPath.section].value[indexPath.row].createdAt ?? "")
                            
                            
                            if  self.backGroundImageCondition == "black" {
                                
                                // cell.receviedMessageTime_lbl.textColor = UIColor.appDarKGray
                                
                            }else {
                                
                                // cell.receviedMessageTime_lbl.textColor = UIColor.appDarKGray
                            }
                            
                            //                            cell.receviedMessageUserImage_View.sd_setImage(with: URL(string: profileImageUrl + self.senderProfileImage), placeholderImage: UIImage(named: "noimage_icon"))
                            
                            if  self.backGroundImageCondition == "black" {
                                
                                // cell.receviedMessageTime_lbl.textColor = UIColor.appDarKGray
                                
                            }else {
                                
                                // cell.receviedMessageTime_lbl.textColor = UIColor.appDarKGray
                            }
                            
                            if self.groupId == "" {
                                
//                                cell.receviedImageViewReceiver_Height.constant = 0
//                                
//                                cell.receviedMessageUserImage_View.isHidden = true
                                
                             //   cell.receviedImageViewReceiver_Height.constant = 40
                                
                                cell.receviedMessageUserImage_View.isHidden = false
                                
                                cell.userName_lbl.text! = self.senderName
                                
                                cell.receviedMessageUserImage_View.sd_setImage(with: URL(string: profileImageUrl + self.senderProfileImage), placeholderImage: UIImage(named: "noimage_icon"))
                                
                                let messageDict = ["room_id": self.chatTupleList[indexPath.section].value[indexPath.row].roomID ?? "", "receiver_id":UserData().userId] as [String: AnyObject]
                                
                                self.socket.emitWithAck("seen", messageDict).timingOut(after: 0){ data in
                                    
                                }
                            }else {
                                
                                
                            //    cell.receviedImageViewReceiver_Height.constant = 40
                                
                                cell.receviedMessageUserImage_View.isHidden = false
                                cell.userName_lbl.text! = (self.chatTupleList[indexPath.section].value[indexPath.row].senderUserChat?.username ?? "")
                                
                                cell.receviedMessageUserImage_View.sd_setImage(with: URL(string: profileImageUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].senderUserChat?.profileImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                
                                let messageDict = ["room_id": (self.chatTupleList[indexPath.section].value[indexPath.row].roomID ?? ""), "sender_id":UserData().userId ] as [String: AnyObject]
                                
                                
                                self.socket.emitWithAck("seen_chat", messageDict).timingOut(after: 0){ data in
                                    
                                }
                                
                            }
                            
                            
                            if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide == nil {
                                
                                cell.reply_View.isHidden = false
                                
                                cell.replyView_height.constant = 0
                                
                            }else {
                                
                                cell.reply_View.isHidden = false
                                
                                cell.replyView_height.constant = 40
                                
                                if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "image"{
                                    
                                    
                                    cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                    
                                    cell.reply_lbl.text = "Image"
                                    
                                    
                                }else if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "video"{
                                    
                                    cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.thumb ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                    
                                    cell.reply_lbl.text = "Video"
                                    
                                    
                                } else if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "gif"{
                                    
                                    cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                    
                                    cell.reply_lbl.text = "Gif"
                                    
                                }else if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "text"{
                                    
                                    cell.replyImageView_width.constant = 0
                                    
                                    cell.reply_lbl.text = self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? ""
                                    
                                }else if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "audio" {
                                    
                                    cell.replyImage_View.image = UIImage(named: "microphoneThemeColor")
                                    
                                    cell.reply_lbl.text = "Voice Message"
                                }
                                
                            }
                            
                        }else if file == "aud" {
                            
                            let cell =  self.chat_TableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell6") as! ChatTableViewCell
                            
                            cell.chatListElement = self.chatTupleList[indexPath.section].value[indexPath.row]
                            
                            cell.delegate = self
                            
                            cell.cellType = ""
                            
                            // cell.recevierImage = self.senderProfileImage
                            
                            //                            cell.sendMessageUserImage_View .sd_setImage(with: URL(string: profileImageUrl + self.senderProfileImage), placeholderImage: UIImage(named: "noimage_icon"))
                            
                            if  self.backGroundImageCondition == "black" {
                                
                                cell.sendMessageTime_lbl.textColor = UIColor.appDarKGray
                                
                                cell.senderAudioTime_lbl.textColor = UIColor.appDarKGray
                                
                            }else {
                                
                                cell.sendMessageTime_lbl.textColor = UIColor.appDarKGray
                                
                                cell.senderAudioTime_lbl.textColor = UIColor.appDarKGray
                            }
                            
                            
                            if self.groupId == "" {
                                
//                                cell.receviedImageViewReceiver_Height.constant = 0
//
//                                cell.receviedMessageUserImage_View.isHidden = true
                                
                             //   cell.receviedImageViewReceiver_Height.constant = 40
                                
                                cell.receviedMessageUserImage_View.isHidden = false
                                
                                cell.userName_lbl.text! = self.senderName
                                
                                cell.sendMessageUserImage_View.sd_setImage(with: URL(string: profileImageUrl + self.senderProfileImage), placeholderImage: UIImage(named: "noimage_icon"))
                                
                                let messageDict = ["room_id": self.chatTupleList[indexPath.section].value[indexPath.row].roomID ?? "", "receiver_id":UserData().userId] as [String: AnyObject]
                                
                                self.socket.emitWithAck("seen", messageDict).timingOut(after: 0){ data in
                                    
                                }
                            }else {
                                
                               // cell.receviedImageViewReceiver_Height.constant = 40
                                
                                cell.receviedMessageUserImage_View.isHidden = false
                                
                                cell.userName_lbl.text! = (self.chatTupleList[indexPath.section].value[indexPath.row].senderUserChat?.username ?? "")
                                
                                cell.sendMessageUserImage_View.sd_setImage(with: URL(string: profileImageUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].senderUserChat?.profileImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                
                                let messageDict = ["room_id": (self.chatTupleList[indexPath.section].value[indexPath.row].roomID ?? ""), "sender_id":UserData().userId ] as [String: AnyObject]
                                
                                
                                self.socket.emitWithAck("seen_chat", messageDict).timingOut(after: 0){ data in
                                    
                                }
                                
                            }
                            
                            
                            if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide == nil {
                                
                                cell.reply_View.isHidden = false
                                
                                cell.replyView_height.constant = 0
                                
                            }else {
                                
                                cell.reply_View.isHidden = false
                                
                                cell.replyView_height.constant = 40
                                
                                if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "image"{
                                    
                                    
                                    cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                    
                                    cell.reply_lbl.text = "Image"
                                    
                                    
                                }else if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "video"{
                                    
                                    cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.thumb ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                    
                                    cell.reply_lbl.text = "Video"
                                    
                                    
                                } else if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "gif"{
                                    
                                    cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                    
                                    cell.reply_lbl.text = "Gif"
                                    
                                }else if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "text"{
                                    
                                    cell.replyImageView_width.constant = 0
                                    
                                    cell.reply_lbl.text = self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? ""
                                    
                                }else if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "audio" {
                                    
                                    cell.replyImage_View.image = UIImage(named: "microphoneThemeColor")
                                    
                                    cell.reply_lbl.text = "Voice Message"
                                }
                                
                            }
                            
                            return cell
                        }else if(file == "doc"){
                            
                            cell.receviedImage_View.image = UIImage(named: "pdf_icon")
                            
                            cell.receviedMessageTime_lbl.text! = timeFormatChange(date: self.chatTupleList[indexPath.section].value[indexPath.row].createdAt ?? "")
                            
                            //                            cell.receviedMessageUserImage_View.sd_setImage(with: URL(string: profileImageUrl + self.senderProfileImage), placeholderImage: UIImage(named: "noimage_icon"))
                            
                            if  self.backGroundImageCondition == "black" {
                                
                                // cell.receviedMessageTime_lbl.textColor = UIColor.appDarKGray
                                
                            }else {
                                
                                // cell.receviedMessageTime_lbl.textColor = UIColor.appDarKGray
                            }
                            
                            
                            
                            if self.groupId == "" {
                                
                                
//                                cell.receviedImageViewReceiver_Height.constant = 0
//
//                                cell.receviedMessageUserImage_View.isHidden = true
                                
                              //  cell.receviedImageViewReceiver_Height.constant = 40
                                
                                cell.receviedMessageUserImage_View.isHidden = false
                                cell.userName_lbl.text! = self.senderName
                                
                                cell.receviedMessageUserImage_View.sd_setImage(with: URL(string: profileImageUrl + self.senderProfileImage), placeholderImage: UIImage(named: "noimage_icon"))
                                
                                let messageDict = ["room_id": self.chatTupleList[indexPath.section].value[indexPath.row].roomID ?? "", "receiver_id":UserData().userId] as [String: AnyObject]
                                
                                self.socket.emitWithAck("seen", messageDict).timingOut(after: 0){ data in
                                    
                                }
                            }else {
                                
                              //  cell.receviedImageViewReceiver_Height.constant = 40
                                
                                cell.receviedMessageUserImage_View.isHidden = false
                                
                                cell.userName_lbl.text! = (self.chatTupleList[indexPath.section].value[indexPath.row].senderUserChat?.username ?? "")
                                
                                cell.receviedMessageUserImage_View.sd_setImage(with: URL(string: profileImageUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].senderUserChat?.profileImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                
                                let messageDict = ["room_id": (self.chatTupleList[indexPath.section].value[indexPath.row].roomID ?? ""), "sender_id":UserData().userId ] as [String: AnyObject]
                                
                                
                                self.socket.emitWithAck("seen_chat", messageDict).timingOut(after: 0){ data in
                                    
                                }
                                
                            }
                            
                            
                            if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide == nil {
                                
                                cell.reply_View.isHidden = false
                                
                                cell.replyView_height.constant = 0
                                
                            }else {
                                
                                cell.reply_View.isHidden = false
                                
                                cell.replyView_height.constant = 40
                                
                                if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "image"{
                                    
                                    
                                    cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                    
                                    cell.reply_lbl.text = "Image"
                                    
                                    
                                }else if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "video"{
                                    
                                    cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.thumb ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                    
                                    cell.reply_lbl.text = "Video"
                                    
                                    
                                } else if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "gif"{
                                    
                                    cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                    
                                    cell.reply_lbl.text = "Gif"
                                    
                                }else if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "text"{
                                    
                                    cell.replyImageView_width.constant = 0
                                    
                                    cell.reply_lbl.text = self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? ""
                                    
                                }else if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "audio" {
                                    
                                    cell.replyImage_View.image = UIImage(named: "microphoneThemeColor")
                                    
                                    cell.reply_lbl.text = "Audio Message"
                                }
                                
                            }
                            
                            
                        }else if (file == "gif"){
                            
                            //                            let gifURL = chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? "")
                            //
                            //                            let imageURL = UIImage.gif(url: gifURL)
                            //
                            //                            let gifImage = UIImageView(image: imageURL)
                            //
                            //                            cell.sendUserImage_View.image = gifImage.image
                            
                            
                            
                            //                            cell.sendUserImage_View.image = UIImage.gif(url: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? ""))
                            ////
                            //                            cell.sendUserImage_View.image =  UIImageView(image:imageURL)
                            
                            let filePath = self.getSaveFileUrl(fileName: (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? ""))
                            
                            if String(describing: filePath).contains((self.chatTupleList[indexPath.section].value[indexPath.row].message ?? "")) {
                                
                                let gifData = try? Data(contentsOf: filePath)
                                
                                if gifData != nil {
                                    
                                    cell.receviedImage_View.image = UIImage.gif(data: gifData!)
                                    
                                    
                                    
                                } else {
                                    self.startDownload(url: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? ""), imageView: cell.receviedImage_View)
                                    
                                }
                                
                                
                            } else {
                                
                                self.startDownload(url: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? ""), imageView: cell.receviedImage_View)
                                
                            }
                            
                            cell.receviedMessageTime_lbl.text! = timeFormatChange(date: self.chatTupleList[indexPath.section].value[indexPath.row].createdAt ?? "")
                            
                            //                            cell.receviedMessageUserImage_View.sd_setImage(with: URL(string: profileImageUrl + self.senderProfileImage), placeholderImage: UIImage(named: "noimage_icon"))
                            
                            if  self.backGroundImageCondition == "black" {
                                
                                // cell.receviedMessageTime_lbl.textColor = UIColor.appDarKGray
                                
                            }else {
                                
                                // cell.receviedMessageTime_lbl.textColor = UIColor.appDarKGray
                            }
                            
                            
                            
                            //                            let messageDict = [["room_id": self.chatTupleList[indexPath.section].value[indexPath.row].roomID ?? ""]] as [[String: AnyObject]]
                            //
                            //                            self.socket.emitWithAck("seen", messageDict).timingOut(after: 0){ data in
                            //
                            //
                            //                            }
                            
                        }
                        
                        cell.openMediaType_btn.tag = indexPath.row
                        
                        cell.openMediaType_btn.accessibilityHint = "\(indexPath.section)"
                        
                        
                        cell.openMediaType_btn.addTarget(self, action: #selector(tapViewFile_btn(_:)), for: .touchUpInside)
                        
                        
                        if self.groupId == "" {
                            
                            
//                            cell.receviedImageViewReceiver_Height.constant = 0
//
//                            cell.receviedMessageUserImage_View.isHidden = true
                          
                            
                           // cell.receviedImageViewReceiver_Height.constant = 40
                            
                            cell.receviedMessageUserImage_View.isHidden = false
                            
                            cell.userName_lbl.text! = self.senderName
                            
                            cell.receviedMessageUserImage_View.sd_setImage(with: URL(string: profileImageUrl + self.senderProfileImage), placeholderImage: UIImage(named: "noimage_icon"))
                            
                            let messageDict = ["room_id": self.chatTupleList[indexPath.section].value[indexPath.row].roomID ?? "", "receiver_id":UserData().userId] as [String: AnyObject]
                            
                            self.socket.emitWithAck("seen", messageDict).timingOut(after: 0){ data in
                                
                            }
                        }else {
                            
                          //  cell.receviedImageViewReceiver_Height.constant = 40
                            
                            cell.receviedMessageUserImage_View.isHidden = false
                            
                            cell.userName_lbl.text! = (self.chatTupleList[indexPath.section].value[indexPath.row].senderUserChat?.username ?? "")
                            
                            cell.receviedMessageUserImage_View.sd_setImage(with: URL(string: profileImageUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].senderUserChat?.profileImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                            
                         //   "chat_id":self.chatTupleList[indexPath.section].value[indexPath.row].id ?? 0 ,
                            
                            let messageDict = ["room_id": (self.chatTupleList[indexPath.section].value[indexPath.row].roomID ?? ""), "sender_id":UserData().userId ] as [String: AnyObject]
                            
                            
                            self.socket.emitWithAck("seen_chat", messageDict).timingOut(after: 0){ data in
                                
                            }
                            
                        }
                        
                        
                        if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide == nil {
                            
                            cell.reply_View.isHidden = false
                            
                            cell.replyView_height.constant = 0
                            
                        }else {
                            
                            cell.reply_View.isHidden = false
                            
                            cell.replyView_height.constant = 40
                            
                            if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "image"{
                                
                                
                                cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                
                                cell.reply_lbl.text = "Image"
                                
                                
                            }else if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "video"{
                                
                                cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.thumb ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                
                                cell.reply_lbl.text = "Video"
                                
                                
                            } else if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "gif"{
                                
                                cell.replyImage_View.sd_setImage(with: URL(string: chatUrl + (self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                                
                                cell.reply_lbl.text = "Gif"
                                
                            }else if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "text"{
                                
                                cell.replyImageView_width.constant = 0
                                
                                cell.reply_lbl.text = self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.message ?? ""
                                
                            }else if self.self.chatTupleList[indexPath.section].value[indexPath.row].chatSlide?.messageType ?? "" == "audio" {
                                
                                cell.replyImage_View.image = UIImage(named: "microphoneThemeColor")
                                
                                cell.reply_lbl.text = "Voice Message"
                            }
                            
                        }
                        
                        return cell
                        
                    }
                }
                
                
            }
            
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Selected")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        print("didselected")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //
    //        //        switch editingStyle {
    //        //        case .none:
    //        //
    //        //            print("none")
    //        //
    //        //        case .delete:
    //        //
    //        //        print("delete")
    //        //
    //        //        case .insert:
    //        //
    //        //            print("insert")
    //        //
    //        //        }
    //
    //        //        return tableView.editing ? UITableViewCell.EditingStyle.none : UITableViewCell.EditingStyle.delete
    //    }
    
    //////.... stop swipe by nishant
/*
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        self.chat_id =  String((self.chatTupleList[indexPath.section].value[indexPath.row].id ?? 0))
        
        if  self.chatTupleList[indexPath.section].value[indexPath.row].senderID ==  Int(UserData().userId){
            
            self.replyUserName_lbl.text! = UserData().name
            
            self.replyUserImage_View.sd_setImage(with: URL(string: profileImageUrl + UserData().image), placeholderImage: UIImage(named: "noimage_icon"))
            
        }else {
            
            if self.groupId == "" {
                
                self.replyUserName_lbl.text! = self.senderName
                
                self.replyUserImage_View.sd_setImage(with: URL(string: profileImageUrl + self.senderProfileImage), placeholderImage: UIImage(named: "noimage_icon"))
                
            }else {
                
                self.replyUserImage_View.sd_setImage(with: URL(string: profileImageUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].senderUserChat?.profileImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                
                self.replyUserName_lbl.text! = (self.chatTupleList[indexPath.section].value[indexPath.row].senderUserChat?.username ?? "")
                
            }
            
        }
        
        if let type = self.chatTupleList[indexPath.section].value[indexPath.row].messageType {
            
            if type == "text" {
                
                self.replyMediaImage_View.isHidden = true
                
                self.replyMediaWidth_height.constant = 0
                self.replyMediaName_lbl.text! = (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? "").replacingOccurrences(of: "\n", with: " ")
                
            }else {
                
                let file = checkFileExtension(index: indexPath.row, indexSection: indexPath.section)
                
                if file != "" {
                    
                    if (file == "gif") {
                        
                        self.replyMediaImage_View.isHidden = false
                        
                        self.replyMediaWidth_height.constant = 40
                        
                        self.replyMediaName_lbl.text! = (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? "").replacingOccurrences(of: "\n", with: " ")
                        
                        let filePath = self.getSaveFileUrl(fileName: (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? ""))
                        
                        if String(describing: filePath).contains((self.chatTupleList[indexPath.section].value[indexPath.row].message ?? "")) {
                            
                            let gifData = try? Data(contentsOf: filePath)
                            
                            if gifData != nil {
                                
                                self.replyMediaImage_View.image = UIImage.gif(data: gifData!)
                                
                                
                                
                            } else {
                                self.startDownload(url: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? ""), imageView: self.replyMediaImage_View)
                                
                            }
                            
                            
                        } else {
                            
                            self.startDownload(url: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? ""), imageView: self.replyMediaImage_View)
                            
                        }
                        
                    }else if (file == "doc") {
                        
                        self.replyMediaImage_View.isHidden = false
                        
                        self.replyMediaWidth_height.constant = 40
                        
                        self.replyMediaName_lbl.text! = (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? "").replacingOccurrences(of: "\n", with: " ")
                        
                        self.replyMediaImage_View.image = UIImage(named: "pdf_icon")
                        
                    }else if file == "aud" {
                        
                        self.replyMediaImage_View.isHidden = false
                        
                        self.replyMediaWidth_height.constant = 40
                        
                        self.replyMediaName_lbl.text! = (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? "").replacingOccurrences(of: "\n", with: " ")
                        
                        self.replyMediaImage_View.image = UIImage(named: "microphoneThemeColor")
                    }else if (file == "vid") {
                        
                        self.replyMediaImage_View.isHidden = false
                        
                        self.replyMediaWidth_height.constant = 40
                        
                        self.replyMediaName_lbl.text! = (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? "").replacingOccurrences(of: "\n", with: " ")
                        
                        self.replyMediaImage_View.sd_setImage(with: URL(string:  chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].thumb ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                        
                        
                    }else if (file == "img"){
                        
                        self.replyMediaImage_View.isHidden = false
                        
                        self.replyMediaWidth_height.constant = 40
                        
                        self.replyMediaName_lbl.text! = (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? "").replacingOccurrences(of: "\n", with: " ")
                        
                        self.replyMediaImage_View.sd_setImage(with: URL(string:  chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                        
                    }else {
                        
                        self.replyMediaImage_View.isHidden = true
                        
                        self.replyMediaWidth_height.constant = 0
                        self.replyMediaName_lbl.text! = (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? "").replacingOccurrences(of: "\n", with: " ")
                        
                    }
                    
                }
                
            }
            
        }
        
        
        // Write action code for the trash
        let TrashAction = UIContextualAction(style: .destructive, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            //self.replyTop_View.isHidden = false
            UIView.transition(with: self.replyTop_View, duration: 0.7,
                options: .transitionCrossDissolve,
                animations: {
                    self.replyTop_View.isHidden = false
            })
            success(true)
        })
        
            TrashAction.image = UIImage(named: "ic_reply_24px")
        //
        //        TrashAction.image?.accessibilityFrame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        TrashAction.backgroundColor = UIColor.white
        TrashAction.backgroundColor.withAlphaComponent(0.3)
        
        // Write action code for the Flag
        //        let FlagAction = UIContextualAction(style: .normal, title:  "Flag", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
        //
        //            success(true)
        //        })
        //        // FlagAction.backgroundColor = UIColor(patternImage:  UIImage(named: "delete")!)
        //        FlagAction.image = UIImage(named: "notification")
        //        FlagAction.image?.accessibilityFrame = CGRect(x: 0, y: 0, width: 20, height: 20)
        //
        //        // Write action code for the More
        //        let MoreAction = UIContextualAction(style: .normal, title:  "More", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
        //
        //            success(true)
        //        })
        //        //  MoreAction.backgroundColor = .white
        //        MoreAction.image = UIImage(named: "menu")
        //        MoreAction.image?.accessibilityFrame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        
        return UISwipeActionsConfiguration(actions: [TrashAction])
        
    }
    */
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        self.chat_id =  String((self.chatTupleList[indexPath.section].value[indexPath.row].id ?? 0))
        
        if  self.chatTupleList[indexPath.section].value[indexPath.row].senderID ==  Int(UserData().userId){
            
            self.replyUserName_lbl.text! = UserData().name
            
          //  self.replyUserImage_View.sd_setImage(with: URL(string: profileImageUrl + UserData().image), placeholderImage: UIImage(named: "noimage_icon"))
            
        }else {
            
            if self.groupId == "" {
                
                self.replyUserName_lbl.text! = self.senderName
                
             //   self.replyUserImage_View.sd_setImage(with: URL(string: profileImageUrl + self.senderProfileImage), placeholderImage: UIImage(named: "noimage_icon"))
                
            }else {
                
              //  self.replyUserImage_View.sd_setImage(with: URL(string: profileImageUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].senderUserChat?.profileImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                
                self.replyUserName_lbl.text! = (self.chatTupleList[indexPath.section].value[indexPath.row].senderUserChat?.username ?? "")
                
            }
            
        }
        
        if let type = self.chatTupleList[indexPath.section].value[indexPath.row].messageType {
            
            if type == "text" {
                
                self.replyMediaImage_View.isHidden = true
                
                self.replyMediaWidth_height.constant = 0
               // self.replyMediaName_lbl.text! =
                
                
                let getMessage:String = (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? "").replacingOccurrences(of: "\n", with: " ")
                                              
                self.replyMediaName_lbl.text! = getMessage.removingPercentEncoding ?? ""
                
            }else {
                
                let file = checkFileExtension(index: indexPath.row, indexSection: indexPath.section)
                
                if file != "" {
                    
                    if (file == "gif") {
                        
                        self.replyMediaImage_View.isHidden = false
                        
                        self.replyMediaWidth_height.constant = 40
                        let getMessage:String = (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? "").replacingOccurrences(of: "\n", with: " ")
                               
                        self.replyMediaName_lbl.text! = getMessage.removingPercentEncoding ?? ""
                        
                        let filePath = self.getSaveFileUrl(fileName: (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? ""))
                        
                        if String(describing: filePath).contains((self.chatTupleList[indexPath.section].value[indexPath.row].message ?? "")) {
                            
                            let gifData = try? Data(contentsOf: filePath)
                            
                            if gifData != nil {
                                
                                self.replyMediaImage_View.image = UIImage.gif(data: gifData!)
                                
                                
                                
                            } else {
                                self.startDownload(url: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? ""), imageView: self.replyMediaImage_View)
                                
                            }
                            
                            
                        } else {
                            
                            self.startDownload(url: chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? ""), imageView: self.replyMediaImage_View)
                            
                        }
                        
                    }else if (file == "doc") {
                        
                        self.replyMediaImage_View.isHidden = false
                        
                        self.replyMediaWidth_height.constant = 40
                        
                        self.replyMediaName_lbl.text! = (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? "").replacingOccurrences(of: "\n", with: " ")
                        
                        self.replyMediaImage_View.image = UIImage(named: "pdf_icon")
                        
                    }else if file == "aud" {
                        
                        self.replyMediaImage_View.isHidden = false
                        
                        self.replyMediaWidth_height.constant = 40
                        
                        self.replyMediaName_lbl.text! = (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? "").replacingOccurrences(of: "\n", with: " ")
                        
                        self.replyMediaImage_View.image = UIImage(named: "microphoneThemeColor")
                    }else if (file == "vid") {
                        
                        self.replyMediaImage_View.isHidden = false
                        
                        self.replyMediaWidth_height.constant = 40
                        
                        
                        let getMessage:String = (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? "").replacingOccurrences(of: "\n", with: " ")
                         self.replyMediaName_lbl.text! = getMessage.removingPercentEncoding ?? ""
                        
                        
                        
                        
                        self.replyMediaImage_View.sd_setImage(with: URL(string:  chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].thumb ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                        
                        
                    }else if (file == "img"){
                        
                        self.replyMediaImage_View.isHidden = false
                        
                        self.replyMediaWidth_height.constant = 40
                        
                       // self.replyMediaName_lbl.text! =
                        
                        
                        let getMessage:String = (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? "").replacingOccurrences(of: "\n", with: " ")
                        self.replyMediaName_lbl.text! = getMessage.removingPercentEncoding ?? ""
                        
                        self.replyMediaImage_View.sd_setImage(with: URL(string:  chatUrl + (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                        
                    }else {
                        
                        self.replyMediaImage_View.isHidden = true
                        
                        self.replyMediaWidth_height.constant = 0
                        
                        let getMessage:String = (self.chatTupleList[indexPath.section].value[indexPath.row].message ?? "").replacingOccurrences(of: "\n", with: " ")
                          self.replyMediaName_lbl.text! = getMessage.removingPercentEncoding ?? ""
                        
                       // self.replyMediaName_lbl.text! =
                        
                    }
                    
                }
                
            }
            
        }
        
        
        // Write action code for the trash
        let TrashAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            //self.replyTop_View.isHidden = false
            UIView.transition(with: self.replyTop_View, duration: 0.7,
                options: .transitionCrossDissolve,
                animations: {
                    self.replyTop_View.isHidden = false
            })
            success(true)
        })
        
        //        TrashAction.image = UIImage(named: "delete_black")
        //
        //        TrashAction.image?.accessibilityFrame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        
        TrashAction.image = UIImage(named: "ic_reply_24px")
        TrashAction.backgroundColor = UIColor.clear
        TrashAction.backgroundColor.withAlphaComponent(0.3)
        // Write action code for the Flag
        //        let FlagAction = UIContextualAction(style: .normal, title:  "Flag", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
        //
        //            success(true)
        //        })
        //        // FlagAction.backgroundColor = UIColor(patternImage:  UIImage(named: "delete")!)
        //        FlagAction.image = UIImage(named: "notification")
        //        FlagAction.image?.accessibilityFrame = CGRect(x: 0, y: 0, width: 20, height: 20)
        //
        //        // Write action code for the More
        //        let MoreAction = UIContextualAction(style: .normal, title:  "More", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
        //
        //            success(true)
        //        })
        //        //  MoreAction.backgroundColor = .white
        //        MoreAction.image = UIImage(named: "menu")
        //        MoreAction.image?.accessibilityFrame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        
        
        
        self.timerCellSwipeButtons = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerCellSwipeButtonsFunction), userInfo: nil, repeats: true)

        return UISwipeActionsConfiguration(actions: [TrashAction])
        
    }
   

    /////... remove abckground color from swipe
    @objc func timerCellSwipeButtonsFunction() {
        // Gets all the buttons, maybe we have more than one in a row
        let buttons = chat_TableView.allSubViews.filter { (view) -> Bool in
            String(describing: type(of: view)) == "UISwipeActionStandardButton"
        }
        // Loops through all the buttons
        for button in buttons {
            if let view = button.subviews.first(where: { !($0 is UIImageView)})
            {
                // We are interested in the UIView that isn't a UIImageView
                view.backgroundColor = .clear
            }
        }
        // When finish, timer is invalidated because we don't need it anymore.
        // A new one will be launched with every swipe
        self.timerCellSwipeButtons?.invalidate()
    }
    
    
    
}

extension ChatViewController: UIPopoverPresentationControllerDelegate, UITextViewDelegate {
    
    
    // MARK: - Get Chat
    
    func getChat() {
        
        Indicator.shared.showProgressView(self.view)
        
        var param = [String: AnyObject]()
        
        var urlString = ""
        
        if self.groupId == "" {
            
            param = ["sender_id": self.senderId,
                     "receiver_id":self.receiverId ] as [String: AnyObject]
            
          //  print(param)
            urlString = "chat_data"
            
        }else {
            
            urlString = "group_chat_data"
            
            param = ["sender_id": self.senderId,
                     "group_id": self.groupId, "room_id": self.rooomId] as [String: AnyObject]
          //  print(param)
        }
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: urlString, params: param as [String: AnyObject]) { (receviedData) in
            
         //       print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    if self.groupId == "" {
                        
                        self.setFriendData()
                        
                    }else {
                        
                        self.groupNameData()
                    }
                    
                    guard let data = receviedData["data"] as? [[String: AnyObject]]else {
                        
                        
                        return
                    }
                    
                    do {
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        
                        let allChats = try JSONDecoder().decode(ChatModelElement.self, from: jsonData)
                        

                        let groupedData = Dictionary(grouping: allChats, by: {self.timeFormatChangeNew(date: $0.createdAt ?? "")})
                        
                        let sortedDic = groupedData.sorted(by: { (key1, key2) -> Bool in
                            
                            if key1.key < key2.key {
                                
                                return true
                            } else {
                                
                                return false
                            }
                        })
                        self.chatTupleList = sortedDic
                        
                        if(self.chatTupleList.count == 0)
                        {
                            //... this is group data
                            //self.viwNoRecord.isHidden = false
                            
                        }else
                        {
                        
                            self.viwNoRecord.isHidden = true
                        }
                        
                        //... nishant remove bacground Condition 
                        
                        if (((receviedData as? [String: AnyObject])? ["wallpaper"] as? [String: AnyObject])?["type"] as? String ?? "") == "black" && (((receviedData as? [String: AnyObject])? ["wallpaper"] as? [String: AnyObject])?["image"] as? String) == nil  {
                            
                           // self.backGroundImage_View.backgroundColor = UIColor.clear
                         
                         //   self.backGroundImage_View.image = nil
                            
                            self.backGroundImageCondition = "black"
                            
                            self.backGroundImage_View.backgroundColor = UIColor.black
                            
                            
                        }else if (((receviedData as? [String: AnyObject])? ["wallpaper"] as? [String: AnyObject])?["type"] as? String ?? "") == "white" && (((receviedData as? [String: AnyObject])? ["wallpaper"] as? [String: AnyObject])?["image"] as? String) == nil  {
                            
                          //  self.backGroundImage_View.image = nil
                            
                            self.backGroundImageCondition = "white"
                            
                            self.backGroundImage_View.backgroundColor = UIColor.clear
                            
                            self.backGroundImage_View.backgroundColor = UIColor.white
                            
                            
                            
                        }
                        /*
                        else if (((receviedData as? [String: AnyObject])? ["wallpaper"] as? [String: AnyObject])?["type"] as? String ?? "") == "image" {
                            
                            self.backGroundImage_View.sd_setImage(with: URL(string: chatUrl + (((receviedData as? [String: AnyObject])? ["wallpaper"] as? [String: AnyObject])?["image"] as? String ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                            
                            self.backGroundImageCondition = "image"
                        }
                        */
                        
                    }catch {
                        
                        print(error.localizedDescription)
                        
                    }
                    


                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["message"] as? String ?? "No data found")
                    
                    
                }
                
            }else {
                
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["Error"] as? String ?? "No data found")
            }
            
        }
        
    }
    
    //  MARK: - Get Friend Data
    
    @objc func scrollToEnd_sendNewMessage(animated:Bool = false){
           if(self.chatTupleList.count > 0){
                  self.chat_TableView?.scrollToLastCall(animated: animated)
              }
          }
    func setFriendData(){
        
        Indicator.shared.showProgressView(self.view)
        
        var urlString = ""
        
        urlString = "user_image/\(self.receiverId)"
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: urlString) { (receviedData) in
            
            Indicator.shared.hideProgressView()
            
         //   print(receviedData)
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self.senderName = ((receviedData["data"] as? [String: AnyObject])? ["username"] as? String ?? "")
                    
                    self.senderProfileImage = ((receviedData["data"] as? [String: AnyObject])? ["profile_image"] as? String ?? "")

                    ///... update by nishant
                    self.lblName.text = self.senderName
                    self.UserImage.sd_setImage(with: URL(string: profileImageUrl + self.senderProfileImage), placeholderImage: UIImage(named: "noimage_icon"))
                    self.UserImage.layer.cornerRadius = 25/2
                    self.UserImage.layer.borderColor = UIColor.unilifeblueDark.cgColor
                    self.UserImage.layer.borderWidth = 2.0
                    
                    
                 //   self.addNavigation(titleText: self.senderName, imageName: profileImageUrl + self.senderProfileImage)
                    
                    self.chat_TableView.delegate = self
                    self.chat_TableView.dataSource = self
                    self.chat_TableView.reloadDataWithAutoSizingCellWorkAround()
                    if(self.chatTupleList.count > 0)
                    {
                        self.viwNoRecord.isHidden = true
                        self.scrollToEnd_sendNewMessage()
                    }else
                    {
                       // self.viwNoRecord.isHidden = false
                    }
                    
                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["message"] as? String ?? "No data found")
                }
                
            }else {
                
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["Error"] as? String ?? "No data found")
                
            }
            
        }
        
    }
    
    
    // MARK: - Group Name
    
    func groupNameData(){
        
        
        Indicator.shared.showProgressView(self.view)
        
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "group_image/\(self.groupId)") { (receviedData) in
            
         //   print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self.senderName = ((receviedData["data"] as? [String: AnyObject])? ["group_name"] as? String ?? "")
                    
                    self.senderProfileImage = ((receviedData["data"] as? [String: AnyObject])? ["group_image"] as? String ?? "")
                    
                    self.addNavigation(titleText: self.senderName, imageName: profileImageUrl + self.senderProfileImage)
                    
                    self.chat_TableView.delegate = self
                    
                    self.chat_TableView.dataSource = self
                    
                    self.chat_TableView.reloadDataWithAutoSizingCellWorkAround()
                    
                    
                    self.lblName.text = self.senderName
                    self.UserImage.sd_setImage(with: URL(string: profileImageUrl + self.senderProfileImage), placeholderImage: UIImage(named: "noimage_icon"))
                    self.UserImage.layer.cornerRadius = 25/2
                    self.UserImage.layer.borderColor = UIColor.unilifeblueDark.cgColor
                    self.UserImage.layer.borderWidth = 2.0
                    
                    
                    
                    
                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["message"] as? String ?? "No data found")
                }
                
            }else {
                
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["Error"] as? String ?? "No data found")
            }
            
        }
    }
    
    // MARK: - Text View Delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.isKeybordUpByTextField = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                  self.isKeybordUpByTextField = false
              }
        self.botoomSpaceContent?.constant = CGFloat(self.keyBoardHeight)
        UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
         })
        
//        UIView.animate(withDuration: 0.5){
//
//            let height = self.view.frame.height
//            let size = CGFloat(Double(height) - self.keyBoardHeight)
//            self.view.frame.size.height = size
//        }
        
      
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        /*
        UIView.animate(withDuration: 0.5){
            
            let height = self.view.frame.height
            
            let size = CGFloat(Double(height) + self.keyBoardHeight)
            
            self.view.frame.size.height = size
            
        }
        
        self.keyBoardHeight = 0
        
        // self.adjustUITextViewHeight(arg: textView)
        
        
        */
        
        
        self.botoomSpaceContent?.constant = 0
             UIView.animate(withDuration: 0.2, animations: {
                 self.view.layoutIfNeeded()
             })

    }
    
    
    
    func adjustUITextViewHeight(arg : UITextView)
    {
        
        let numOfLines = Int(arg.contentSize.height / (arg.font?.lineHeight)!)
        
        if numOfLines < 4 {
            
            arg.sizeToFit()
            
            if numOfLines == 1{
            }
        }
        
        if arg.frame.size.height <= 90{
            
            arg.translatesAutoresizingMaskIntoConstraints = true
            
            arg.sizeToFit()
            
            arg.frame.size.width = self.bottom_View.frame.size.width - 150
            
            self.heightOfTextView.constant = arg.frame.size.height
            
            arg.isScrollEnabled = false
            
        }else{
            
            arg.isScrollEnabled = true
            
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}

// MARK: - Action Sheet to Open Camera and Gallery

extension ChatViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate {
    
    
    func showAttachFileOption() {
        
        let OptionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        OptionMenu.view.tintColor = UIColor.appSkyBlue
        
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
        
                    let takePhoto_Action = UIAlertAction(title: "Capture Video", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                        
                        
                        self.openVideoCamera()
                    })
        
                    OptionMenu.addAction(takePhoto_Action)
        
                }
        
        let choosePhoto_Action = UIAlertAction(title: "Upload Media ", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            
            self.photoLibrary()
        })
        
        let uploadVideo_Action = UIAlertAction(title: "Upload Video ", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            
            self.videoLibrary()
            
        })
        
        let uploadPdf_Action = UIAlertAction(title: "Upload Document", style: .default, handler: {(alert:UIAlertAction) -> Void in
            
            self.clickFunction()
            
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel ", style:.cancel)
        
        OptionMenu.addAction(choosePhoto_Action)
        //        optionMenu.addAction(uploadVideo_Action)
        OptionMenu.addAction(uploadPdf_Action)
        OptionMenu.addAction(cancelAction)
        self.isImageUploaded = true
        self.present(OptionMenu, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if (String(describing: info[UIImagePickerController.InfoKey.mediaType]!)) == "public.image" {
            
            if info[UIImagePickerController.InfoKey.referenceURL] != nil {
                
                let assetPath = info[UIImagePickerController.InfoKey.referenceURL] as! NSURL
                
                // assetPath.absoluteString?.contains("GIF")
                
                if (assetPath.absoluteString?.hasSuffix("GIF"))! {
                    
                    let refUrl = info[.referenceURL] as? URL
                    
                    if refUrl != nil {
                        let asset = PHAsset.fetchAssets(withALAssetURLs: [refUrl].compactMap { $0 }, options: nil).lastObject
                        if asset != nil {
                            let options = PHImageRequestOptions()
                            options.isSynchronous = true
                            options.isNetworkAccessAllowed = false
                            options.deliveryMode = .highQualityFormat
                            if let asset = asset {
                                PHImageManager.default().requestImageData(for: asset, options: options, resultHandler: { imageData, dataUTI, orientation, info in
                                    let isError = info?[UIImagePickerController.InfoKey(rawValue: PHImageErrorKey)] as? NSNumber
                                    let isCloud = info?[UIImagePickerController.InfoKey(rawValue: PHImageResultIsInCloudKey)] as? NSNumber
                                    if isError?.boolValue ?? false || isCloud?.boolValue ?? false || imageData == nil {
                                        
                                        // fail
                                    } else {
                                        // success, data is in imageData
                                        
                                        self.imageName = self.GenerateUniqueImageName().replacingOccurrences(of: ".jpeg", with: ".gif")
                                        
                                        self.mediaType = "gif"
                                        
                                        self.imageData = imageData
                                        
                                        let messageDict = [["Name": self.imageName, "Size": imageData?.count]] as [[String: AnyObject]]
                                        
                                        self.socket.emitWithAck("uploadFileStart", messageDict).timingOut(after: 0){ data in
                                            
                                        }
                                        
                                        self.dismiss(animated: true, completion: nil)
                                        
                                        //  self.chat_id = ""
                                        self.replyTop_View.isHidden = true
                                        
                                        
                                    }
                                })
                            }
                        }
                    }
                    
                    
                    print("GIF")
                    
                }else {
                    
                    let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                    /*
                    self.cropViewController.customAspectRatio = CGSize(width: self.view.frame.width, height: self.view.frame.height)
                    
                    self.cropStyle = TOCropViewCroppingStyle.default
                    
                    self.cropViewController = TOCropViewController(croppingStyle: self.cropStyle!, image: selectedImage)
                    
                    self.cropViewController.toolbar.clampButtonHidden = true
                    
                    cropViewController.toolbar.rotateClockwiseButtonHidden = true
                    
                    cropViewController.cropView.setAspectRatio(CGSize(width: self.view.frame.size.width, height: self.view.frame.width), animated: true)
                    
                    cropViewController.cropView.aspectRatioLockEnabled = true
                    
                    cropViewController.toolbar.rotateButton.isHidden = true
                    
                    cropViewController.toolbar.resetButton.isHidden = true
                    
                    cropViewController.delegate = self
                    
                    self.dismiss(animated: true, completion: nil)
                    self.isImageUploaded = true
                    self.navigationController?.present(cropViewController, animated: true, completion: nil)
                    
                    
                    */
                    self.imageName = GenerateUniqueImageName()
                    self.imageData = (selectedImage.jpegData(compressionQuality: 0.8) as! Data)
                    self.mediaType = "image"
                    let messageDict = [["Name": self.imageName, "Size": self.imageData.count]] as [[String: AnyObject]]
                    self.socket.emitWithAck("uploadFileStart", messageDict).timingOut(after: 0){ data in
                              
                          }
                          self.dismiss(animated: true, completion: nil)
                          self.replyTop_View.isHidden = true
                }
                
            }else {
                
                let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                /*
                self.cropViewController.customAspectRatio = CGSize(width: self.view.frame.width, height: self.view.frame.height)
                
                self.cropStyle = TOCropViewCroppingStyle.default
                
                self.cropViewController = TOCropViewController(croppingStyle: self.cropStyle!, image: selectedImage)
                
                self.cropViewController.toolbar.clampButtonHidden = true
                
                cropViewController.toolbar.rotateClockwiseButtonHidden = true
                
                cropViewController.cropView.setAspectRatio(CGSize(width: self.view.frame.size.width, height: self.view.frame.width), animated: true)
                
                cropViewController.cropView.aspectRatioLockEnabled = true
                
                cropViewController.toolbar.rotateButton.isHidden = true
                
                cropViewController.toolbar.resetButton.isHidden = true
                
                cropViewController.delegate = self
                
                self.dismiss(animated: true, completion: nil)
                self.isImageUploaded = true
                self.navigationController?.present(cropViewController, animated: true, completion: nil)
                
                */
                
                //...nishant remove crop image
                self.imageName = GenerateUniqueImageName()
                       
                self.imageData = (selectedImage.jpegData(compressionQuality: 0.8)!)
                       
                       self.mediaType = "image"
                       
                       let messageDict = [["Name": self.imageName, "Size": self.imageData.count]] as [[String: AnyObject]]
                       
                       self.socket.emitWithAck("uploadFileStart", messageDict).timingOut(after: 0){ data in
                           
                       }
                       
                       self.dismiss(animated: true, completion: nil)
                       
                       //self.chat_id = ""
                       self.replyTop_View.isHidden = true
            }
            
        }
        else {
            
            
            self.imageName = self.GenerateUniqueImageName().replacingOccurrences(of: ".jpeg", with: ".mp4")
            
            let videoUrl1 = info[UIImagePickerController.InfoKey.mediaURL]
            
            self.condition = "No"
            
            self.videoUrl = String(describing:  info[UIImagePickerController.InfoKey.mediaURL]!)
            
            do {
                
                try
                    self.imageData = Data(contentsOf: videoUrl1 as! URL)
                
            }catch {
                
                return
                
            }
            
            self.mediaType = "video"
            
            let messageDict = [["Name": self.imageName, "Size": self.imageData.count]] as [[String: AnyObject]]
            
            self.socket.emitWithAck("uploadFileStart", messageDict).timingOut(after: 0){ data in
                
                
            }
            
            self.dismiss(animated: true, completion: nil)
            //self.chat_id = ""
            self.replyTop_View.isHidden = true
            
        }
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        
        self.imageName = GenerateUniqueImageName()
        
        self.imageData = (image.jpegData(compressionQuality: 0.8) as! Data)
        
        self.mediaType = "image"
        
        let messageDict = [["Name": self.imageName, "Size": self.imageData.count]] as [[String: AnyObject]]
        
        self.socket.emitWithAck("uploadFileStart", messageDict).timingOut(after: 0){ data in
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
        //self.chat_id = ""
        self.replyTop_View.isHidden = true
    }
    
    
    
    func camera() {
        
        self.image_picker.sourceType = .camera
      // self.image_picker.mediaTypes = [kUTTypeMovie as String]
        
        self.image_picker.delegate = self
        
        present(image_picker, animated: true, completion: nil)
        
    }
    
    func photoLibrary() {
        
        self.image_picker.sourceType = .photoLibrary
        
        self.image_picker.delegate = self
        
        self.image_picker.mediaTypes = ["public.image","public.movie"]
        
        present(image_picker, animated: true, completion: nil)
        
    }

func openVideoCamera() {
    
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
        
        let image_pickerVideo = UIImagePickerController()
        
        image_pickerVideo.sourceType = .camera
        
        image_pickerVideo.mediaTypes = [kUTTypeMovie as String]
        
        image_pickerVideo.delegate = self
        
        present(image_pickerVideo, animated: true, completion: nil)
        
    }
    
}
    
    func videoLibrary() {
        
        self.image_picker.mediaTypes = ["public.movie"]
        
        self.image_picker.delegate = self
        
        present(image_picker, animated: true, completion: nil)
    }
    
    
    
}

extension UIViewController {
    
    // MARK: - show Toast
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: 20, y: self.view.frame.size.height-100, width: 350, height: 35))
        toastLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Arcon-Regular", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 15;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
    func GenerateUniqueImageName() -> String {
        
        let milisec = Int((Date().timeIntervalSince1970 * 1000).rounded())
        return ("Unilife_" + "\(milisec)" + "\(UserData().userId)" + ".jpeg")
    }
    
    
    func generateThumbnail1(path: URL) -> Data? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            
            // cgImage = self.GenerateUniqueImageName() as! CGImage
            
            let   thumbnail = UIImage(cgImage: cgImage)
            
            //self.imageArray.insert(thumbnail, at: selectedIndex)
            //            self.selectImage_CollectionView.reloadData()
            
            let data = thumbnail.jpegData(compressionQuality: 0.8)
            
            
            return data
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getUniqueCode() -> String {
        
        let randomNum:UInt32 = arc4random_uniform(10000000)
        
        let uniqueCode = "\(randomNum)\(randomNum)"
        
        //print(uniqueCode)
        
        return uniqueCode
    }
    
    
 
    
}

//@IBOutlet weak var record_leftArrow: UIImageView!
//@IBOutlet weak var record_leftLbl: UILabel!
//@IBOutlet weak var recordCancelbtn: UIButton!

// MARK - Long Press Button Delegate

extension ChatViewController: LongPressRecordButtonDelegate{
    
    func longPressRecordButtonDidStartLongPress(_ button: LongPressRecordButton) {
        self.secs = 00
        self.timer_view.isHidden = false
        self.runTimer()
        self.recorder.record()
        slidSendAudio_view.isHidden = true
        record_leftArrow.isHidden = false
        record_leftLbl.isHidden = false
        recordCancelbtn.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.slidLockrecord_view.isHidden = false
           }
        
    }
    
    func longPressRecordButtonDidStopLongPress(_ button: LongPressRecordButton) {
       // self.lblAudioTim.text = timeString(time: TimeInterval(secs))
        self.timer_view.isHidden = true
        self.newTimer.invalidate()
        self.slidLockrecord_view.isHidden = true
        slidSendAudio_view.isHidden = true
        self.secs = 00
        self.timer_lbl.text! = "\(secs)"
        self.recorder.stop()
        
      //  self.viwPlayAudio.isHidden = false
      //  self.imgBackgroundAUdio.isHidden = false
        
        if let url = self.recorder.url {
            
            do {
                
                let data = try Data(contentsOf: url)
                
                self.chatFile = UploadableChat(auth_image: (url.lastPathComponent), file_type: "file", file_type_text: .image, message_type: "audio", receiver_id: self.receiverId, room_id: self.rooomId, sender_id: UserData().userId, name: (url.lastPathComponent), size: data.count, basedata: data.base64EncodedString(options: .endLineWithLineFeed), flag: .new)
                
                self.mediaType = "audio"
                
                self.imageName = self.chatFile?.name
                    ?? ""
                
                self.condition = ""
                
                self.imageData = data
                
                let messageDict = [["Name": self.chatFile?.name ?? "", "Size": self.chatFile?.size ?? 0]] as [[String: AnyObject]]
                
                self.socket.emitWithAck("uploadFileStart", messageDict).timingOut(after: 0){ data in
                    
                    
                }
                
            }catch{
                
                print(error.localizedDescription)
                
            }
            
        }
        
        
        
    }
    
    
    func swipeLeftCancel(_ button: LongPressRecordButton) {
        print("Swipe Cancel")
        self.slidLockrecord_view.isHidden = true
        slidSendAudio_view.isHidden = true
       // self.lblAudioTim.text = timeString(time: TimeInterval(secs))
               self.timer_view.isHidden = true
               self.newTimer.invalidate()
               
               self.secs = 00
               self.timer_lbl.text! = "\(secs)"
               self.recorder.stop()
    }
    
    func swipeUPLock(_ button: LongPressRecordButton) {
        print("Swipe Lock")
        record_leftArrow.isHidden = true
        record_leftLbl.isHidden = true
        slidSendAudio_view.isHidden = false
        recordCancelbtn.isHidden = false
        self.slidLockrecord_view.isHidden = true
    }
        ///.... when u lock the audio then showing this button
   @IBAction func Send_audio_when_is_lock()
   {
      // self.lblAudioTim.text = timeString(time: TimeInterval(secs))
         self.timer_view.isHidden = true
         self.newTimer.invalidate()
         self.slidLockrecord_view.isHidden = true
         slidSendAudio_view.isHidden = true
         self.secs = 00
         self.timer_lbl.text! = "\(secs)"
         self.recorder.stop()
         
       //  self.viwPlayAudio.isHidden = false
       //  self.imgBackgroundAUdio.isHidden = false
         
         if let url = self.recorder.url {
             
             do {
                 
                 let data = try Data(contentsOf: url)
                 
                 self.chatFile = UploadableChat(auth_image: (url.lastPathComponent), file_type: "file", file_type_text: .image, message_type: "audio", receiver_id: self.receiverId, room_id: self.rooomId, sender_id: UserData().userId, name: (url.lastPathComponent), size: data.count, basedata: data.base64EncodedString(options: .endLineWithLineFeed), flag: .new)
                 
                 self.mediaType = "audio"
                 
                 self.imageName = self.chatFile?.name
                     ?? ""
                 
                 self.condition = ""
                 
                 self.imageData = data
                 
                 let messageDict = [["Name": self.chatFile?.name ?? "", "Size": self.chatFile?.size ?? 0]] as [[String: AnyObject]]
                 
                 self.socket.emitWithAck("uploadFileStart", messageDict).timingOut(after: 0){ data in
                     
                     
                 }
                 
             }catch{
                 
                 print(error.localizedDescription)
                 
             }
             
         }
         
         
    }
    
    
    @IBAction func cancel_recording()
    {
      // self.lblAudioTim.text = timeString(time: TimeInterval(secs))
              self.timer_view.isHidden = true
              self.newTimer.invalidate()
              self.slidLockrecord_view.isHidden = true
                slidSendAudio_view.isHidden = true
              self.secs = 00
              self.timer_lbl.text! = "\(secs)"
              self.recorder.stop()
    }
    
    
    private func setupRecording() {
        
        self.recordButton.delegate = self
        
    }
    
    
    @objc func runTimer() {
        newTimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateTimer() {
        self.secs += 1     //This will decrement(count down)the seconds.
        self.timer_lbl.text! =  timeString(time: TimeInterval(secs))
        //        self.audioRecordingTimer = timeString(time: TimeInterval(secs))
        //
        //        self.oldDataArray.append(self.audioRecordingTimer)
        //        self.audioReccordingArray.append(self.oldDataArray[self.oldDataArray.count - 1])
        
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
}

// MARK: - document Picker

extension ChatViewController: UIDocumentMenuDelegate,UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let myURL = url as URL
        //print("import result : \(myURL)")
        
        self.imageName = self.GenerateUniqueImageName().replacingOccurrences(of: ".jpeg", with: ".pdf")
        
        
        do {
            try
                self.imageData = Data(contentsOf: myURL )
            
        } catch {
            return
        }
        
        
        self.mediaType = "document"
        
        let messageDist = [["Name" : self.imageName,
                            "Size" : self.imageData.count,
                            "room_id" : self.rooomId]] as [[String  : AnyObject]]
        
        self.socket.emitWithAck("uploadFileStart", messageDist).timingOut(after: 0){data in
            
            //print(data)
            
        }
        
        self.dismiss(animated: true, completion: nil)
        //self.chat_id = ""
        self.replyTop_View.isHidden = true
    }
    
    
    
    public func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        //print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    func clickFunction(){
        
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    
}

// MARK: - Download Gif Data
extension ChatViewController{
    
    func startDownload(url:String , imageView : UIImageView) -> Void {
        
        let fileUrl = self.getSaveFileUrl(fileName: url)
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (fileUrl, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(url, to:destination)
            .downloadProgress { (progress) in
                
            }
            .responseData { (data) in
                
                let gifUrl = data.destinationURL!
                
                let gifData = try? Data(contentsOf: gifUrl)
                
                imageView.image = UIImage.gif(data: gifData!)
                
                
        }
    }
    
    func startDownloadVideo(url:String) -> Void {
        
        let fileUrl = self.getSaveFileUrl(fileName: url)
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (fileUrl, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(url, to:destination)
            .downloadProgress { (progress) in
                
            }
            .responseData { (data) in
                
                
                guard let videoUrl = data.destinationURL as? URL else {
                    return
                }
                
                let videoData = try? Data(contentsOf: videoUrl)
                
                // print(videoData)
                
                //print(data.destinationURL!)
                
        }
    }
    
    func getSaveFileUrl(fileName: String) -> URL {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let nameUrl = URL(string: fileName)
        
        let fileURL = documentsURL.appendingPathComponent((nameUrl?.lastPathComponent)!)
        
        NSLog(fileURL.absoluteString)
        
        return fileURL
    }
}

extension ChatViewController{
    
    func timeFormatChangeNew(date : String) ->  String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let appointmentDate = date
        let dateString = dateFormatter.date(from: appointmentDate)
        //dateFormatter.dateFormat = "E MMM dd, yyyy HH:mm a"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStringToSet = dateFormatter.string(from: dateString!)
        //HH:mm:ss
        return dateStringToSet
        
    }
}






extension UITableView {
    func scrollToLastCall(animated : Bool) {
        let lastSectionIndex = self.numberOfSections - 1 // last section
        let lastRowIndex = self.numberOfRows(inSection: lastSectionIndex) - 1 // last row
       // print("----------------------------------------------    -------------------- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>   ",lastRowIndex)
        if(lastRowIndex >= 0)
        {
           self.scrollToRow(at: IndexPath(row: lastRowIndex, section: lastSectionIndex), at: .bottom, animated: animated)
        }
    }
}


extension String {

    var containsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
                 0x1F300...0x1F5FF, // Misc Symbols and Pictographs
                 0x1F680...0x1F6FF, // Transport and Map
                 0x2600...0x26FF,   // Misc symbols
                 0x2700...0x27BF,   // Dingbats
                 0xFE00...0xFE0F,   // Variation Selectors
                 0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
                 0x1F1E6...0x1F1FF: // Flags
                return true
            default:
                continue
            }
        }
        return false
    }

}
