//
//  LocationFetcher.swift
//  LocationTest
//
//  Created by Vishnu Ravi on 8/5/21.


import CoreLocation
import Firebase
import Foundation

class LocationFetcher: NSObject, CLLocationManagerDelegate, ObservableObject {
    let manager = CLLocationManager()
    let date = NSDate()
    let unixtime = NSTimeIntervalSince1970
    let authCollection = CKStudyUser.shared.authCollection
    var lastLatitude:CLLocationDegrees = 0.0
    var lastLongitude:CLLocationDegrees = 0.0
    
    @Published var lastKnownLocation: CLLocationCoordinate2D? {
        didSet {
                
            guard let longitude = lastKnownLocation?.longitude else {
                return
            }

            guard let latitude = lastKnownLocation?.latitude else {
                return
            }
            
            var d = 1000.0
            
            if lastLatitude != 0.0 && lastLongitude != 0.0{
                let d2r = (Double.pi / 180.0)
                let dlong = (lastLongitude-longitude) * d2r;
                let dlat = (lastLatitude-latitude) * d2r;
                let a = pow(sin(dlat/2.0), 2) + cos(latitude*d2r) * cos(lastLongitude*d2r) * pow(sin(dlong/2.0), 2);
                let c = 2 * atan2(sqrt(a), sqrt(1-a));
                d = 6367 * c;
            }
            
            
            if d>0.1{
                let db = Firestore.firestore()
                db.collection(authCollection! + "location-data")
                    .document(UUID().uuidString)
                    .setData([
                                "currentdate": date,
                                "epoch time (seconds)": unixtime,
                                "latitude": latitude,
                                "longitude": longitude
                    ]) { err in
                    
                    if let err = err {
                        print("[CKSendHelper] sendToFirestoreWithUUID() - error writing document: \(err)")
                    } else {
                        print("[CKSendHelper] sendToFirestoreWithUUID() - document successfully written!")
                    }
                }
                lastLatitude = latitude
                lastLongitude = longitude
            }
            
            
        }
    }

    override init() {
        super.init()
        manager.delegate = self
        self.manager.startUpdatingLocation()
        self.manager.startMonitoringSignificantLocationChanges()
        self.manager.allowsBackgroundLocationUpdates = true
    }

    func start() {
        if CLLocationManager.locationServicesEnabled(){
            self.manager.startUpdatingLocation()
            self.manager.startMonitoringSignificantLocationChanges()
            self.manager.allowsBackgroundLocationUpdates = true
        }
    }

    func requestAuthorizationLocation(){
        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
    }
    
    func stop(){
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
        
    
}


