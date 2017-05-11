//
//  TrainModelViewController.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 10/04/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.
//

import Foundation
import UIKit
import AudioKit

class TrainModelViewController: UIViewController {
    
    //************ STORYBOARD's COMPONENTS **************//
    
    @IBOutlet weak var currentServerLabel: UILabel!
    
    @IBOutlet weak var serverStatusLabel: UILabel!
    
    @IBOutlet weak var trainingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var constantTrainingSwitch: UISwitch!
    
    @IBOutlet weak var serverAdressTextBox: UITextField!
    
    @IBAction func changeServerClicked(_ sender: Any) {
        
        if serverAdressTextBox.text != "" {
            ServerExchange.setServerUrl(serverAdressTextBox.text!);
            currentServerLabel.text = serverAdressTextBox.text!
        }
        
    }
    
    //******* OTHER VARS ******//
    
    static var urlAddress:String = "localhost:8001"
    
    var chordType = 1 {
        didSet{
            chordSelectedLabel.text = String(chordType)
        }
        
    }
    
    fileprivate var timerCheckServerStatus: Timer?
    fileprivate var timerConstantTraining: Timer?
    fileprivate var timerConstantTrainingIndicator: Timer?
    var remainingTime = 0

    
    
    /************* VIEW's APPEAR AND DISAPPEAR FUNCTIONS **********/
    
