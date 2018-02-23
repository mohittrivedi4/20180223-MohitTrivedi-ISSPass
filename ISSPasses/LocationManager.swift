//
//  LocationManager.swift
//  ISSPasses
//
//  Created by Mohit Trivedi on 2/22/18.
//  Copyright © 2018 Mohit Trivedi. All rights reserved.
//

import CoreLocation

protocol LocationManagerDelegate {
    func refreshCallback(withISSPass: [ISSResponse])
}

class LocationManager: NSObject, CLLocationManagerDelegate {

    static var sharedManager = LocationManager()
    
    var delegate: LocationManagerDelegate?
    
    fileprivate var locationManager: CLLocationManager = CLLocationManager()
    
    fileprivate var previousLocation: CLLocation?
    var currentLocation: CLLocation?
    
    fileprivate override init() {
        super.init()
    }
    
    public func setupLocationService() {
        locationManager.delegate = self
        // when we move 50 meters then update the location
        locationManager.distanceFilter = 50
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            case .denied, .restricted:
                return
            }
        }
        // Start location update
        locationManager.startUpdatingLocation()
    }
    
}

// MARK: CLLocationManagerDelegate methods
extension LocationManager {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation: CLLocation = locations[locations.count - 1]
        self.currentLocation = latestLocation
        // Filter out invalid locations
        guard isLocationValid(latestLocation: latestLocation, previousLocation: previousLocation) else {
            return
        }
        // Call 'getISSPasses' API
        BusinessLayerManager.sharedInstance.getISSPasses(withLat: latestLocation.coordinate.latitude, andLong: latestLocation.coordinate.longitude) { (inner) in
            // Refresh UI callback with data
            self.delegate?.refreshCallback(withISSPass: inner())
        }
        previousLocation = latestLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            locationManager.stopUpdatingLocation()
            break
        case .notDetermined, .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        }
    }
}

extension LocationManager {
    func isLocationValid(latestLocation: CLLocation, previousLocation: CLLocation?) -> Bool {
        
        // Filter out the invalid locations
        
        var verticalAccuracy: Double = 5
        if Platform.isSimulator {
            verticalAccuracy = 5
        } else {
            verticalAccuracy = latestLocation.verticalAccuracy
        }
        
        let maxHorizontalAccuracy: Double = 60
        
        // Check for accuracy, should be >= 0
        if latestLocation.horizontalAccuracy < 0 || latestLocation.horizontalAccuracy > maxHorizontalAccuracy || verticalAccuracy < 0 {
            return false
        }
        
        // Check for valid lat and lon
        if latestLocation.coordinate.latitude > 90 || latestLocation.coordinate.latitude < -90 || latestLocation.coordinate.longitude > 180 || latestLocation.coordinate.longitude < -180 {
            return false
        }
        
        // Check for distance, It should have significant change
        if let previousLocation = previousLocation, latestLocation.distance(from: previousLocation) < latestLocation.horizontalAccuracy*0.5 {
            return false
        }
        
        // Check for timeStamp, latestLocation should not be captured more than 20 secs ago
        
        if Platform.isSimulator {
            // Do nothing
        } else {
            if abs(latestLocation.timestamp.timeIntervalSinceNow) > 20 {
                return false
            }
            
            // Check for course, should be >= 0
            if latestLocation.course < 0 {
                return false
            }
            
            // Check for altitude, should be >= 0
            if latestLocation.altitude < 0 {
                return false
            }
        }
        return true
    }
}

public struct Platform {
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}
