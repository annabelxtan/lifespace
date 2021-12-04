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


struct MapViewWrapper : UIViewControllerRepresentable {
    
    typealias UIViewControllerType = ShowMap
        
    func makeUIViewController(context: Context) -> ShowMap {
        return ShowMap()
    }
    
    func updateUIViewController(_ uiViewController: ShowMap, context: Context) {
        
    }
}

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

        self.view.addSubview(mapView)
        
        // get firebase points
        JHMapDataManager.shared.getAllMapPoints(onCompletion: {(results) in
            if let results = results as? [mapPoint]{
                // Create the `PointAnnotationManager` which will be responsible for handling this annotation
                let pointAnnotationManager = self.mapView.annotations.makePointAnnotationManager()
                var anotations = [PointAnnotation]()
                for point in results{
                    //add custom location
                    var pointAnnotation = PointAnnotation(coordinate: CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude))
                    //Make the annotation show a red pin
                    pointAnnotation.image = .init(image: UIImage(named: "red_pin")!, name: "red_pin")
                    anotations.append(pointAnnotation)
                }
                pointAnnotationManager.annotations=anotations
            }
        })
//        mapView.mapboxMap.onNext(.mapLoaded) { _ in
//            self.addStyleLayers()
////            self.addVisibilitySwitches()
//        }
        let heatMapLayer = HeatmapLayer(id: "heatMap")
//        heatMapLayer.
//        let layer = MGLHeatmapStyleLayer(identifier: "earthquake-heat", source: earthquakes)
//        layer.heatmapWeight = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:(magnitude, 'linear', nil, %@)",
//                                           [0: 0,
//                                            6: 1])
//        layer.heatmapIntensity = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
//                                              [0: 1,
//                                               9: 3])
//        mapView.style?.addLayer(layer)
        
//
        
//
//
///-     my location
//        mapView.location.delegate = self
//        mapView.location.options.puckType = .puck2D()
//
//
///-     add custom location
//        var pointAnnotation = PointAnnotation(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(48.85341), longitude: 2.3488))
//
//        // Make the annotation show a red pin
//        pointAnnotation.image = .init(image: UIImage(named: "red_pin")!, name: "red_pin")
//
//        // Create the `PointAnnotationManager` which will be responsible for handling this annotation
//        let pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
//
//        // Add the annotation to the manager in order to render it on the map.
//        pointAnnotationManager.annotations = [pointAnnotation]
//
//
//        // Add line between locations
//
//        // Define two or more geographic coordinates to connect with a line.
//        // Line from New York City, NY to Washington, D.C.
//        let lineCoordinates = [
//            CLLocationCoordinate2DMake(40.7128, -74.0060),
//            CLLocationCoordinate2DMake(38.9072, -77.0369)
//        ]
//
///-  Create the line annotation.
//        var lineAnnotation = PolylineAnnotation(lineCoordinates: lineCoordinates)
//        lineAnnotation.lineColor = StyleColor(.red)
//
//        // Create the `PolylineAnnotationManager` which will be responsible for handling this annotation
//        let lineAnnnotationManager = mapView.annotations.makePolylineAnnotationManager()
//
//        // Add the annotation to the manager.
//        lineAnnnotationManager.annotations = [lineAnnotation]
        
        
///- gradient line
//        let options = MapInitOptions(styleURI: .light)
//        mapView = MapView(frame: view.bounds, mapInitOptions: options)
//        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.addSubview(mapView)
//
//        mapView.mapboxMap.onNext(.mapLoaded) { _ in
//
//        self.setupExample()
//
//        // Set the center coordinate and zoom level.
//        let centerCoordinate = CLLocationCoordinate2D(latitude: 38.875, longitude: -77.035)
//        let camera = CameraOptions(center: centerCoordinate, zoom: 12.0)
//        self.mapView.mapboxMap.setCamera(to: camera)
//        }
        
        
        
    }
    
//    func addStyleLayers() {
//        // Specify the source IDs. They will be assigned to their respective sources when we
//        // add the source to the map's style.
//        let museumSourceId = "museum-source"
//        let contourSourceId = "contour-source"
//
//        // Create a custom vector tileset source. This source contains point features
//        // that represent museums.
//        var museumsSource = VectorSource()
//        museumsSource.url = "mapbox://mapbox.2opop9hr"
//
//        var museumLayer = CircleLayer(id: museumLayerId)
//
//        // Assign this layer's source.
//        museumLayer.source = museumSourceId
//        // Specify the layer within the vector source to render on the map.
//        museumLayer.sourceLayer = "museum-cusco"
//
//        // Use a constant circle radius and color to style the layer.
//        museumLayer.circleRadius = .constant(8)
//
//        // `visibility` is `nil` by default. Set to `visible`.
//        museumLayer.visibility = .constant(.visible)
//
//        let museumColor = UIColor(red: 0.22, green: 0.58, blue: 0.70, alpha: 1.00)
//        museumLayer.circleColor = .constant(StyleColor(museumColor))
//
//        var contourSource = VectorSource()
//        // Add the Mapbox Terrain v2 vector tileset. Documentation for this vector tileset
//        // can be found at https://docs.mapbox.com/vector-tiles/reference/mapbox-terrain-v2/
//        contourSource.url = "mapbox://mapbox.mapbox-terrain-v2"
//
//        var contourLayer = LineLayer(id: contourLayerId)
//
//        // Assign this layer's source and source layer ID.
//        contourLayer.source = contourSourceId
//        contourLayer.sourceLayer = "contour"
//
//        // Style the contents of the source's contour layer.
//        contourLayer.lineCap = .constant(.round)
//        contourLayer.lineJoin = .constant(.round)
//
//        // `visibility` is `nil` by default. Set to `visible`.
//        contourLayer.visibility = .constant(.visible)
//        let contourLineColor = UIColor(red: 0.53, green: 0.48, blue: 0.35, alpha: 1.00)
//        contourLayer.lineColor = .constant(StyleColor(contourLineColor))
//
//        let style = mapView.mapboxMap.style
//
//        // Add the sources and layers to the map's style.
//        do {
//        try style.addSource(museumsSource, id: museumSourceId)
//        try style.addSource(contourSource, id: contourSourceId)
//        try style.addLayer(museumLayer)
//        try style.addLayer(contourLayer)
//        } catch {
//            print("Error when adding sources and layers: \(error.localizedDescription)")
//        }
//    }
    
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
