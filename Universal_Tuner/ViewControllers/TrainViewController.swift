//
//  TrainViewController.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 09/05/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.
//

import Foundation
import UIKit

class TrainViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView?
    @IBOutlet weak var microphoneVolumeProgressView: UIProgressView!
    
    @IBOutlet weak var selectAChordLabel: UILabel!
    var selected:Chord?
    let chords = ChromaticViewController.chords
    
    @IBOutlet weak var trainingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var constantTrainingSwitch: UISwitch!
    var nothingSelected = true
    
    var timerConstantTrainingIndicator:Timer?
    var timerConstantTraining:Timer?
    var remainingTime = 0
    var timerMicrophoneVolume:Timer?
    
    
    //MARK: TableView configuration
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if(cell.accessoryType == UITableViewCellAccessoryType.none) {
                for var row in 0...tableView.numberOfRows(inSection: 0){
                    let cell2 = tableView.cellForRow(at: IndexPath(row: row, section: 0))
                    cell2?.accessoryType = UITableViewCellAccessoryType.none
                }
                
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
                let chord = chords[indexPath.row]
                selected = chord
                nothingSelected = false
                
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.none
                nothingSelected = true
                if constantTrainingSwitch.isOn {
                    selectAChordLabel.isHidden = false
                }
            }
        } else {
            print ("here2")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let chord = chords[row]
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        cell.textLabel!.text = chord.name
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        constantTrainingSwitch.isOn = false
        
        trainingIndicator.stopAnimating()
        trainingIndicator.isHidden = true
        
        selectAChordLabel.isHidden = true
        
        constantTrainingSwitch.addTarget(self, action: "switchIsChanged:", for: UIControlEvents.valueChanged)
        
        timerMicrophoneVolume = Timer.scheduledTimer(timeInterval: 0.01, target: self,
                                                     selector: #selector(setMicrophoneVolume),
                                                     userInfo: nil,
                                                     repeats: true)
    }
    
    @objc func switchIsChanged(_ mySwitch: UISwitch) {
        if mySwitch.isOn {
            if nothingSelected {
                selectAChordLabel.isHidden = false
            }
            timerConstantTraining = Timer.scheduledTimer(timeInterval: 1, target: self,
                                                         selector: #selector(constantTraining),
                                                         userInfo: nil,
                                                         repeats: true)
        } else {
            self.timerConstantTraining?.invalidate()
            self.timerConstantTraining = nil
            selectAChordLabel.isHidden = true
        }
    }
    
    
    
    func constantTraining() {
        
        if nothingSelected {
            selectAChordLabel.isHidden = false
            return
        }
        
        selectAChordLabel.isHidden = true
        
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
        
        let newFftData = Array((0 ... (ChromaticViewController.tuner.fft.fftDataSize - 1)).map {
            
            index -> Int in
            let tempArray = (ChromaticViewController.tuner.fft.fftData[index] * (pow(10,16)))
            return ( Int(tempArray))
            
        })
        
        let json: [String: Any] = ["chordType": selected!.chordNumber,
                                   "fftData": newFftData]
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        if let printData = jsonData {
            print (printData)
        }
        
        let urlAdressAppendFftData = "http://" + ServerExchange.urlAddress + "/api/appendToCachedFftData/"
        
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timerConstantTrainingIndicator?.invalidate()
        self.timerConstantTrainingIndicator = nil
        
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
    
    
    func setMicrophoneVolume() {
            
        var microphoneVolume = ChromaticViewController.tuner.tracker.amplitude * 10
        if (microphoneVolume > 1) { microphoneVolume = 1}
        self.microphoneVolumeProgressView.progress = Float(microphoneVolume)
        
    }
    
    
    
    
    
}
