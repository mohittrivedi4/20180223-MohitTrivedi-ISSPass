//
//  ViewController.swift
//  ISSPasses
//
//  Created by Mohit Trivedi on 2/22/18.
//  Copyright © 2018 Mohit Trivedi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView?
    
    var dataSource = [ISSResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Start location update
        LocationManager.sharedManager.delegate = self
        LocationManager.sharedManager.setupLocationService()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: LocationManagerDelegate methods
    func refreshCallback(withISSPass issPasses: [ISSResponse]) {
        DispatchQueue.main.async {
            self.dataSource = issPasses
            self.tableview?.reloadData()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier") {
            let issResponse = dataSource[indexPath.row]
            cell.textLabel?.text = getText(issResponse)
            cell.textLabel?.font = UIFont(name: "Helvetica", size:12);
            return cell
        }
        return UITableViewCell()
    }
    
    /// This helper method returns the text if it is valid otherwise '_'
    func getText(_ issResponse: ISSResponse) -> String {
        if let duration = issResponse.duration, let riseTime = issResponse.risetime {
            return "DURATION: \(duration) RISETIME: \(getDate(riseTime))"
        } else if let duration = issResponse.duration, issResponse.risetime == nil {
            return "DURATION: \(duration) RISETIME: _"
        } else if let riseTime = issResponse.risetime, issResponse.duration == nil {
            return "DURATION: _ RISETIME: \(getDate(riseTime))"
        } else if issResponse.risetime == nil, issResponse.duration == nil {
            return "DURATION: _ RISETIME: _"
        }
        return ""
    }
    
    func getDate(_ timeResult: Int) -> Date {
        let date = Date(timeIntervalSince1970: Double(timeResult))
        return date
    }
}

