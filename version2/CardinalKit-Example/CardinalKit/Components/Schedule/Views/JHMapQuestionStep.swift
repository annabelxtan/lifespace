//
//  JHMapQuestionStep.swift
//  CardinalKit_Example
//
//  Created by Julian Esteban Ramos Martinez on 8/12/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import ResearchKit
import UIKit
import SwiftUI
import MapboxMaps

public class JHMapQuestionStep: ORKQuestionStep{
    public override init(identifier: String){
        super.init(identifier: identifier)
        self.answerFormat = ORKAnswerFormat.booleanAnswerFormat()
    }
    
    @available(*, unavailable)
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class JHMapQuestionStepViewController: ORKQuestionStepViewController, LocationPermissionsDelegate{
    internal var mapView: MapView!
    public override func viewDidLoad() {
        let QuestionLabel = UILabel(frame: CGRect(x: 0, y: 60, width: 450, height: 50 ))
        QuestionLabel.center.x = view.center.x
        QuestionLabel.text = "Is this map of your daily activity accurate?"
        QuestionLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(QuestionLabel)
        
        let myResourceOptions = ResourceOptions(accessToken: "sk.eyJ1IjoicG9sbG93ZjgiLCJhIjoiY2t3ZWRlZW1xMDNtNDJ2cHdzdGE2NGs5ZiJ9.g8IODwKuRVo9a6kAlyyIYQ")
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions)
        mapView = MapView(frame: CGRect(x: 0, y: 120, width: 400, height: 400), mapInitOptions: myMapInitOptions)
        mapView.center.x = view.center.x
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.addSubview(mapView)
        
        let button = UIButton(frame: CGRect(x: 0, y: 450, width: 350, height: 50))
        button.center.x = view.center.x
        button.setTitle("Yes", for: .normal)
        button.setTitleColor(.white,for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.addTarget(self,action: #selector(OnClickYesButton),for: .touchUpInside)
        self.view.addSubview(button)
        
        let noButton = UIButton(frame: CGRect(x: 0, y: 505, width: 350, height: 50))
        noButton.center.x = view.center.x
        noButton.setTitle("No", for: .normal)
        noButton.setTitleColor(.white,for: .normal)
        noButton.layer.cornerRadius = 10
        noButton.backgroundColor = .systemBlue
        noButton.addTarget(self,action: #selector(OnClickNoButton),for: .touchUpInside)
        self.view.addSubview(noButton)
        
        self.view.backgroundColor = .white
        MapboxMap.initialiceMap(mapView: mapView, reload: false)
        
        
    }
    
    @objc func OnClickYesButton(){
        self.setAnswer(true)
        super.goForward()
    }
    
    @objc
    func OnClickNoButton(){
        self.setAnswer(false)
        super.goForward()
        
    }
    // Selector that will be called as a result of the delegate below
    func requestPermissionsButtonTapped() {
        mapView.location.requestTemporaryFullAccuracyPermissions(withPurposeKey: "CustomKey")
    }
}
