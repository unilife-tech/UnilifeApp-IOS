//
//  ChatTableViewCell.swift
//  Unilife
//
//  Created by Apple on 29/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit
import AVKit
import AudioPlayerManager
import AVKit

protocol ChatcellDelegate: class {
    func didTapAudioPlayButton( cell: ChatTableViewCell)
    func didChangeTimeSliderValue(_ sender: UISlider)
}

extension ChatcellDelegate{
  
    func didTapAudioPlayButton( cell: ChatTableViewCell){}
    
}

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var receviedMessageUserImage_View: CircleImage!
    
    @IBOutlet weak var receviedMessage_lbl: UILabel!
    
    @IBOutlet weak var receviedMessageTime_lbl: UILabel!
    
    @IBOutlet weak var receviedMessage_View: UIViewShadow!

    @IBOutlet weak var sendMessageUserImage_View: CircleImage!
    
    @IBOutlet weak var sendMessageUser_lbl: UILabel!
    
    @IBOutlet weak var sendMessageTime_lbl: UILabel!
    
    @IBOutlet weak var sendUserImage_View: SetImage!
    
    @IBOutlet weak var receviedImage_View: SetImage!
    
    @IBOutlet weak var senderAudioPlay_btn: UIButton!
    
    @IBOutlet weak var senderAudio_Slider: UISlider!
    
    @IBOutlet weak var senderAudioTime_lbl: UILabel!
    
    @IBOutlet weak var receviedAudioPlay_btn: UIButton!
    
    @IBOutlet weak var receviedAudio_Slider: UISlider!
    
    @IBOutlet weak var receviedAudioTime_lbl: UILabel!

    @IBOutlet weak var openMediaType_btn: UIButton!
    
    @IBOutlet weak var replyImage_View: UIImageView!
    
    @IBOutlet weak var reply_lbl: UILabel!
    
    @IBOutlet weak var reply_View: UIView!
    
    @IBOutlet weak var replyView_height: NSLayoutConstraint!
    
    @IBOutlet weak var replyImageView_width: NSLayoutConstraint!
    
    @IBOutlet weak var userName_lbl: UILabel!
    
    @IBOutlet weak var receviedImageViewReceiver_Height: NSLayoutConstraint!
    
    @IBOutlet weak var imgVideoBackground: UIImageView!
    
    // MARK: - Variable
    
    var player: AVPlayer? = nil
    
    weak var delegate : ChatcellDelegate?
    
    var cellType = ""
    
    var recevierImage = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var chatListElement:(Chat)?{
    
        didSet{
            
        setData()
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    private func setData(){
        
        guard let chatData = self.chatListElement else {
            
           return
        }
        
        if cellType == "sender" {
       // self.sendMessageUserImage_View.sd_setImage(with: URL(string: profileImageUrl + UserData().image), placeholderImage: UIImage(named: "noimage_icon"))
            
        }else {
            
      //  self.sendMessageUserImage_View.sd_setImage(with: URL(string: profileImageUrl + self.recevierImage), placeholderImage: UIImage(named: "noimage_icon"))
            
        }
        
        if chatData.messageType == "audio" {
            
            self.sendMessageTime_lbl.text!  = timeFormatChange(date: chatData.createdAt ?? "")
            
            if let url = BBVideoCacheManager.shared.getFileIfLocallyExists(for: chatUrl + (chatData.message ?? "")) {
                
            self.senderAudioTime_lbl.text! = "\(self.getAudioDuration(for: url))"
            }else {
                
              self.senderAudioTime_lbl.text! =  "___"
                
            }
            
           
            let imageName = ((chatData.isPlaying == true) ? "pauseButton_WhiteTheme" :  "playButton_WhiteTheme")
            
            self.senderAudioPlay_btn.setImage(UIImage(named: imageName), for: UIControl.State())
            
            self.senderAudio_Slider.value = Float(chatData.currentDuration)
            
        
            
            
        }
      
    }
    
    
    // Get total duration of audio of previously downloaded files
    
    func getAudioDuration(for resource: URL) -> String {
        return  ReuseableFunctions.displayableString(from : (TimeInterval(exactly: (Float(CMTimeGetSeconds(AVURLAsset(url: resource).duration))))!))
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
    
    
    
    @IBAction func changeSliderValue(_ sender: UISlider) {
        
        self.delegate?.didChangeTimeSliderValue(sender)
    }
    
    
    @IBAction func didTapAudioPlayButton(_ sender: Any) {
        
        self.delegate?.didTapAudioPlayButton(cell: self)
    }
    

}





