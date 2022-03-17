//
//  DownloadManager.swift
//  CardinalKit
//
//  Created by Julian Esteban Ramos Martinez on 6/08/21.
//

import Foundation

class DownloadManager: NSObject {
    public static let shared = DownloadManager()
    
    func fetchData(route: String, onCompletion: @escaping (Any) -> Void){
        if let customDelegate = CKApp.instance.options.networkReceiverDelegate{
            customDelegate.request(route: route, onCompletion: onCompletion)
        }
        else{
            // Return surveys by defect
        }
    }
    
    func fetchFilteredData(route: String, child: String, date:Date, onCompletion: @escaping (Any)->Void){
        if let customDelegate = CKApp.instance.options.networkReceiverDelegate{
            customDelegate.requestFilter(route: route,child:child,date:date, onCompletion: onCompletion)
        }
        else{
            // Return surveys by defect
        }
        
    }
    
}
