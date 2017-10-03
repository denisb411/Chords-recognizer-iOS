//
//  MainDataTableViewController.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 09/05/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.
//

import Foundation
import UIKit

class MainDataTableViewController:UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: true)
        }
    }
    
    @IBAction func clearMainDataPressed(_ sender: Any) {
        
        var refreshAlert = UIAlertController(title: "Append", message: "Are you sure? Current MainData will be backed up anyway.", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            print("Cancel Pressed")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.sendClearMainData()
        }))
        
        present(refreshAlert, animated: true, completion: nil)

    }
    
    @IBAction func appendButtonPressed(_ sender: Any) {
        
        var refreshAlert = UIAlertController(title: "Append", message: "Are you sure? Current MainData will be backed up anyway.", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            print("Cancel Pressed")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.sendMessageAppend()
        }))
        
        
        
        present(refreshAlert, animated: true, completion: nil)
        
    }
    
    
    func sendMessageAppend () {
        
        let json: [String: Any] = ["messageType": "syncCachedDataWithMainData"]
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        if let printData = jsonData {
            print (printData)
        }
        
        let urlAddress = "http://" + ServerExchange.urlAddress + "/api/append/main_data/"
        
        let url = URL(string: urlAddress)
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
                } else {
                    AlertMessages(self).showSuccessfulAlert()
                }
                
                if let content = data {
                    do {
                        var completeMessage:String = "\n Current model's hit rate of MainData:\n\n"
                        let JsonData = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers ) as AnyObject
                        
                        let serverMessage = ServerExchange.readTestMessage(JsonData as! NSDictionary)
                        
                        completeMessage = completeMessage + "\(serverMessage)"
                        
                        let alert = UIAlertController(title: "Models test", message: "\(completeMessage)", preferredStyle: UIAlertControllerStyle.alert)
                        let ok = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil)
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                        
                    } catch {}
                    
                }
                
                print ("****** response = \(response)")
                
                //Read the JSON
                if let postString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as? String {
                    print("POST:\(postString)")
                }
                
        }).resume()
        
    }
    
    
    @IBAction func createBackupPressed(_ sender: Any) {

        //1. Create the alert controller.
        let alert = UIAlertController(title: "Backup MainData", message: "Insert a backup title", preferredStyle: .alert)
        
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
            
            let json: [String: Any] = ["backupFile": textField.text]
        
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            if let printData = jsonData {
                print (printData)
            }
            
            let urlAdressClearCachedData = "http://" + ServerExchange.urlAddress + "/api/create/backup/"
            
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
                    } else {
                        AlertMessages(self).showSuccessfulAlert()
                    }
                    
                    print ("****** response = \(response)")
                    
                    //Read the JSON
                    if let postString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as? String {
                        print("POST:\(postString)")
                    }
                    
            }).resume()
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    
        }
    
    func sendClearMainData() {
        
        let json: [String: Any] = ["messageType": "clearMainData"]
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        if let printData = jsonData {
            print (printData)
        }
        
        let urlAdressClearCachedData = "http://" + ServerExchange.urlAddress + "/api/clear/main_data/"
        
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
                } else {
                    AlertMessages(self).showSuccessfulAlert()
                }
                
                print ("****** response = \(response)")
                
                //Read the JSON
                if let postString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as? String {
                    print("POST:\(postString)")
                }
                
        }).resume()
    }
    
    
    
}
