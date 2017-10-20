//
//  PracticeViewController.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 11/10/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.
//

import Foundation
import UIKit
import AudioKit

protocol PracticeViewControllerDelegate {
    func setRandomChordTime(newTime: Int)
    func getRandomChordTime() -> Int
    func resetScore()
}

class PracticeViewController: UITableViewController, PracticeViewControllerDelegate, MicrophoneTrackerDelegate {

    var timerConstantPredictIndicator: Timer?
    var timerRandomChord: Timer?
    var timerDisplayResultAnalysis: Timer?
    var remainingTime = 0.0
    var mic:MicrophoneTracker!
    var trackedAmplitude:Double = 0
    var trackedFrequency:Double = 0
    var trackedSamples = [Float]()
    var samplesBufferSize = 0
    var recordingAudio = false
    var currentChord:Chord?
    var randomChordTime = 20
    var remainingTimeChord = 20
    var score:Int = 0
    var currentChordImageIndex:Int = 0
    
    @IBOutlet var microphoneVolumeProgressView:UIProgressView?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var constantPredictIndicator: UIActivityIndicatorView!
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var wrongLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var changingTimeLabel: UILabel!
    @IBOutlet var backgroundView: UITableView!
    @IBOutlet weak var previousImageButton: UIButton!
    @IBOutlet weak var nextImageButton: UIButton!
    
    override func viewDidLoad() {
        correctLabel.isHidden = true
        wrongLabel.isHidden = true
        score = 0
        generateNewRandomChord()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        MicrophoneTracker.microphone.delegate = self
//        MicrophoneTracker.microphone.start()
//        backgroundView.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        mic = MicrophoneTracker()
        mic.delegate = self
        mic.start()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let view = segue.destination as! PracticeSettingsTableViewController
        view.delegate = self
    }
    
    func countDownChord(){
        DispatchQueue.main.async() {
            if self.remainingTimeChord == 0 {
                self.generateNewRandomChord()
            } else {
                self.remainingTimeChord = self.remainingTimeChord - 1
                self.changingTimeLabel.text = String(self.remainingTimeChord)
                self.timerRandomChord = Timer.scheduledTimer(timeInterval: 1,
                                                             target: self,
                                                             selector: #selector(self.countDownChord),
                                                             userInfo: nil,
                                                             repeats: false)
            }
        }
    }
    
    override func viewDidAppear(_ animated:Bool){
        constantPredictIndicator.isHidden = true
        constantPredictIndicator.stopAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        MicrophoneTracker.microphone.stop()
        mic.stop()
    }
    
    func microphoneTracker(trackedSamples: [Float], samplesBufferSize: Int, trackedFrequency:Double, trackedAmplitude:Double) {
        DispatchQueue.main.async() {
            self.trackedSamples = trackedSamples
            self.trackedAmplitude = trackedAmplitude
            self.trackedFrequency = trackedFrequency
            self.samplesBufferSize = samplesBufferSize
            self.setMicrophoneVolume()
            if self.recordingAudio == false {
                self.constantPredict()
                
            }
        }
    }
    
    func constantPredict() {
        if self.trackedAmplitude < 0.15 || self.recordingAudio {
            return
        }
        constantPredictIndicator.isHidden = false
        constantPredictIndicator.startAnimating()
        remainingTime = 1
        timerConstantPredictIndicator = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                                             selector: #selector(self.countDown),
                                                             userInfo: nil,
                                                             repeats: true)
        self.recordingAudio = true
        let json: [String: Any] = ["sample": self.trackedSamples]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let urlAdressAppendFftData = "http://" + ServerExchange.urlAddress + "/api/predict/"
        let url = URL(string: urlAdressAppendFftData)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        if let printData = jsonData {
            request.httpBody = printData
        } else {
            return
        }
        
