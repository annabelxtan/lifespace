//
//  PermissionLocationUIView.swift
//  CardinalKit_Example
//
//  Created by Aternova on 9/12/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI

struct PermissionLocationUIView: View {
    
    let color: Color
    let config = CKPropertyReader(file: "CKConfiguration")
    
    @ObservedObject var locationFetcher = LocationFetcher()
    
    init(onComplete: (() -> Void)? = nil) {
        
        self.color = Color(config.readColor(query: "Primary Color"))
        
    }
    
    var body: some View {
        
        VStack(spacing: 10) {
            Image("CKLogo")
                .resizable()
                .scaledToFit()
                .padding(.leading, Metrics.PADDING_HORIZONTAL_MAIN*4)
                .padding(.trailing, Metrics.PADDING_HORIZONTAL_MAIN*4)
            
            Text("To ensure the collection of the information, it is necessary to authorize the use of the location for the application")
                .multilineTextAlignment(.leading)
                .font(.system(size: 18, weight: .bold, design: .default))
                .padding(.leading, Metrics.PADDING_HORIZONTAL_MAIN*2)
                .padding(.trailing, Metrics.PADDING_HORIZONTAL_MAIN*2)
            
            Text("Step one: when you click on the button a window will appear in which you must select Allow While Using App.")
                .multilineTextAlignment(.leading)
                .font(.system(size: 18, weight: .regular, design: .default))
                .padding(.leading, Metrics.PADDING_HORIZONTAL_MAIN*2)
                .padding(.trailing, Metrics.PADDING_HORIZONTAL_MAIN*2)
            
            //Spacer()
            
            HStack {
                Spacer()
                Button(action: {
                    locationFetcher.requestAuthorizationLocation()
                    if(!locationFetcher.validateAuthorizationLocation()){
                      //  locationFetcher.messageWhenValidateAuthorizationLocationFail()
                    }
                    
                }, label: {
                     Text("Step One")
                        .padding(Metrics.PADDING_BUTTON_LABEL)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(self.color)
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .overlay(
                                    RoundedRectangle(cornerRadius: Metrics.RADIUS_CORNER_BUTTON)
                                        .stroke(self.color, lineWidth: 2)
                            )
                })
                .padding(.leading, Metrics.PADDING_HORIZONTAL_MAIN)
                .padding(.trailing, Metrics.PADDING_HORIZONTAL_MAIN)
        
                Spacer()
            }
 
            //Spacer()
            Text("Step two: click on the button and a window will appear where you must select Change to Always Allow.")
                .multilineTextAlignment(.leading)
                .font(.system(size: 18, weight: .regular, design: .default))
                .padding(.leading, Metrics.PADDING_HORIZONTAL_MAIN*2)
                .padding(.trailing, Metrics.PADDING_HORIZONTAL_MAIN*2)
            
            HStack {
                
                Spacer()
                Button(action: {
                    
                    locationFetcher.requestAuthorizationLocation()
                    if(locationFetcher.validateAuthorizationLocation()){
                        LaunchModel.sharedinstance.showPermissionView = true
                        locationFetcher.start()
                    }
                    else{
                        //locationFetcher.messageWhenValidateAuthorizationLocationFail()
                    }
                    
                }, label: {
                     Text("Step Two")
                        .padding(Metrics.PADDING_BUTTON_LABEL)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(self.color)
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .overlay(
                                    RoundedRectangle(cornerRadius: Metrics.RADIUS_CORNER_BUTTON)
                                        .stroke(self.color, lineWidth: 2)
                            )

                })
                .padding(.leading, Metrics.PADDING_HORIZONTAL_MAIN)
                .padding(.trailing, Metrics.PADDING_HORIZONTAL_MAIN)
        
                Spacer()
            }
            
            Spacer()
            
            Image("SBDLogoGrey")
                .resizable()
                .scaledToFit()
                .padding(.leading, Metrics.PADDING_HORIZONTAL_MAIN*4)
                .padding(.trailing, Metrics.PADDING_HORIZONTAL_MAIN*4)
            
        }
    }
    
}

struct PermissionLocationUIView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionLocationUIView()
    }
}
