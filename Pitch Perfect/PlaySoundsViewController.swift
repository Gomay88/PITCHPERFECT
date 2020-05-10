//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Victor Jimenez on 1/24/16.
//  Copyright © 2016 Victor Jimenez. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var audioPitch: AVAudioUnitTimePitch!
    
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = AVAudioPlayer()
        audioEngine = AVAudioEngine()
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playback)
        
        audioFile = try! AVAudioFile(forReading: recordedAudio.filePathUrl)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recordedAudio.filePathUrl, fileTypeHint: nil)
            audioPlayer.enableRate = true
        } catch {
            print("There was a problem with the audioPlayer")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapSnailButton(sender: UIButton) {
        playAudioWithVariableSpeed(speed: 0.5)
    }

    @IBAction func didTapRabbitButton(sender: UIButton) {
        playAudioWithVariableSpeed(speed: 2.0)
    }
    
    @IBAction func didTapChipmunk(sender: UIButton) {
        playAudioWithVariablePitch(pitch: 1000)
    }
    
    @IBAction func didTapDarthvader(sender: UIButton) {
        playAudioWithVariablePitch(pitch: -1000)
    }
    
    @IBAction func didTapStop(sender: UIButton) {
        audioPlayer.stop()
    }
    
    func playAudioWithVariableSpeed(speed: Float) {
        stopSoundAndReset()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = speed
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        stopSoundAndReset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine!.attach(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine!.attach(changePitchEffect)
        
        audioEngine!.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine!.connect(changePitchEffect, to: audioEngine!.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile!, at: nil, completionHandler: nil)
        try! audioEngine!.start()
        
        audioPlayerNode.play()
    }
    
    func stopSoundAndReset() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
}
