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
    public static func initialiceMap(mapView: MapView, reload: Bool){
        
        
        mapView.mapboxMap.onNext(.mapLoaded) { _ in
            print("map is charged?")
            var allLocations = [CLLocationCoordinate2D]()
            allLocations = LocationFetcher.sharedinstance.allLocations
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
                if reload{
                    LocationFetcher.sharedinstance.locationsWereUpdated = { locations in
                        do{
                            try mapView.mapboxMap.style.updateGeoJSONSource(withId: "SOURCE_ID", geoJSON: .feature(Feature(geometry: .lineString(LineString(locations)))))
                        }
                        catch{
                            print("error updating points")
                        }
                    }
                }
            } catch {
              print("error adding source or layer: \(error)")
            }
        }
    }
}
