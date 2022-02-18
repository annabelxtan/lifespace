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

//
//
//import MapboxMaps
//
//@objc(AnimateImageLayerExample)
//class AnimateImageLayerExample: UIViewController {
//    var mapView: MapView!
//    var sourceId = "radar-source"
//    var timer: Timer?
//    var imageNumber = 0
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let center = CLLocationCoordinate2D(latitude: 41.874, longitude: -75.789)
//        let cameraOptions = CameraOptions(center: center, zoom: 5)
//        let mapInitOptions = MapInitOptions(cameraOptions: cameraOptions, styleURI: .dark)
//        mapView = MapView(frame: view.bounds, mapInitOptions: mapInitOptions)
//        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//
//        // Hide the `scaleBar` at all zoom levels.
//        mapView.ornaments.options.scaleBar.visibility = .hidden
//
//        // This also updates the color of the info button to match the map's style.
//        mapView.tintColor = .lightGray
//
//        // Set the map's `CameraBoundsOptions` to limit the map's zoom level.
//        try? mapView.mapboxMap.setCameraBounds(with: CameraBoundsOptions(maxZoom: 5.99, minZoom: 4))
//
//        view.addSubview(mapView)
//
//        mapView.mapboxMap.onNext(.mapLoaded) { _ in
//            self.addImageLayer()
//        }
//    }
//
//    func addImageLayer() {
//        let style = mapView.mapboxMap.style
//
//        // Create an `ImageSource`. This will manage the image displayed in the `RasterLayer` as well
//        // as the location of that image on the map.
//        var imageSource = ImageSource()
//
//        // Set the `coordinates` property to an array of longitude, latitude pairs.
//        imageSource.coordinates = [
//            [-80.425, 46.437],
//            [-71.516, 46.437],
//            [-71.516, 37.936],
//            [-80.425, 37.936]
//        ]
//
//        // Get the file path for the first radar image, then set the `url` for the `ImageSource` to that path.
//        let path = Bundle.main.path(forResource: "radar0", ofType: "gif")!
//        imageSource.url = path
//
//        // Create a `RasterLayer` that will display the images from the `ImageSource`
//        var imageLayer = RasterLayer(id: "radar-layer")
//        imageLayer.source = sourceId
//
//        // Set `rasterFadeDuration` to `0`. This prevents visible transitions when the image is updated.
//        imageLayer.rasterFadeDuration = .constant(0)
//
//        do {
//            try style.addSource(imageSource, id: sourceId)
//            try style.addLayer(imageLayer)
//
//            // Add a tap gesture recognizer that will allow the animation to be stopped and started.
//            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(manageTimer))
//            mapView.addGestureRecognizer(tapGestureRecognizer)
//        } catch {
//            print("Failed to add the source or layer to style. Error: \(error)")
//        }
//        manageTimer()
//    }
//
//    @objc func manageTimer() {
//        if timer == nil {
//            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
//                guard let self = self else { return }
//
//                // There are five radar images, number 0-4. Increment the count. When that would
//                // result in an `imageNumber` value greater than 4, reset `imageNumber` to `0`.
//                if self.imageNumber < 4 {
//                    self.imageNumber += 1
//                } else {
//                    self.imageNumber = 0
//                }
//                // Create a `UIImage` from the file at the specified path.
//                let path = Bundle.main.path(forResource: "radar\(self.imageNumber)", ofType: "gif")
//                let image = UIImage(contentsOfFile: path!)
//
//                do {
//                    // Update the image used by the `ImageSource`.
//                    try self.mapView.mapboxMap.style.updateImageSource(withId: self.sourceId, image: image!)
//                } catch {
//                    print("Failed to update style image. Error: \(error)")
//                }
//            }
//        } else {
//            timer?.invalidate()
//            timer = nil
//        }
//    }
//
//    deinit {
//        timer?.invalidate()
//    }
//}
