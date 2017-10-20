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
    
    var timerCheckServerStatus:Timer?
    
    @IBOutlet weak var currentServerLabel: UILabel!
    @IBOutlet weak var serverStatusLabel: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Settings"
        navigationItem.backBarButtonItem = backItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: true)
        }
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
    
    @IBAction func changeServerPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Change server address", message: "Insert a new server address", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            print("Cancel Pressed")
            return
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            
            ServerExchange.setServerUrl(textField.text!)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkServerStatus() {
        DispatchQueue.main.async() {
            let serverIsOn = ServerExchange.CheckServerStatus()
            if serverIsOn == false {
                self.serverStatusLabel.text = "Disconnected"
                self.serverStatusLabel.textColor = UIColor.red
            } else {
                self.serverStatusLabel.text = "Connected"
                self.serverStatusLabel.textColor = UIColor.green
            }
        }
    }
    
}
