//
//  ShowVideoAndImagesInMultimediaViewController.swift
//  Unilife
//
//  Created by Apple on 23/11/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit
import Alamofire

class ShowVideoAndImagesInMultimediaViewController: UIViewController {
    
    // MARK: - outlet
    
    @IBOutlet weak var mediaTypeCollection_View: UICollectionView!
    
    @IBOutlet weak var top_View: UIView!
    
    @IBOutlet weak var topView_height: NSLayoutConstraint!
    
    
    // MARK: - Variable
    
    var ImageAndVideoListingData: AudioListingModel?
    var selectIndexArray = [Int]()
    var mediaType = ""
    var mediaUrl = [String]()
    var mediaId = [Int]()
    var type = ""
    var user_id = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mediaTypeCollection_View.delegate = self
        
        self.mediaTypeCollection_View.dataSource = self
        
        if self.mediaUrl.count == 0 || self.mediaId.count == 0 {
            
            self.top_View.isHidden = true
            
            self.topView_height.constant = 0
            
        }else {
            
            self.top_View.isHidden = false
            
            self.topView_height.constant = 30
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if self.mediaType == "image"{
            
            //self.navigationItem.largeTitleDisplayMode = .automatic
            
            self.addNavigationBar(left: .Back, titleType: .Normal, title: "Images", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
            
            self.ImageAndVideoListingData(message_type: "image")
            
        }else if self.mediaType == "document"{
            
            //  self.navigationItem.largeTitleDisplayMode = .automatic
            
            self.addNavigationBar(left: .Back, titleType: .Normal, title: "Documents", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
            
            self.ImageAndVideoListingData(message_type: "document")
        }
        else {
            
            //self.navigationItem.largeTitleDisplayMode = .automatic
            
            self.addNavigationBar(left: .Back, titleType: .Normal, title: "Videos", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
            
            self.ImageAndVideoListingData(message_type: "video")
        }
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    deinit {
        
        print(#file)
    }
    
    // MARK: - Button Action
    
    @IBAction func tapMove_btn(_ sender: Any) {
        
        if self.mediaUrl.count > 1{
            
            self.showDefaultAlert(Message: "Single Media can be move ")
        }else {
            
            if self.mediaUrl.count == 0 {
                
            }else {
                
                self.downloadMedia(mediaUrl: mediaUrl.first!)
                
            }
        }
    }
    
    
    @IBAction func tapDelete_btn(_ sender: Any) {
        
        if self.mediaId.count == 0 {
            
        }else {
            self.showAlertWithActionOkandCancel(Title: "Delete Media", Message: "There will be no backup of media available once deleted ", OkButtonTitle: "Yes", CancelButtonTitle: "No"){
                
                self.deleteMedia()
                
            }
            
            
        }
        
    }
    
    
    
}

extension ShowVideoAndImagesInMultimediaViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ImageAndVideoListingData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self .mediaTypeCollection_View.dequeueReusableCell(withReuseIdentifier: "ShowVideosAndImagesCollectionViewCell", for: indexPath) as! ShowVideosAndImagesCollectionViewCell
        
        
        if self.mediaType == "image"{
            
            
            cell.mediaImage_View.sd_setImage(with: URL(string: chatUrl + (self.ImageAndVideoListingData?[indexPath.row].message ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
            
        }else if mediaType == "document"{
            
            
            cell.mediaImage_View.image = UIImage(named: "pdf_icon")
            
        }else {
            cell.mediaImage_View.sd_setImage(with: URL(string: chatUrl + (self.ImageAndVideoListingData?[indexPath.row].thumb ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
            
        }
        
        cell.mediaName_lbl.text! = (self.ImageAndVideoListingData?[indexPath.row].message ?? "")
        
        cell.selectImage_btn.tag = indexPath.row
        
        cell.selectImage_btn.addTarget(self, action: #selector(selectImageAndVideo_btn(_:)), for: .touchUpInside)
        
        if selectIndexArray[indexPath.row] == 1 {
            
            cell.selectImage_btn.setImage(UIImage(named: "check-symbol"), for: .normal)
            
            cell.backGround_View.backgroundColor = UIColor.appLightGreyColor
        }else {
            
            cell.selectImage_btn.setImage(UIImage(named: "checkBox"), for: .normal)
            
            cell.backGround_View.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.mediaTypeCollection_View.bounds.width / 2 - 10, height: 182)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatFilePickerViewController") as! ChatFilePickerViewController
        
        let file = self.checkFileExtension(index: indexPath.row)
        
        if (file != "") {
            
            if(file == "img"){
                
                vc.fileType = "img"
                
            }else if(file == "doc"){
                
                vc.fileType = "doc"
                
            }else if(file == "vid"){
                
                vc.fileType = "vid"
                
            }
            
            vc.filePath =  self.ImageAndVideoListingData?[indexPath.row].message ?? ""
            
            //            self.navigationController?.present(vc, animated: true, completion: nil)
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    // MARK: - Button Action
    
    
    @objc func selectImageAndVideo_btn(_ sender: UIButton) {
        
        if selectIndexArray[sender.tag] == 0 {
            
            self.selectIndexArray[sender.tag] = 1
            
            self.mediaUrl.append(self.ImageAndVideoListingData?[sender.tag].message ?? "")
            
            self.mediaId.append(self.ImageAndVideoListingData?[sender.tag].id ?? 0)
            
            
            
        }else if selectIndexArray[sender.tag] == 1 {
            
            self.mediaUrl.remove(at: (self.mediaUrl.index(of: self.ImageAndVideoListingData?[sender.tag].message ?? ""))!)
            
            self.mediaId.remove(at: (self.mediaId.index(of: self.ImageAndVideoListingData?[sender.tag].id ?? 0))!)
            
            self.selectIndexArray[sender.tag] = 0
            
        }
        
        if self.mediaUrl.count == 0 || self.mediaId.count == 0 {
            
            self.top_View.isHidden = true
            
            self.topView_height.constant = 0
            
        }else {
            
            self.top_View.isHidden = false
            
            self.topView_height.constant = 30
            
        }
        
        self.mediaTypeCollection_View.reloadData()
    }
    
    
    
    func checkFileExtension(index : Int) -> String{
        
        if let  file = self.ImageAndVideoListingData?[index].message {
            
            
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
    
    
}

// MARK: - Service Response

extension ShowVideoAndImagesInMultimediaViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        
        print("downloadLocation:", location)
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        let destinationURL = documentsPath!.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            
            // self.pdfURL = destinationURL
            
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
            
        }
    }
    
    
    func ImageAndVideoListingData(message_type: String){
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": self.user_id,"message_type": message_type, "type": self.type] as [String: AnyObject]
        
        print(param)
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "view_multimedia_acc_type", params: param as [String: AnyObject]){ (receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    guard let data = receviedData["data"] as? [[String: AnyObject]]else {
                        
                        
                        return
                    }
                    
                    do {
                        
                        let jsondata = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        
                        self.ImageAndVideoListingData = try JSONDecoder().decode(AudioListingModel.self, from: jsondata!)
                        
                        let count = self.ImageAndVideoListingData?.count ?? 0
                        
                        for _ in 0..<count{
                            
                            self.selectIndexArray.append(0)
                        }
                        
                        self.mediaTypeCollection_View.reloadData()
                        
                        
                    }catch {
                        
                        print(error.localizedDescription)
                    }
                    
                    
                    
                    
                }else {
                    
                    self.ImageAndVideoListingData = nil
                    
                    self.top_View.isHidden = true
                    
                    self.topView_height.constant = 0
                    self.mediaTypeCollection_View.reloadData()
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
                
            }else {
                
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
            }
            
        }
    }
    // MARK: - Delete Media
    
    func deleteMedia(){
        
        Indicator.shared.showProgressView(self.view)
        let param = ["sender_id": self.user_id,
                     "media": self.mediaId] as [String: AnyObject]
        
        print(param)
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "delete_multimedia_data", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            
            print(receviedData)
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self?.showAlertWithAction(Title: "Unilife", Message: "Media Deleted Successfully", ButtonTitle: "Ok") {
                        
                        
                        self?.selectIndexArray = []
                        
                        self?.mediaUrl = []
                        self?.mediaId = []
                        
                        if self?.mediaType == "image"{
                            
                            self?.ImageAndVideoListingData(message_type: "image")
                            
                        }else if self?.mediaType == "document"{
                            
                            self?.ImageAndVideoListingData(message_type: "document")
                        }
                        else {
                            
                            self?.ImageAndVideoListingData(message_type: "video")
                        }
                    }
                    
                    
                }else {
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
                
            }
            
            
        }
    }
    
    
    // MARK: - DownLoad Media in phone memmory
    
    
    func downloadMedia(mediaUrl: String){
        let urlString = chatUrl + mediaUrl
        
        let url = URL(string: urlString)
        let fileName = String((url!.lastPathComponent)) as NSString
        // Create destination URL
        
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
        
        let destinationFileUrl = documentsUrl.appendingPathComponent("\(fileName)")
        //Create URL to the source file you want to download
        let fileURL = URL(string: urlString)
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url:fileURL!)
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                    
                }
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                    do {
                        //Show UIActivityViewController to save the downloaded file
                        let contents  = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                        for indexx in 0..<contents.count {
                            if contents[indexx].lastPathComponent == destinationFileUrl.lastPathComponent {
                                let activityViewController = UIActivityViewController(activityItems: [contents[indexx]], applicationActivities: nil)
                                self.present(activityViewController, animated: true, completion: nil)
                            }
                        }
                    }
                    catch (let err) {
                        print("error: \(err)")
                        
                        self.showDefaultAlert(Message: "\(err)")
                    }
                } catch (let writeError) {
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                    
                    self.showDefaultAlert(Message: "Error creating a file \(destinationFileUrl) : \(writeError)")
                }
            } else {
                print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "")")
                
                self.showDefaultAlert(Message: "Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "")")
            }
        }
        task.resume()
    }
    
    
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
                
                
                guard let videoUrl = data.destinationURL else {
                    return
                }
                
                _ = try? Data(contentsOf: videoUrl)
                
                // print(videoData)
                
                //print(data.destinationURL!)
                
        }
    }
    
    func getSaveFileUrl(fileName: String) -> URL {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let nameUrl = URL(string: fileName)
        
        //  nameUrl.createFolder(folderName: BBAudioFolderName)
        
        let fileURL = documentsURL.appendingPathComponent((nameUrl?.lastPathComponent)!)
        
        NSLog(fileURL.absoluteString)
        
        return fileURL;
    }
    
    
}


