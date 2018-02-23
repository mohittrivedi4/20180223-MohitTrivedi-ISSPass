//
//  ISSPassesTests.swift
//  ISSPassesTests
//
//  Created by Mohit Trivedi on 2/22/18.
//  Copyright © 2018 Mohit Trivedi. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ISSPasses

class ISSPassesTests: XCTestCase {
    
    var locationManager: LocationManager!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        locationManager = LocationManager.sharedManager
        locationManager.setupLocationService()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetISSPasses() {
        let exp = expectation(description: "testGetISSPasses")
        BusinessLayerManager.sharedInstance.getISSPasses(withLat: 33.748995, andLong: -84.387982) { (inner) in
            let issPassResponse = inner()
            XCTAssertTrue(issPassResponse.count == 5)
            exp.fulfill()
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testLocationUpdate() {
        let clLocationManager: CLLocationManager = CLLocationManager()
        clLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        clLocationManager.distanceFilter = 100
        clLocationManager.requestWhenInUseAuthorization()
        locationManager.locationManager(clLocationManager, didUpdateLocations: [CLLocation(latitude: 2.0, longitude: 3.0)])
        XCTAssertTrue(locationManager.currentLocation?.coordinate.latitude == 2.0 && locationManager.currentLocation?.coordinate.longitude == 3.0)
    }
    
}
