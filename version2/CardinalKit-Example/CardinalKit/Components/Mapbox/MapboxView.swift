//
//  MapboxView.swift
//  CardinalKit_Example
//
//  Created by Esteban Ramos on 19/04/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import MapboxMaps

struct MapManagerViewWrapper: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = MapManagerView
    
    func makeUIViewController(context: Context) -> MapManagerView {
        return MapManagerView()
    }
    
    func updateUIViewController(_ uiViewController: MapManagerView, context: Context) {
        
    }
}

class MapManagerView: UIViewController {
    internal var mapView: MapView!
    var trackingButton:UIButton?=nil
    let pointsFetcher = AlternovaLocationFetcher.shared
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(frame: CGRect(x: 200, y: 35, width: 350, height: 50))
        button.center.x = view.center.x
        
        // TODO: add if location is tracking or not
        
        button.setTitle("stop", for: .normal)
        button.backgroundColor = .red
        
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(startStopTracking), for: .touchUpInside)
        button.layer.cornerRadius = 10
        
        trackingButton = button
        
        self.view.addSubview(button)
        
        mapView = MapView(frame: CGRect(x: 0, y: 120, width: 480, height: 480))
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(mapView)
        
        MapboxMap.initialiceMap(mapView: mapView, reload: true)
        mapView.location.options.puckType = .puck2D()
    }
    
    @objc
    func startStopTracking(){
        pointsFetcher.startStopTracking()
        
        if pointsFetcher.tracking{
            self.trackingButton?.setTitle("stop", for: .normal)
            self.trackingButton?.backgroundColor = .systemRed
        }
        else{
            self.trackingButton?.setTitle("start", for: .normal)
            self.trackingButton?.backgroundColor = .systemBlue
        }
    }
    
}