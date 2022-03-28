//
//  MapView.swift
//  CardinalKit_Example
//
//  Created by Alternova Dev on 25/11/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//


import SwiftUI
import MapboxCommon
import MapboxMobileEvents
import MapboxCoreMaps_Private
import MapboxCoreMaps
import MapboxMaps

//
//struct MapViewWrapper : UIViewControllerRepresentable {
//    
//    typealias UIViewControllerType = ShowMap
//        
//    func makeUIViewController(context: Context) -> ShowMap {
//        return ShowMap()
//    }
//    
//    func updateUIViewController(_ uiViewController: ShowMap, context: Context) {
//        
//    }
//}

class ShowMap: UIViewController, LocationPermissionsDelegate {
    let museumLayerId = "museum-circle-layer"
    let contourLayerId = "contour-line-layer"
 
    internal var mapView: MapView!
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let myResourceOptions = ResourceOptions(accessToken: "sk.eyJ1IjoicG9sbG93ZjgiLCJhIjoiY2t3ZWRlZW1xMDNtNDJ2cHdzdGE2NGs5ZiJ9.g8IODwKuRVo9a6kAlyyIYQ")
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions)
        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
