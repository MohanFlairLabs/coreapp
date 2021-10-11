//
//  CrashlyticsController.swift
//  app
//
//  Created by Admin on 20/09/21.
//

import Foundation
import Firebase
import FirebaseCrashlytics
import FirebaseCore

class CrashlyticsController: NSObject {
    
    @objc class func configureFabric() {
        
        let plistPath = Bundle.main.path(forResource: ApplicationController.googlePlistFileName, ofType: "plist")
        guard let fileopts = FirebaseOptions(contentsOfFile: plistPath!)
            else { assert(false, "Couldn't load config file") }
        FirebaseApp.configure(options: fileopts)
        
    }
    
    
}
