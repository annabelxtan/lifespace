//
//  MapboxMap.swift
//  CardinalKit_Example
//
//  Created by Esteban Ramos on 7/03/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import MapboxMaps

class MapboxMap {
    public static func initialiceMap(mapView: MapView){
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
                try mapView.mapboxMap.style.addSource(source, id: "SOURCE_ID")
                var circlesLayer = CircleLayer(id: "LAYER_ID")
                circlesLayer.source =  "SOURCE_ID"
                circlesLayer.circleColor = .constant(StyleColor.init(.red))
                circlesLayer.circleStrokeColor = .constant(StyleColor.init(.black))
                circlesLayer.circleStrokeWidth = .constant(2)
                try mapView.mapboxMap.style.addLayer(circlesLayer, layerPosition: .above("country-label"))
                mapView.mapboxMap.setCamera(
                    to: CameraOptions(
                        center: LocationFetcher.sharedinstance.lastKnownLocation,
                        zoom: 14.0
                    )
                )


            } catch {
              print("error adding source or layer: \(error)")
            }
        })
    }
}
