//
//  VideoPlayer.swift
//  E-Doctor
//
//  Created by Golu on 11/12/18.
//  Copyright © 2018 Promatics. All rights reserved.
//

import Foundation
import UIKit
//import AVKit
import AVFoundation

class VideoView: UIView {
    
    // MARK:- Outlates
    
    @IBOutlet var content_view: UIView!
    @IBOutlet weak var videoView: BBPlayerView!
    @IBOutlet weak var play_btn: UIButton!
    @IBOutlet weak var retry_btn: UIButton!
    @IBOutlet weak var currentTime_lbl: UILabel!
    
    // MARK:- Variables
    
    var videoUrl: String?
    var cell: UICollectionViewCell?
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func commonInit(){
        
        Bundle.main.loadNibNamed("VideoView", owner: self, options: nil)
        addSubview(content_view)
        content_view.frame = self.bounds
        content_view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        content_view.clipsToBounds = false
        
        self.videoView.playerObserverDelegate = self
        self.play_btn.setImage(UIImage(named: "play_button"), for: .normal)
        self.retry_btn.isHidden = true
        
    }
    
    @IBAction func playPressed(_ sender: UIButton) {
        
        print(self.videoUrl ?? "")
        
        guard let url = self.videoUrl else {
            return
        }
        
        if(videoView?.player?.timeControlStatus == .playing){
            self.play_btn.setImage(UIImage(named: "play_button"), for: .normal)
            self.videoView.pause()
        }else if(videoView?.player?.timeControlStatus == .waitingToPlayAtSpecifiedRate){
            self.play_btn.setImage(UIImage(named: "play_button"), for: .normal)
            self.videoView.pause()
        }else if(videoView?.player?.timeControlStatus == .paused){
            self.play_btn.setImage(UIImage(named: "pause"), for: .normal)
            self.videoView.play()
        }else{
            switch self.videoView.playerStatus {
            case .failed:
                self.play_btn.setImage(UIImage(named: "pause"), for: .normal)
                self.startPlayer(with: url)
            case .unknown:
                self.play_btn.setImage(UIImage(named: "pause"), for: .normal)
                self.startPlayer(with: url)
            case .playing:
                self.play_btn.setImage(UIImage(named: "play_button"), for: .normal)
                self.videoView.pause()
            case .paused:
                self.play_btn.setImage(UIImage(named: "play_button"), for: .normal)
                self.videoView.pause()
            case .readyToPlay:
                self.play_btn.setImage(UIImage(named: "play_button"), for: .normal)
                self.videoView.pause()
            }
        }
    }
    
    @IBAction func tapRetryButton(_ sender: Any) {
        
    }
    
    private func startPlayer(with url: String) {
        self.play_btn.isHidden = true
        self.videoView.startAnimating()
        IGVideoCacheManager.shared.getFile(for: url) { (result) in
            switch result {
            case .success(let url):
                let videoResource = BBVideoResource(filePath: url.absoluteString)
                self.videoView.play(with: videoResource)
                self.play_btn.setImage(UIImage(named: "pause"), for: .normal)
                self.play_btn.isHidden = false
                self.retry_btn.isHidden = true
            case .failure(let error):
                self.videoView.stopAnimating()
                debugPrint("Video error: \(error)")
                self.play_btn.setImage(UIImage(named: "play_button"), for: .normal)
                self.play_btn.isHidden = true
                self.retry_btn.isHidden = false
            }
        }
    }
}

// MARK:- Extension BBPlayerObserver Delegates

extension VideoView: BBPlayerObserver {
    
    func didStartPlaying() {
        print("Player started")
        self.play_btn.setImage(UIImage(named: "pause"), for: .normal)
        self.play_btn.isHidden = false
        self.retry_btn.isHidden = true
    }
    
    func didCompletePlay() {
        print("Player completed")
        self.play_btn.setImage(UIImage(named: "play_button"), for: .normal)
        self.play_btn.isHidden = false
        self.retry_btn.isHidden = true
        self.videoView.stop()
        self.videoView.player = nil
    }
    
    func didTrack(progress: Float) {
        self.currentTime_lbl.text = "\(progress.rounded())"
        
        if let colCell = self.cell as? SeePostCollectionViewCell {
            //            if let parent = colCell.viewContainingController() as? MyFeedViewController {
            //
            //                print("MyFeedViewController")
            //
            //            }else if let parent = colCell.viewContainingController() as? FeedViewController {
            //
            //                print("FeedViewController")
            //
            //            }else if let parent = colCell.viewContainingController() as? BubblesFeedViewController {
            //
            //                print("BubblesFeedViewController")
            //            }
        }
    }
    
    func didFailed(withError error: String, for url: URL?) {
        debugPrint("Failed with error: \(error)")
        self.play_btn.setImage(UIImage(named: "play_button"), for: .normal)
        self.play_btn.isHidden = true
        self.retry_btn.isHidden = false
    }
}

