//
//  SettingsTableViewController.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 08/05/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.
//

import Foundation
import UIKit

class SettingsTableViewController:UITableViewController{
    
    @IBOutlet weak var currentServerLabel: UILabel!
    
    @IBOutlet weak var serverStatusLabel: UILabel!
    
    var timerCheckServerStatus:Timer?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Settings"
        navigationItem.backBarButtonItem = backItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        currentServerLabel.text = ServerExchange.urlAddress
        
        let serverIsOn = ServerExchange.CheckServerStatus()
        
        if serverIsOn == false {
            serverStatusLabel.text = "Disconnected"
            serverStatusLabel.textColor = UIColor.red
            return
        }
        
        serverStatusLabel.text = "Connected"
        serverStatusLabel.textColor = UIColor.green
        
        timerCheckServerStatus = Timer.scheduledTimer(timeInterval: 1, target: self,
                                                      selector: #selector(checkServerStatus),
                                                      userInfo: nil,
                                                      repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timerCheckServerStatus?.invalidate()
        self.timerCheckServerStatus = nil
        
    }
    
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
    
}
