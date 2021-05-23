//
//  PlayAudioFileUIViewCViewController.swift
//  Unilife
//
//  Created by Apple on 27/11/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit
import AVFoundation
import AudioPlayerManager
import MediaPlayer

class PlayAudioFileUIViewCViewController: UIViewController,AVAudioPlayerDelegate {
    
    // MARK: - Variable
    
    var audioPlayer = AVAudioPlayer()
    var isPlaying = false
    var timer:Timer!
    var audioUrl = ""
    var audioUrlData: AudioListingModelElement?
    
    // MARK: - outlet
    
    @IBOutlet weak var play_button: UIButton!
    
    @IBOutlet weak var playSlider_btn: UISlider!
    
    @IBOutlet weak var time_lbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playSlider_btn?.value = 0
        self.playSlider_btn?.maximumValue = 1.0
        self.time_lbl?.text = "-:-"
        audioPlayer.volume = 1
        // self.updateButtonStates()
        
        // Listen to the player state updates. This state is updated if the play, pause or queue state changed.
        AudioPlayerManager.shared.addPlayStateChangeCallback(self, callback: { [weak self] (track: AudioTrack?) in
            
            self?.updateButtonStates()
            //            self?.updateSongInformation(with: track)
        })
        
        //         Listen to the playback time changed. Thirs event occurs every `AudioPlayerManager.PlayingTimeRefreshRate` seconds.
        
        AudioPlayerManager.shared.addPlaybackTimeChangeCallback(self, callback: { [weak self] (track: AudioTrack?) in
            
            self?.updatePlaybackTime(track)
        })
        
        let url = URL(string: audioUrl)
        self.time_lbl.text =  "\(self.getAudioDuration(for: url!))"
        
    }
    
    // MARK: - Button Action
    
    @IBAction func tapPlay_btn(_ sender: Any) {
        
        let url = URL(string: audioUrl)
        
        // downloadFileFromURL(url: url!)
        // play(url: url as! NSURL)
        
        if AudioPlayerManager.shared.isPlaying(url: url!){
            
            AudioPlayerManager.shared.pause()
            
            self.play_button.setImage(UIImage(named: "pauseButton_WhiteTheme"), for: .normal)
            
            
        }else{
            
            AudioPlayerManager.shared.play(url: url!)
            
            self.play_button.setImage(UIImage(named: "pauseButton_WhiteTheme"), for: .normal)
            
        }
        
    }
    
    func getAudioDuration(for resource: URL) -> String {
        return  ReuseableFunctions.displayableString(from : (TimeInterval(exactly: (Float(CMTimeGetSeconds(AVURLAsset(url: resource).duration))))!))
    }
    
    
    func updateButtonStates() {
        
        
        let imageName = (AudioPlayerManager.shared.isPlaying() == true ? "pauseButton_WhiteTheme" :  "playButton_WhiteTheme")
        
        self.play_button?.setImage(UIImage(named: imageName), for: UIControl.State())
        self.play_button?.isEnabled = AudioPlayerManager.shared.canPlay()
        
    }
    
    func updatePlaybackTime(_ track: AudioTrack?) {
        self.time_lbl?.text = track?.displayablePlaybackTimeString() ?? "-:-"
        // self.trackDurationLabel?.text = track?.displayableDurationString() ?? "-:-"
        self.playSlider_btn?.value = track?.currentProgress() ?? 0
    }
    
    
    @IBAction func tapCross_btn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func didChangeTimeSliderValue(_ sender: Any) {
        guard let newProgress = self.playSlider_btn?.value else {
            return
        }
        
        AudioPlayerManager.shared.seek(toProgress: newProgress)
    }
    
    
    
}