    override func viewWillAppear(_ animated: Bool) {
        constantTrainingSwitch.isOn = false
        
        trainingIndicator.stopAnimating()
        trainingIndicator.isHidden = true
        
        
        constantTrainingSwitch.addTarget(self, action: "switchIsChanged:", for: UIControlEvents.valueChanged)
        
        
        let serverIsOn = ServerExchange.CheckServerStatus()
        
        if serverIsOn == false {
            serverStatusLabel.text = "Disconnected"
            serverStatusLabel.textColor = UIColor.red
            return
        }
        
        serverStatusLabel.text = "Connected"
        serverStatusLabel.textColor = UIColor.green
        
        timerCheckServerStatus = Timer.scheduledTimer(timeInterval: 10, target: self,
                                                      selector: #selector(checkServerStatus),
                                                      userInfo: nil,
                                                      repeats: true)
        
        currentServerLabel.text = TrainModelViewController.urlAddress
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timerConstantTrainingIndicator?.invalidate()
        self.timerConstantTrainingIndicator = nil
        self.timerCheckServerStatus?.invalidate()
        self.timerCheckServerStatus = nil
        
    }
    
    
    /********************** CONSTANT TRAINING **************************/

    
    func constantTraining() {
        
        if ChromaticViewController.tuner.tracker.amplitude < 0.1 {
            return
        }
        
        trainingIndicator.isHidden = false
        trainingIndicator.startAnimating()
        remainingTime = 1
        timerConstantTrainingIndicator = Timer.scheduledTimer(timeInterval: 1, target: self,
                                                      selector: #selector(self.countDown),
                                                      userInfo: nil,
                                                      repeats: true)
        
        let newFftData = Array((0 ... 511).map {
            
            index -> Int in
            let tempArray = (ChromaticViewController.tuner.fft.fftData[index] * (pow(10,16)))
            return ( Int(tempArray))
            
        })
        
        let json: [String: Any] = ["chordType": chordType,
                                   "fftData": newFftData]
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        if let printData = jsonData {
            print (printData)
        }
        
        let urlAdressAppendFftData = "http://" + TrainModelViewController.urlAddress + "/api/appendToCachedFftData/"
        
        
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
                    let alert = UIAlertController(title: "Server error", message: "Error \(error)", preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    print ("Error: \(error)")
                    return
                }
                
                print ("****** response = \(response)")
                
                //Read the JSON
                if let postString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as? String {
                    print("POST:\(postString)")
                }
                
        }).resume()
        
        
    }
    
    /********************** SYNC CACHED DATA WITH MAIN DATA **************************/

    
    @IBAction func syncCachedWithMainClicked (_ sender: UIButton) {
        
        let json: [String: Any] = ["messageType": "syncCachedDataWithMainData"]
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        if let printData = jsonData {
            print (printData)
        }
        
        let urlAdressClearCachedData = "http://" + TrainModelViewController.urlAddress + "/api/syncCachedDataWithMainData/"
        
        let url = URL(string: urlAdressClearCachedData)
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
                    let alert = UIAlertController(title: "Server error", message: "Error \(error)", preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    print ("Error: \(error)")
                    return
                }
                
                print ("****** response = \(response)")
                
                //Read the JSON
                if let postString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as? String {
                    print("POST:\(postString)")
                }
                
        }).resume()
        
    }
    
    /********************** TRAIN BY CLICKING **************************/

    
    @IBAction func sendFftDataCliecked(_ sender: UIButton) {

        print (ChromaticViewController.tuner.fft.fftData)
        
        let newFftData = Array((0 ... 511).map {
            
            index -> Int in
            let tempArray = (ChromaticViewController.tuner.fft.fftData[index] * (pow(10,16)))
            return ( Int(tempArray))
            
        })
        
        
        
        print (newFftData)
        
        // prepare json data
        
        let json: [String: Any] = ["chordType": chordType,
                                   "fftData": newFftData]
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        if let printData = jsonData {
            print (printData)
        }
        
        let urlAdressAppendFftData = "http://" + TrainModelViewController.urlAddress + "/api/appendToCachedFftData/"
        
        
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
                    let alert = UIAlertController(title: "Server error", message: "Error \(error)", preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    print ("Error: \(error)")
                    return
                }
                
                print ("****** response = \(response)")
                
                //Read the JSON
                if let postString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as? String {
                    print("POST:\(postString)")
                }
                
        }).resume()
    }
    
    
    /********************** CLEAR CACHED DATA **************************/
    
    @IBAction func clearCachedDataClicked(_ sender: UIButton) {
        
        let json: [String: Any] = ["messageType": "clearCachedData"]
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        if let printData = jsonData {
            print (printData)
        }
        
        let urlAdressClearCachedData = "http://" + TrainModelViewController.urlAddress + "/api/clearCachedFftData/"
        
        let url = URL(string: urlAdressClearCachedData)
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
                    let alert = UIAlertController(title: "Server error", message: "Error \(error)", preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    print ("Error: \(error)")
                    return
                }
                
                print ("****** response = \(response)")
                
                //Read the JSON
                if let postString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as? String {
                    print("POST:\(postString)")
                }
                
        }).resume()
        
    }
    
    /************************** MISC BUTTONS ***************************/
    
    @IBAction func chord1Clicked(_ sender: UIButton) {
        
        chordType = 1
        
    }
    
    @IBAction func chord2Clicked(_ sender: UIButton) {
        
        chordType = 2
        
    }
    @IBAction func chord3Clicked(_ sender: UIButton) {
        
        chordType = 3
        
    }
    @IBAction func chord4Clicked(_ sender: UIButton) {
        
        chordType = 4
        
    }
    @IBAction func chord5Clicked(_ sender: UIButton) {
        
        chordType = 5
        
    }
    @IBAction func chord6Clicked(_ sender: UIButton) {
        
        chordType = 6
        
    }
    @IBAction func Chord7Clicked(_ sender: UIButton) {
        
        chordType = 7
        
    }
    
    @IBOutlet weak var chordSelectedLabel: UILabel!
    
    
    /*************************** MISC FUNCTIONS ************************/
    
    func checkServerStatus() {
        
        let serverIsOn = ServerExchange.CheckServerStatus()
        
        if serverIsOn == false {
            serverStatusLabel.text = "Disconnected"
            serverStatusLabel.textColor = UIColor.red
            return
        }
        
        serverStatusLabel.text = "Connected"
        serverStatusLabel.textColor = UIColor.green
        
    }
    
    func countDown() {
        
        self.remainingTime -= 1
        if (self.remainingTime < 0) {
            trainingIndicator.stopAnimating()
            trainingIndicator.isHidden = true
            self.timerConstantTrainingIndicator?.invalidate()
            self.timerConstantTrainingIndicator = nil
        }
        
    }
    
    @objc func switchIsChanged(_ mySwitch: UISwitch) {
        if mySwitch.isOn {
            timerConstantTraining = Timer.scheduledTimer(timeInterval: 1, target: self,
                                                         selector: #selector(constantTraining),
                                                         userInfo: nil,
                                                         repeats: true)
        } else {
            self.timerConstantTraining?.invalidate()
            self.timerConstantTraining = nil
        }
    }

    
}
