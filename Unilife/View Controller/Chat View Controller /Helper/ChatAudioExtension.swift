//
//  ChatAudioExtension.swift
//  Unilife
//
//  Created by Apple on 11/11/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import Foundation
import MediaPlayer
import AudioPlayerManager
import Alamofire

struct LastPalyedAudio {
    
    var url: String
    var indexPath: IndexPath
    
}

extension ChatViewController{
    
    func setupAudioPlayer() {
        ///....audio check by error
        // Listen to the player state updates. This state is updated if the play, pause or queue state changed.
        AudioPlayerManager.shared.addPlayStateChangeCallback(self, callback: { [weak self] (track: AudioTrack?) in
            
            self?.upadteButtonState()
            
        })
 //        Listen to the playback time changed. Thirs event occurs every `AudioPlayerManager.PlayingTimeRefreshRate` seconds.
        AudioPlayerManager.shared.addPlaybackTimeChangeCallback(self, callback: { [weak self] (track: AudioTrack?) in

          self?.updatePlaybackTime(track)
        })
        
    }
    
    func removeAudioPlayerState() {
        
        // Stop listening to the callbacks
        AudioPlayerManager.shared.removePlayStateChangeCallback(self)
        AudioPlayerManager.shared.removePlaybackTimeChangeCallback(self)
        AudioPlayerManager.shared.stop(clearQueue: true)
        
    }
    
    func upadteButtonState() {
        
        if let indexPath = self.lastPalyedAudio?.indexPath{
            
            let imageName = ((AudioPlayerManager.shared.isPlaying() == true) ?  "pauseButton_WhiteTheme" : "playButton_WhiteTheme" )
            
          //  print(AudioPlayerManager.shared.isPlaying())
            
            DispatchQueue.main.async {
                
                if let cell = self.chat_TableView.cellForRow(at: indexPath) as? ChatTableViewCell {
                self.chatTupleList[indexPath.section].value[indexPath.row].isPlaying = AudioPlayerManager.shared.canPlay()
                    
                    cell.senderAudioPlay_btn.setImage(UIImage(named: imageName), for: UIControl.State())
                    cell.senderAudioPlay_btn.isEnabled = AudioPlayerManager.shared.canPlay()
                    
                }
                
            }
            
        }
        
    }
    
    func updatePlaybackTime(_ track: AudioTrack?) {
        
        if let indexPath = self.lastPalyedAudio?.indexPath{
            
            DispatchQueue.main.async {
                
                if let cell = self.chat_TableView.cellForRow(at: indexPath) as? ChatTableViewCell {
                     self.chatTupleList[indexPath.section].value[indexPath.row].isPlaying = true
                    self.chatTupleList[indexPath.section].value[indexPath.row].currentDuration = Double(track?.currentProgress() ?? 0.0)
                    
                    cell.senderAudioTime_lbl.text = track?.displayableDurationString() ?? "-:-"
                    cell.senderAudio_Slider.value = track?.currentProgress() ?? 0
                    
                    //cell.senderAudioPlay_btn.setImage(UIImage(named: "playButton_WhiteTheme"), for: .normal)
                    
                }
                
            }
            
            
        }
        
        
    }
    
}

extension ChatViewController: ChatcellDelegate {
    //
    func didTapAudioPlayButton(cell: ChatTableViewCell) {
       // print("------0")
        if let newRequestedIndexPath = self.chat_TableView.indexPath(for: cell) {
           // print("------1")
            if lastPalyedAudio?.indexPath == newRequestedIndexPath {
               // print("------2")
                AudioPlayerManager.shared.togglePlayPause()
                self.chatTupleList[newRequestedIndexPath.section].value[newRequestedIndexPath.row].isPlaying = AudioPlayerManager.shared.isPlaying()
                
            }else {
               // print("------3")
                // Change the last played index current duration to zero
                if let indexPathForLastPayer = self.lastPalyedAudio?.indexPath {
                  //  print("------4")
                    self.chatTupleList[indexPathForLastPayer.section].value[indexPathForLastPayer.row].isPlaying = false
                    
                    self.chatTupleList[indexPathForLastPayer.section].value[indexPathForLastPayer.row].currentDuration = 0.0
                    
                    // cell.senderAudioPlay_btn.setImage(UIImage(named: "playButton_WhiteTheme"), for: .normal)
                    
                  self.chat_TableView.reloadRows(at: [IndexPath(row: indexPathForLastPayer.row, section: indexPathForLastPayer.section)], with: .none)
                    
                }
                
                // Change new playable cell values
                //print("------5")
                
                if let cell = self.chat_TableView.cellForRow(at: newRequestedIndexPath) as? ChatTableViewCell {
                    
                //print("------6")
                    
                    self.chatTupleList[newRequestedIndexPath.section].value[newRequestedIndexPath.row].isPlaying = true
                    
                    self.chatTupleList[newRequestedIndexPath.section].value[newRequestedIndexPath.row].currentDuration = 0.0
                    
                  //  cell.senderAudioPlay_btn.setImage(UIImage(named: "playButton_WhiteTheme"), for: .normal)
                    
                    cell.senderAudio_Slider.value = 0
                    
                }
                
                
                // Initializing new payer index
                
                self.lastPalyedAudio = LastPalyedAudio(url:  (self.chatTupleList[newRequestedIndexPath.section].value[newRequestedIndexPath.row].message ?? ""), indexPath: newRequestedIndexPath)
                
                
                
                BBVideoCacheManager.shared.getFile(for: chatUrl + ( self.chatTupleList[newRequestedIndexPath.section].value[newRequestedIndexPath.row].message ?? ""), vc: self) { (result) in
                   // print("------7")
                    switch result {
                    case .success(let url):
                     //   print("------8")
                        AudioPlayerManager.shared.play(urlString: url.absoluteString)
                        
                    case .failure(_):
                        
                        DispatchQueue.main.async(execute: {
                            self.showToast(message: "Can't play audio")
                        })
                    }
                    
                }
                
            }
            
        }
        
        
    }
    
    
    
    func didChangeTimeSliderValue(_ sender: UISlider) {
        
        
        AudioPlayerManager.shared.seek(toProgress: sender.value)
    }
    
}

