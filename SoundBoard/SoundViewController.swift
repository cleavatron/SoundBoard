//
//  SoundViewController.swift
//  SoundBoard
//
//  Created by Ahmad Fairiz on 27/11/2016.
//  Copyright © 2016 Recite Lab. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var audioURL: URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setupRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
    }
    
    func setupRecorder(){
        do{
            // Create audio session
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            // Create URL for audio file
            let basePath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            // Create settings
            var settings: [String : Any] = [:]
            settings[AVFormatIDKey] = kAudioFormatMPEG4AAC
            settings[AVSampleRateKey] = 44100
            settings[AVNumberOfChannelsKey] = 2
            
            // Create AudioRecorder object
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
        }catch let error as NSError{
            print(error)
        }
        
    }
    
    
    @IBAction func recordTapped(_ sender: Any) {
        
        if audioRecorder!.isRecording{
            // Stop the recording
            audioRecorder?.stop()
            
            // Change button title to Record
            recordButton.setTitle("Record", for: .normal)
            
            // Enable Play and Add Buttons
            playButton.isEnabled = true
            addButton.isEnabled = true
            
        }else{
            // Start the recording
            audioRecorder?.record()
            
            // Change button title to Stop
            recordButton.setTitle("Stop", for: .normal)
            
        }
    }

    @IBAction func addTapped(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sound = Sound(context: context)
        
        sound.name = nameTextField.text
        sound.audio = NSData(contentsOf: audioURL!)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func playTapped(_ sender: Any) {
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer?.play()
        }catch{
            print(error)
        }
    }
}
