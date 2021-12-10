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
            
            Text("In order to improve the collection of the location system, it is necessary that the corresponding permissions are given. You will then need to authorize as follows")
                .multilineTextAlignment(.leading)
                .font(.system(size: 18, weight: .regular, design: .default))
                .padding(.leading, Metrics.PADDING_HORIZONTAL_MAIN*2)
                .padding(.trailing, Metrics.PADDING_HORIZONTAL_MAIN*2)
            
            //Spacer()
            
            HStack {
                Spacer()
                Button(action: {
                    locationFetcher.requestAuthorizationLocation()
                }, label: {
                     Text("Step One")
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
 
            //Spacer()
            Text("Instruction for step two")
                .multilineTextAlignment(.leading)
                .font(.system(size: 18, weight: .regular, design: .default))
                .padding(.leading, Metrics.PADDING_HORIZONTAL_MAIN*2)
                .padding(.trailing, Metrics.PADDING_HORIZONTAL_MAIN*2)
            
            HStack {
                Spacer()
                Button(action: {
                    locationFetcher.requestAuthorizationLocation()
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
