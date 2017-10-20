//
//  PracticeSettingsTableViewController.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 17/10/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.
//

import Foundation
import UIKit

class PracticeSettingsTableViewController: UITableViewController {
    
    var delegate: PracticeViewControllerDelegate!
    
    @IBOutlet var chordTimeLabel:UILabel!
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        let currentValue = Int(sender.value)
        delegate.setRandomChordTime(newTime: currentValue)
        chordTimeLabel.text = String(currentValue)  + " seconds"
    }
    
    @IBAction func resetScorePressed(sender: Any!) {
        delegate.resetScore()
        if let navigation = navigationController {
            navigation.popViewController(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        chordTimeLabel.text = String(describing: delegate.getRandomChordTime()) + " seconds"
    }
}
