//
//  TestsTableViewController.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 24/05/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.
//

import Foundation
import UIKit

class TestsTableViewController:UITableViewController {
    
    static var selectedTestCase:TestCase = TestsTableViewController.testCases[0]
    static var selectedInstrument:Instrument = TestsTableViewController.instruments[0]
    static var selectedDataPercentage:DataPercentage = TestsTableViewController.dataPercentages[0]
    static var selectedBufferSize:BufferSize = TestsTableViewController.bufferSizes[0]
    var decibelsTraining = 0
    
    @IBOutlet weak var selectedInstrumentLabel: UILabel!
    @IBOutlet weak var selectedDataPercentageLabel: UILabel!
    @IBOutlet weak var selectedBufferSizeLabel: UILabel!
    @IBOutlet weak var selectedTestCaseLabel: UILabel!
    @IBOutlet weak var selectedDatasetLabel: UILabel!
    @IBOutlet weak var decibelsTrainingSwitch: UISwitch!
    
    struct Instrument {
        var name: String?
        var value: String?

        init(name: String, value: String){
            
            self.name = name
            self.value = value
        }
    }
    
    struct DataPercentage {
        var name: String?
        var value: Float?
        
        init(name: String, value: Float){
            self.name = name
            self.value = value
        }
    }
    
    struct BufferSize {
        var name: String?
        var value: Float?
        
        init(name: String, value: Float){
            self.name = name
            self.value = value
        }
    }
    
    struct TestCase {
        var name: String?
        var value: Float?
        var description: String?
        
        init(name: String, value: Float){
            self.name = name
            self.value = value
        }
    }
    
    static var instruments = [
        Instrument(name:"Steel Guitar",value:"steelGuitar"),
        Instrument(name:"Nylon Guitar",value:"nylonGuitar")
    ]
    
    static var dataPercentages = [
        DataPercentage(name:"100%", value:1),
        DataPercentage(name:"50%", value:0.5),
        DataPercentage(name:"25%", value:0.25),
        DataPercentage(name:"10%", value:0.1),
    ]
    
    static var bufferSizes = [
        BufferSize(name:"8192", value:8192),
        BufferSize(name:"4096", value:4096),
        BufferSize(name:"2048", value:2048),
        BufferSize(name:"1024", value:1024),
        BufferSize(name:"512", value:512),
    ]
    
    static var testCases = [
        TestCase(name:"Case 1", value:1),
        TestCase(name:"Case 2", value:2),
        TestCase(name:"Case 3", value:3),
        TestCase(name:"Case 4", value:4),
    ]
    
    static var selectedDataset = "samples_steelGuitar_test02Em.csv"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Tests"
        navigationItem.backBarButtonItem = backItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: true)
        }
        self.selectedInstrumentLabel.text = TestsTableViewController.selectedInstrument.name
        self.selectedDataPercentageLabel.text = TestsTableViewController.selectedDataPercentage.name
        self.selectedBufferSizeLabel.text = TestsTableViewController.selectedBufferSize.name
        self.selectedTestCaseLabel.text = TestsTableViewController.selectedTestCase.name
        self.selectedDatasetLabel.text = TestsTableViewController.selectedDataset
    }
    
    override func viewDidLoad() {
        decibelsTrainingSwitch.addTarget(self, action: "switchIsChanged:", for: UIControlEvents.valueChanged)
    }
    
    @objc func switchIsChanged(_ mySwitch: UISwitch) {
        if mySwitch.isOn {
            self.decibelsTraining = 1
        } else {
            self.decibelsTraining = 0
        }
    }
    
    @IBAction func makeTestButtonPressed(_ sender: Any) {
        let json: [String: Any] = ["dataPercentage": TestsTableViewController.selectedDataPercentage.value,
                                   "bufferSize": TestsTableViewController.selectedBufferSize.value,
                                   "testCase":TestsTableViewController.selectedTestCase.value,
                                   "trainWithDecibels": self.decibelsTraining,
                                   "dataset": TestsTableViewController.selectedDataset]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let urlAdressAppendFftData = "http://" + ServerExchange.urlAddress + "/api/test/case/"
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
                    AlertMessages(self).showServerError(error as! URLError)
                    return
                }
                print ("****** response = \(response)")
                if let content = data {
                    do {
                        var completeMessage:String = "Test - Models hit rate:\n\n"
                        let JsonData = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers ) as AnyObject
                        let serverMessage = ServerExchange.readTestMessage(JsonData as! NSDictionary)
                        completeMessage = completeMessage + "\(serverMessage)"
                        let alert = UIAlertController(title: "Models test", message: "\(completeMessage)", preferredStyle: UIAlertControllerStyle.alert)
                        let ok = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil)
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                    } catch {}
                }
                //Read the JSON
                if let postString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as? String {
                    print("POST:\(postString)")
                }
        }).resume()
    }
    
    @IBAction func testCurrentTrainedModelPressed(_ sender: Any) {
        let json: [String: Any] = ["messageType": "testCurrentTrainedModel"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let urlAdressAppendFftData = "http://" + ServerExchange.urlAddress + "/api/test/trained_model/"
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
                    AlertMessages(self).showServerError(error as! URLError)
                    return
                }
                print ("****** response = \(response)")
                if let content = data {
                    do {
                        var completeMessage:String = "Test - Current model hit rate:\n\n"
                        let JsonData = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers ) as AnyObject
                        let serverMessage = ServerExchange.readTestMessage(JsonData as! NSDictionary)
                        completeMessage = completeMessage + "\(serverMessage)"
                        let alert = UIAlertController(title: "Model test", message: "\(completeMessage)", preferredStyle: UIAlertControllerStyle.alert)
                        let ok = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil)
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                    } catch {}
                }
                //Read the JSON
                if let postString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as? String {
                    print("POST:\(postString)")
                    
                }
        }).resume()
    }
}

func ==(first:TestsTableViewController.DataPercentage, second:TestsTableViewController.DataPercentage) -> Bool{
    return first.name == second.name && first.value == second.value
}

func ==(first:TestsTableViewController.Instrument, second:TestsTableViewController.Instrument) -> Bool{
    return first.name == second.name && first.value == second.value
}

func ==(first:TestsTableViewController.BufferSize, second:TestsTableViewController.BufferSize) -> Bool{
    return first.name == second.name && first.value == second.value
}

func ==(first:TestsTableViewController.TestCase, second:TestsTableViewController.TestCase) -> Bool{
    return first.name == second.name && first.value == second.value
}

