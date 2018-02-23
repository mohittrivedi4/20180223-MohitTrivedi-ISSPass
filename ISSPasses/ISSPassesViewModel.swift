//
//  ISSPassesViewModel.swift
//  ISSPasses
//
//  Created by Mohit Trivedi on 2/22/18.
//  Copyright © 2018 Mohit Trivedi. All rights reserved.
//

import UIKit

struct ISSPassesViewModel {
    /**
     This returns ISSResponse array
     - parameters:
        -data: Data type
    */
    func getISSPasses(fromData data: Data?) -> [ISSResponse] {
        /// JSON response from API is not in correct standard format so using JSONSerialization and not able to use JSONDecoder/Codable
        
        guard let data = data else {
            return []
        }
        let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
        
        var issResponses = [ISSResponse]()
        if let responses = json?["response"] as? [[String: Any]] {
            for response in responses {
                let issResponse = ISSResponse(duration: response["duration"] as? Int, risetime: response["risetime"] as? Int)
                issResponses.append(issResponse)
            }
        }
        
        return issResponses
        
//        var issPass: ISSPass?
//        if let jsonData = data
//        {
//            do {
//                issPass = try JSONDecoder().decode(ISSPass.self, from: jsonData)
//            } catch let error {
//                print(error.localizedDescription)
//            }
//
//        }
//        return issPass
    }
}

struct ISSPass: Codable {
    var message: String?
    var request: ISSRequest?
    var response: [ISSResponse]?
}

struct ISSRequest: Codable {
    var altitude: Int?
    var datetime: String?
    var latitude: Double?
    var longitude: Double?
    var passes: Int?
}

struct ISSResponse: Codable {
    var duration: Int?
    var risetime: Int?
}
