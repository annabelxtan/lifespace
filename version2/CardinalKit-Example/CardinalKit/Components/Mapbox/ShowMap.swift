//
//  MapView.swift
//  CardinalKit_Example
//
//  Created by Alternova Dev on 25/11/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//


import SwiftUI
import MapboxMaps

struct MapViewWrapper : UIViewControllerRepresentable {
    
    typealias UIViewControllerType = ShowMap
        
    func makeUIViewController(context: Context) -> ShowMap {
        return ShowMap()
    }
    
    func updateUIViewController(_ uiViewController: ShowMap, context: Context) {
        
    }
}

class ShowMap: UIViewController {
 
    internal var mapView: MapView!
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        
        let myResourceOptions = ResourceOptions(accessToken: "sk.eyJ1IjoicG9sbG93ZjgiLCJhIjoiY2t3ZWRlZW1xMDNtNDJ2cHdzdGE2NGs5ZiJ9.g8IODwKuRVo9a6kAlyyIYQ")
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions)
        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         
        self.view.addSubview(mapView)
    }
    
}
