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
        try! session.setCategory(AVAudioSessionCategoryPlayback)
        
        audioFile = try! AVAudioFile(forReading: recordedAudio.filePathUrl)
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: recordedAudio.filePathUrl, fileTypeHint: nil)
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
        playAudioWithVariableSpeed(0.5)
    }

    @IBAction func didTapRabbitButton(sender: UIButton) {
        playAudioWithVariableSpeed(2.0)
    }
    
    @IBAction func didTapChipmunk(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func didTapDarthvader(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
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
        audioEngine!.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine!.attachNode(changePitchEffect)
        
        audioEngine!.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine!.connect(changePitchEffect, to: audioEngine!.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile!, atTime: nil, completionHandler: nil)
        try! audioEngine!.start()
        
        audioPlayerNode.play()
    }
    
    func stopSoundAndReset() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
}
