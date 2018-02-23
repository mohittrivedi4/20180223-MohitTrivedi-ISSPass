//
//  BusinessLayerManager.swift
//  ISSPasses
//
//  Created by Mohit Trivedi on 2/22/18.
//  Copyright © 2018 Mohit Trivedi. All rights reserved.
//

import UIKit

class BusinessLayerManager {

    static let sharedInstance = BusinessLayerManager()
    
    private init() {}
    
    /**
     Returns ISSResponse array
    */
    func getISSPasses(withLat lat: Double, andLong long: Double, handler: @escaping (_ inner: () -> [ISSResponse]) -> Void) {
        let urlString = "http://api.open-notify.org/iss-pass.json?lat=\(lat)&lon=\(long)"
        guard let request = RequestHandler.getRequest(withURL: urlString) else {
            handler({ return [] })
            return
        }
        NetworkManager().getData(request: request) { (success, data) in
            let issPass = ISSPassesViewModel().getISSPasses(fromData: data)
            handler({ return issPass })
        }
    }
}
