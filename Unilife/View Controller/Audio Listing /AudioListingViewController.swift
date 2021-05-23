//
//  AudioListingViewController.swift
//  Unilife
//
//  Created by Apple on 28/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class AudioListingViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var selectAll_btn: UIButton!
    
    @IBOutlet weak var audioListing_TableView: UITableView!
    
    @IBOutlet weak var top_View: UIView!
    
    @IBOutlet weak var topView_height: NSLayoutConstraint!
    
    // MARK : - Variable
    
    var selectIndexArray = [Int]()
    
    var AudioListingModelData:AudioListingModel?
    
    var mediaId = [Int]()
    
    var mediaUrl = [String]()
    
    var type = ""
    var user_id = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.audioListing_TableView.delegate
            = self
        
        self.audioListing_TableView.dataSource = self
        
        if self.mediaUrl.count == 0 || self.mediaId.count == 0 {
            
        self.top_View.isHidden = true
            
        self.topView_height.constant = 0
            
        }else {
            self.top_View.isHidden = false
            
            self.topView_height.constant = 30
            
        }
       
    }
    
    deinit {
        print(#file)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Audio", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
        
        AudioListing()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
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
                
                  self.deleteAudioMedia()
                
            }
            
          
            
        }
        
    }
    
    
    //  MARK: - Button Action
    
    
    @IBAction func tapSelectAll_btn(_ sender: UIButton) {
        if self.selectAll_btn.currentImage == UIImage(named: "check-symbol") {
            
            self.selectAll_btn.setImage(UIImage(named: "checkBox"), for: .normal)
            
            self.selectIndexArray[sender.tag] = 0
            
            self.mediaUrl.remove(at: (self.mediaUrl.index(of: self.AudioListingModelData?[sender.tag].message ?? ""))!)
            
            self.mediaId.remove(at: (self.mediaId.index(of: self.AudioListingModelData?[sender.tag].id ?? 0))!)
            
            self.audioListing_TableView.reloadData()
            
        }else if self.selectAll_btn.currentImage == UIImage(named: "checkBox") {
            
            
            
            self.selectIndexArray[sender.tag] = 1
            self.selectAll_btn.setImage(UIImage(named: "check-symbol"), for: .normal)
            
            self.mediaUrl.append(self.AudioListingModelData?[sender.tag].message ?? "")
            
            self.mediaId.append(self.AudioListingModelData?[sender.tag].id ?? 0)
            
            self.audioListing_TableView.reloadData()
            
        }
        
        
    }
    
}

// MARK: - Table View Delegate And Data Source


extension AudioListingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.self.AudioListingModelData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.audioListing_TableView.dequeueReusableCell(withIdentifier: "AudioListingTableViewCell") as! AudioListingTableViewCell
        
        cell.audioName_lbl.text! = self.AudioListingModelData?[indexPath.row].message ?? ""
        
        cell.selectAudio_btn.tag = indexPath.row
        
        cell.selectAudio_btn.addTarget(self, action: #selector(selectAudio_btn(_:)), for: .touchUpInside)
        
        if selectIndexArray[indexPath.row] == 1 {
            
            cell.selectAudio_btn.setImage(UIImage(named: "check-symbol"), for: .normal)
            
            cell.backGround_View.backgroundColor = UIColor.appLightGreyColor
        }else {
            
            cell.selectAudio_btn.setImage(UIImage(named: "checkBox"), for: .normal)
            
            cell.backGround_View.backgroundColor = UIColor.white
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlayAudioFileUIViewCViewController") as! PlayAudioFileUIViewCViewController
        
        vc.audioUrlData = self.AudioListingModelData?[indexPath.row]
        
        vc.audioUrl = chatUrl + (self.AudioListingModelData?[indexPath.row].message ?? "")
        
    self.present(vc, animated: true, completion: nil)
    }
    
    
    @objc func selectAudio_btn(_ sender: UIButton) {
        
        if selectIndexArray[sender.tag] == 0 {
            
            self.mediaUrl.append(self.AudioListingModelData?[sender.tag].message ?? "")
            
            self.mediaId.append(self.AudioListingModelData?[sender.tag].id ?? 0)
            
            self.selectIndexArray[sender.tag] = 1
            
        }else if selectIndexArray[sender.tag] == 1 {
            
            self.mediaUrl.remove(at: (self.mediaUrl.index(of: self.AudioListingModelData?[sender.tag].message ?? ""))!)
            
            self.mediaId.remove(at: (self.mediaId.index(of: self.AudioListingModelData?[sender.tag].id ?? 0))!)
            
            self.selectIndexArray[sender.tag] = 0
            
        }
        
        if self.mediaUrl.count == 0 || self.mediaId.count == 0 {
            
            self.top_View.isHidden = true
            
            self.topView_height.constant = 0
            
        }else {
            
            self.top_View.isHidden = false
            
            self.topView_height.constant = 30
            
        }
        
        self.audioListing_TableView.reloadData()
    }
    
}

extension AudioListingViewController{
    
    func AudioListing() {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": self.user_id,"message_type": "audio", "type": self.type] as [String: AnyObject]
        
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
                        
                        self.AudioListingModelData = try JSONDecoder().decode(AudioListingModel.self, from: jsondata!)
                        
                        let count = self.AudioListingModelData?.count ?? 0
                        
                        for _ in 0..<count{
                            
                            self.selectIndexArray.append(0)
                        }
                        
                        self.audioListing_TableView.reloadData()
                        
                        
                    }catch {
                        
                        print(error.localizedDescription)
                    }
                    
                    
                    
                    
                }else {
                    
                    self.AudioListingModelData = nil
                    self.audioListing_TableView.reloadData()
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
                
            }else {
                
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
            }
            
        }
    }
    
    
    // MARK: - Delete Media
    
    func deleteAudioMedia(){
        
        Indicator.shared.showProgressView(self.view)
        let param = ["sender_id": self.user_id,
                     "media": self.mediaId,] as [String: AnyObject]
        
        print(param)
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "delete_multimedia_data", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            
            print(receviedData)
            guard let self = self else {
                return
            }
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self.showAlertWithAction(Title: "Unilife", Message: "Media Deleted Successfully", ButtonTitle: "Ok") {
                    
                    self.mediaId = []
                    self.selectIndexArray = []
                    self.mediaUrl = []
                    
                    self.AudioListing()
                        
                    }
                    
                    
                }else {
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
                
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
                    }
                } catch (let writeError) {
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                }
            } else {
                print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "")")
            }
        }
        task.resume()
    }
}
