//
//  Location.swift
//  CardinalKit_Example
//
//  Created by Annabel Tan on 6/22/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    let manager = CLLocationManager ()
    
    var completion: ((CLLocation) -> Void)?
    
    public func getUserLocation(completion: @escaping ((CLLocation) ->  Void)) {
        self.completion = completion
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    func locationManager( _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            return
        }
        completion?(location)
        manager.stopUpdatingLocation()        
    }
}
