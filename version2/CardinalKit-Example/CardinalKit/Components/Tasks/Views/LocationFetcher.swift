//
//  LocationFetcher.swift
//  LocationTest
//
//  Created by Vishnu Ravi on 8/5/21.


import CoreLocation
import Firebase
import Foundation

class LocationFetcher: NSObject, CLLocationManagerDelegate, ObservableObject {
    var statusDidChange: ((Bool) -> Void)? = nil
    
    static let sharedinstance = LocationFetcher()
    
    let manager = CLLocationManager()
    let date = NSDate()
    let unixtime = NSTimeIntervalSince1970
//    let authCollection = CKStudyUser.shared.authCollection
    var lastLatitude:CLLocationDegrees = 0.0
    var lastLongitude:CLLocationDegrees = 0.0
    @Published var tracking:Bool = false{
        didSet{
            statusDidChange?(tracking)
        }
    }
    
    
    @Published var authorizationStatus:CLAuthorizationStatus = CLLocationManager().authorizationStatus
    @Published var canShowRequestMessage:Bool = true
    
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
//            else{
//                lastLatitude = latitude
//                lastLongitude = longitude
//            }
            
            
            if d>0.1{
                let db = Firestore.firestore()
                if let authCollection = CKStudyUser.shared.authCollection {
                    db.collection(authCollection + "location-data")
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
                }
                lastLatitude = latitude
                lastLongitude = longitude
                
            }
            
            
        }
    }

    override init() {
        super.init()
        manager.delegate = self
        //self.manager.startUpdatingLocation()
        //self.manager.startMonitoringSignificantLocationChanges()
        self.manager.allowsBackgroundLocationUpdates = true
        calculeIfCanShowRequestMessage()
        
    }
    
    func calculeIfCanShowRequestMessage(){
        if manager.authorizationStatus == .notDetermined || (manager.authorizationStatus == .authorizedWhenInUse && UserDefaults.standard.bool(forKey: Constants.JHFirstLocationRequest)){
            canShowRequestMessage = true
        }
        else{
            canShowRequestMessage = false
        }
    }

    func start() {
        if CLLocationManager.locationServicesEnabled(){
            self.manager.startUpdatingLocation()
            self.manager.startMonitoringSignificantLocationChanges()
            self.manager.allowsBackgroundLocationUpdates = true
            self.tracking = true
        }
    }
    
    func validateAuthorizationLocation() -> Bool{
        
        switch (manager.authorizationStatus) {
            case .authorizedAlways:
                // Handle case
                print("Always")
                return true
            case .authorizedWhenInUse:
                // Handle case
                print("When in use")
                return true
            case .denied, .restricted, .notDetermined:
                // Handle case
                print("Denied")

                return false
        }
        
    }
    
    func userAuthorizeAlways() -> Bool {
        return manager.authorizationStatus == .authorizedAlways
    }
    
    func userAuthorizeWhenInUse() -> Bool {
        return manager.authorizationStatus == .authorizedWhenInUse
    }
    
    
    func messageWhenValidateAuthorizationLocationFail(){
        
        // initialise a pop up for using later
        let alertController = UIAlertController(title: "You have selected the wrong permit", message: "Please go to the localization settings and select ALWAYS", preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
             }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)


        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
         UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true) {
         
             //self.start()
             //LaunchModel.sharedinstance.showPermissionView = true
             
         }
    }

    func requestAuthorizationLocation() {
//        messageWhenValidateAuthorizationLocationFail()
//        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .denied{
//            messageWhenValidateAuthorizationLocationFail()
//        }
//        else if manager.authorizationStatus == .notDetermined{
            manager.requestWhenInUseAuthorization()
            manager.requestAlwaysAuthorization()
//        }
        
        
    }
    
    func stop(){
        self.tracking = false
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
        
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let previousState = authorizationStatus
        authorizationStatus = manager.authorizationStatus
        
        let first = UserDefaults.standard.bool(forKey: Constants.JHFirstLocationRequest)
        
        if(authorizationStatus == .authorizedWhenInUse && !first && previousState != authorizationStatus){
            UserDefaults.standard.set(true, forKey: Constants.JHFirstLocationRequest)
        }
        else{
            UserDefaults.standard.set(false, forKey: Constants.JHFirstLocationRequest)
        }
        
        if authorizationStatus == .authorizedAlways{
            LaunchModel.sharedinstance.showPermissionView = false
            start()
        }
        
        calculeIfCanShowRequestMessage()
        
    }
}


