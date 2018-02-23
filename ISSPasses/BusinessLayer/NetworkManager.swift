//
//  NetworkManager.swift
//  ISSPasses
//
//  Created by Mohit Trivedi on 2/22/18.
//  Copyright © 2018 Mohit Trivedi. All rights reserved.
//

import UIKit

class RequestHandler {
    /**
     Creates a URLRequest using URL string
     
     - parameters:
     -urlString: String type
     
     */
    class func getRequest(withURL urlString: String) -> URLRequest? {
        var urlRequest: URLRequest?
        let url = URL(string: urlString)
        if let usableUrl = url {
            urlRequest = URLRequest(url: usableUrl)
        }
        return urlRequest
    }
}

class NetworkManager: NSObject {

    /**
     Make an API call and returns the response
     
     - parameters:
      -request: URLRequest type
      -callback: clousure that accepts param (Bool, AnyObject)
     
     */
    func getData(request: URLRequest, callback: @escaping (Bool,
        Data?) -> ()) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            if let data = data {
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    callback(true, data)
                } else {
                    callback(false, data)
                }
            } else {
                callback(false, nil)
            }
        })
        task.resume()
    }
}
