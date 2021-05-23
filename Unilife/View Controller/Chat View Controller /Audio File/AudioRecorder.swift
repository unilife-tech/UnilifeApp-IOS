//
//  AudioRecorder.swift
//  E-Doctor
//
//  Created by Sourabh Mittal on 22/01/19.
//  Copyright © 2019 Promatics. All rights reserved.
//

import Foundation
import AVFoundation

protocol AudioRecorder {
    func checkPermission(completion: ((Bool) -> Void)?)
    
    /// if url is nil audio will be stored to default url
    func record(to url: URL?)
    func stopRecording()
    
    /// if url is nil audio will be played from default url
    func play(from url: URL?)
    func stopPlaying()
    
    func pause()
    func resume()
}

final class AudioRecorderImpl: NSObject, AudioRecorder {
    private let session = AVAudioSession.sharedInstance()
    private var player: AVAudioPlayer?
    private var recorder: AVAudioRecorder?
    private lazy var permissionGranted = false
    private lazy var isRecording = false
    private lazy var isPlaying = false
    private var fileURL: URL?
    private let settings = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 44100,
        AVNumberOfChannelsKey: 2,
        AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
    ]
    
    override init() {
        fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("note.m4a")
    }
    
    func record(to url: URL?) {
        guard permissionGranted,
            let url = url ?? fileURL else { return }
        
        setupRecorder(url: url)
        
        if isRecording {
            stopRecording()
        }
        
        isRecording = true
        recorder?.record()
    }
    
    func stopRecording() {
        isRecording = false
        recorder?.stop()
        try? session.setActive(false)
    }
    
    func audioUrl() -> URL{
        
        return self.fileURL!
    }
    
    func play(from url: URL?) {
        guard let url = url ?? fileURL else { return }
        
        setupPlayer(url: url)
        
        if isRecording {
            stopRecording()
        }
        
        if isPlaying {
            stopPlaying()
        }
        
        if FileManager.default.fileExists(atPath: url.path) {
            isPlaying = true
            setupPlayer(url: url)
            player?.play()
        }
    }
    
    func stopPlaying() {
        player?.stop()
    }
    
    func pause() {
        player?.pause()
    }
    
    func resume() {
        if player?.isPlaying == false {
            player?.play()
        }
    }
    
    func checkPermission(completion: ((Bool) -> Void)?) {
        func assignAndInvokeCallback(_ granted: Bool) {
            self.permissionGranted = granted
            completion?(granted)
        }
        
        switch session.recordPermission {
        case .granted:
            assignAndInvokeCallback(true)
            
        case .denied:
            assignAndInvokeCallback(false)
            
        case .undetermined:
            session.requestRecordPermission(assignAndInvokeCallback)
        }
    }
}

extension AudioRecorderImpl: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
}

private extension AudioRecorderImpl {
    func setupRecorder(url: URL) {
        guard
            permissionGranted else { return }
        try? session.setCategory(.playback, mode: .default)
        try? session.setActive(true)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        recorder = try? AVAudioRecorder(url: url, settings: settings)
        recorder?.delegate = self
        recorder?.isMeteringEnabled = true
        recorder?.prepareToRecord()
    }
    
    func setupPlayer(url: URL) {
        player = try? AVAudioPlayer(contentsOf: url)
        player?.delegate = self
        player?.prepareToPlay()
    }
}