        session.dataTask(with: request, completionHandler:
            { data, response, error in
                
                if error != nil {
                    print ("Error: \(error)")
                    return
                }
                print ("****** response = \(response)")
                if let content = data {
                    do {
                        let JsonData = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers ) as! NSDictionary
                        
                        if let predictedChord = JsonData["predicted_class"] as? Int {
                            DispatchQueue.main.async() {
                                self.checkResult(predictedChord as Int)
                                print(predictedChord)
                            }
                        }
                    } catch {}
                }
                    
                //Read the JSON
                if let postString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as? String {
                    print("POST:\(postString)")
                    
                }
        }).resume()
    }
    
    func checkResult(_ predictedChord:Int) {
        resetLabels()
        if predictedChord == self.currentChord?.chordNumber {
            self.correctLabel.isHidden = false
            self.score = score + 1
            self.generateNewRandomChord()
        } else {
            self.wrongLabel.isHidden = false
        }
        self.timerDisplayResultAnalysis = Timer.scheduledTimer(timeInterval: 4,
                                                     target: self,
                                                     selector: #selector(self.resetLabels),
                                                     userInfo: nil,
                                                     repeats: false)
    }
    
    func resetLabels() {
        correctLabel.isHidden = true
        wrongLabel.isHidden = true
    }
    
    func setMicrophoneVolume() {
        var microphoneVolume = self.trackedAmplitude * 10
        if (microphoneVolume > 1) { microphoneVolume = 1}
        self.microphoneVolumeProgressView?.progress = Float(microphoneVolume)
//        let redColor = Int((self.trackedAmplitude * 1000) + 50)
//        let greenColor = Int((self.trackedAmplitude * 1000) + 50)
//        print(self.trackedAmplitude)
//        backgroundView.backgroundColor = UIColor(red: CGFloat(redColor), green: CGFloat(greenColor), blue: 255, alpha: 1)
    }
    
    func countDown() {
        self.remainingTime -= 0.1
        if (self.remainingTime < 0) {
            constantPredictIndicator.stopAnimating()
            constantPredictIndicator.isHidden = true
            self.timerConstantPredictIndicator?.invalidate()
            self.timerConstantPredictIndicator = nil
            recordingAudio = false
        }
    }
    
    func generateNewRandomChord(){
        self.scoreLabel.text = String(score)
        let randomNumber = arc4random_uniform(48)
        remainingTimeChord = randomChordTime
        changingTimeLabel.text = String(remainingTimeChord)
        self.timerRandomChord?.invalidate()
        for chord in Chord.chords {
            if chord.chordNumber == randomNumber {
                self.currentChord = chord
                self.updateImages()
                break
            }
        }
        self.timerRandomChord = Timer.scheduledTimer(timeInterval: 1,
                                                     target: self,
                                                     selector: #selector(self.countDownChord),
                                                     userInfo: nil,
                                                     repeats: false)
    }
    
    func updateImages(){
        self.currentChordImageIndex = 0
        self.updateButtonsColor()
        self.setChordImage(index: self.currentChordImageIndex)
    }
    
    func updateButtonsColor(){
        previousImageButton.tintColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        nextImageButton.tintColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        if currentChordImageIndex == 0 {
            previousImageButton.tintColor = UIColor.lightGray
        }
        if currentChordImageIndex == (currentChord!.numOfImages - 1) {
            nextImageButton.tintColor = UIColor.lightGray
        }
    }
    
    func setChordImage(index:Int) {
        imageView.image = UIImage(named: self.currentChord!.image[index])
    }
    
    func setRandomChordTime(newTime: Int){
        self.randomChordTime = newTime
        self.resetScore()
    }
    
    func resetScore(){
        self.score = 0
        generateNewRandomChord()
    }
    
    func getRandomChordTime() -> Int{
        return self.randomChordTime
    }
    
    @IBAction func previousImageButtonPressed(_ sender: Any) {
        if currentChordImageIndex == 0 {
            return
        }
        currentChordImageIndex = currentChordImageIndex - 1
        setChordImage(index:currentChordImageIndex)
        updateButtonsColor()
    }
    
    @IBAction func nextImageButtonPressed(_ sender: Any) {
        print(currentChord!.numOfImages)
        if currentChordImageIndex == (currentChord!.numOfImages - 1) {
            return
        }
        currentChordImageIndex = currentChordImageIndex + 1
        setChordImage(index:currentChordImageIndex)
        updateButtonsColor()
    }
}
