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
    
    // TODO: Program button to change the srv address
    
    @IBAction func changeServerPressed(_ sender: Any) {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Change server address", message: "Insert a new server address", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            print("Cancel Pressed")
            return
        }))
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            
            ServerExchange.setServerUrl(textField.text!)

        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)

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
