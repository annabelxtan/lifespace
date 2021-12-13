//
//  MapManager.swift
//  CardinalKit_Example
//
//  Created by Alternova Dev on 25/11/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//


import SwiftUI
import MapboxMaps


struct MapManagerViewWrapper : UIViewControllerRepresentable {
    
    typealias UIViewControllerType = MapManagerView
        
    func makeUIViewController(context: Context) -> MapManagerView {
        return MapManagerView()
    }
    
    func updateUIViewController(_ uiViewController: MapManagerView, context: Context) {
        
    }
}

class MapManagerView: UIViewController, LocationPermissionsDelegate {
    
    internal var mapView: MapView!
    var trackingButton:UIButton?=nil
    var tracking = false
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(frame: CGRect(x: 200, y: 35, width: 350, height: 50))
        button.center.x = view.center.x
        
        if tracking{
            button.setTitle("stop", for: .normal)
            button.backgroundColor = .systemRed
        }
        else{
            button.setTitle("start", for: .normal)
            button.backgroundColor = .systemBlue
        }
        
        
        button.setTitleColor(.white,for: .normal)
        button.addTarget(self,action: #selector(startStopTracking),for: .touchUpInside)
        button.layer.cornerRadius = 10
       
        trackingButton = button
        self.view.addSubview(trackingButton!)
        
        
        let myResourceOptions = ResourceOptions(accessToken: "sk.eyJ1IjoicG9sbG93ZjgiLCJhIjoiY2t3ZWRlZW1xMDNtNDJ2cHdzdGE2NGs5ZiJ9.g8IODwKuRVo9a6kAlyyIYQ")
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions)
        mapView = MapView(frame:CGRect(x: 0, y: 120, width: 480, height: 480), mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(mapView)
        var allLocations = [CLLocationCoordinate2D]()
        // get firebase points
        JHMapDataManager.shared.getAllMapPoints(onCompletion: {(results) in
            if let results = results as? [mapPoint]{
                for point in results{
                    let location = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
                    allLocations.append(location)
                }
            }
            do {
              // Make the GeoJSON source
              var source = GeoJSONSource()
                source.data = .feature(Feature(geometry: .lineString(LineString(allLocations))))
                try self.mapView.mapboxMap.style.addSource(source, id: "SOURCE_ID")
              var heatLayer = HeatmapLayer(id: "LAYER_ID")
                heatLayer.source = "SOURCE_ID"

              // Add the layer to the mapView
                try self.mapView.mapboxMap.style.addLayer(heatLayer)
                self.mapView.mapboxMap.setCamera(
                    to: CameraOptions(
                        center: allLocations[0],
                        zoom: 18.0
                    )
                )
            } catch {
              print("error adding source or layer: \(error)")
            }
        })
    }
    
    @objc
    func startStopTracking(){
        tracking = !tracking
        if tracking{
            trackingButton?.setTitle("stop", for: .normal)
            trackingButton?.backgroundColor = .systemRed
        }
        else{
            trackingButton?.setTitle("start", for: .normal)
            trackingButton?.backgroundColor = .systemBlue
        }
        
    }
    
    internal func decodeGeoJSON(from fileName: String) throws -> FeatureCollection? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "geojson") else {
            preconditionFailure("File '\(fileName)' not found.")
        }
        let filePath = URL(fileURLWithPath: path)
        var featureCollection: FeatureCollection?
        do {
            let data = try Data(contentsOf: filePath)
            featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: data)
        } catch {
            print("Error parsing data: \(error)")
        }
        return featureCollection
    }
     
    internal func setupExample() {
     
     
    // Attempt to decode GeoJSON from file bundled with application.
    guard let featureCollection = try? decodeGeoJSON(from: "GradientLine") else { return }
    let geoJSONDataSourceIdentifier = "geoJSON-data-source"
     
    // Create a GeoJSON data source.
    var geoJSONSource = GeoJSONSource()
    geoJSONSource.data = .featureCollection(featureCollection!)
    geoJSONSource.lineMetrics = true // MUST be `true` in order to use `lineGradient` expression
     
    // Create a line layer
    var lineLayer = LineLayer(id: "line-layer")
    lineLayer.filter = Exp(.eq) {
    "$type"
    "LineString"
    }
     
    // Setting the source
    lineLayer.source = geoJSONDataSourceIdentifier
     
    // Styling the line
    lineLayer.lineColor = .constant(StyleColor(.red))
    lineLayer.lineGradient = .expression(
    Exp(.interpolate) {
    Exp(.linear)
    Exp(.lineProgress)
    0
    UIColor.blue
    0.1
    UIColor.purple
    0.3
    UIColor.cyan
    0.5
    UIColor.green
    0.7
    UIColor.yellow
    1
    UIColor.red
    }
    )
     
    let lowZoomWidth = 10
    let highZoomWidth = 20
    lineLayer.lineWidth = .expression(
    Exp(.interpolate) {
    Exp(.linear)
    Exp(.zoom)
    14
    lowZoomWidth
    18
    highZoomWidth
    }
    )
    lineLayer.lineCap = .constant(.round)
    lineLayer.lineJoin = .constant(.round)
     
    // Add the source and style layer to the map style.
    try! mapView.mapboxMap.style.addSource(geoJSONSource, id: geoJSONDataSourceIdentifier)
    try! mapView.mapboxMap.style.addLayer(lineLayer, layerPosition: nil)
    }
    
    // Selector that will be called as a result of the delegate below
    func requestPermissionsButtonTapped() {
        mapView.location.requestTemporaryFullAccuracyPermissions(withPurposeKey: "CustomKey")
    }
    
}
