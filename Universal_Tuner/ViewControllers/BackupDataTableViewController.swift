//
//  BackupDataTableViewController.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 12/05/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.
//

import Foundation
import UIKit

class BackupDataTableViewController:UITableViewController {
    
    var backupList = Array<String>()
    
    override func viewWillAppear(_ animated: Bool) {
        loadBackupDataList()
    }
    
    func loadBackupDataList() {
        let json: [String: Any] = ["messageType": "listBackups"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let urlAdressAppendFftData = "http://" + ServerExchange.urlAddress + "/api/list/backup/"
        print (urlAdressAppendFftData)
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
                        let JsonData = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers ) as! NSArray
                        self.backupList = ServerExchange.readBackupListMessage(JsonData)
                        self.tableView.reloadData()
                    } catch {}
                }
                //Read the JSON
                if let postString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as? String {
                    print("POST:\(postString)")
                }
        }).resume()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return backupList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let backupFileName = backupList[row]
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        cell.textLabel!.text = backupFileName
        return cell
    }

    //MARK: TableView configuration
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let backupFile = backupList[indexPath.row]
            var refreshAlert = UIAlertController(title: "Use BackupData as MainData", message: "Are you sure you want to use \(backupFile) as MainData?", preferredStyle: UIAlertControllerStyle.alert)
            refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
                print("Cancel Pressed")
            }))
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                self.useBackupDataAsMainData(file:backupFile)
            }))
            present(refreshAlert, animated: true, completion: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    func useBackupDataAsMainData(file:String) {
        var done = false
        let json: [String: Any] = ["backupFile": file]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let urlAdressAppendFftData = "http://" + ServerExchange.urlAddress + "/api/use/backup/"
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
        
        request.timeoutInterval = 60.0
        session.dataTask(with: request, completionHandler:
            { data, response, error in
                if error != nil {
                    AlertMessages(self).showServerError(error as! URLError)
                    print ("Error: \(error)")
                }
                print ("****** response = \(response)")
                if let content = data {
                    do {
                        AlertMessages(self).showSuccessfulAlert()
                        self.loadBackupDataList()
                    } catch {}
                }
                //Read the JSON
                if let strongResponse = response {
                    if let postString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as? String {
                        print("POST:\(postString)")
                    }
                }
        }).resume()
        return
    }
}
