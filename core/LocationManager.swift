//
//  LocationManager.swift
//  app
//
//  Created by Admin on 18/08/21.
//
import CoreLocation
import UIKit

typealias locationCompletionHandler = (_ location: CLLocation?,_ status: Bool) -> Void

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private static var privateSharedInstance: LocationManager?
    
    static var sharedInstance: LocationManager = {
        
        if privateSharedInstance    == nil {
            privateSharedInstance = LocationManager()
        }
        
        return privateSharedInstance!
    }()
    
    var completionHandler: locationCompletionHandler?
    
    var currentLocation: CLLocation?    =   nil
    
    var locationManager: CLLocationManager?
    
    
    static func destroyInstance() {
        privateSharedInstance   =   nil
    }
    
    
    func setUpLocationManager() {
        initiateLocationManager()
//        locationManager.delegate        =   self
//        locationManager.desiredAccuracy =   CLLocationAccuracy.greatestFiniteMagnitude
    }
    
    private func initiateLocationManager() {
        if locationManager  ==  nil {
            locationManager                     =   CLLocationManager()
            locationManager?.delegate           =   self
            locationManager?.desiredAccuracy    =   kCLLocationAccuracyBest
        }
    }
    
    func resetCurrentLocation() {
        currentLocation =   nil
    }
    
    func isLocationServiceEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            initiateLocationManager()
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                resetCurrentLocation()
                return false
            case .restricted:
                resetCurrentLocation()
                return false
            case .denied:
                resetCurrentLocation()
                return false
            case .authorizedAlways:
                locationManager?.startUpdatingLocation()
                return true
            case .authorizedWhenInUse:
                locationManager?.startUpdatingLocation()
                return true
            @unknown default:
                resetCurrentLocation()
                return false
            }
        }else {
            return false
        }
    }
    
    func requestLocationAuthorization() {
        if !self.isLocationServiceEnabled() {
            initiateLocationManager()
            if CLLocationManager.authorizationStatus() == .notDetermined || CLLocationManager.authorizationStatus() == .restricted {
                locationManager?.requestAlwaysAuthorization()
            }else {
                showLocationPermissionAlert()
            }
        }
    }

    func getLocationCoordinates(for VC: UIViewController? = nil, onCompletion: @escaping (_ location: CLLocation?,_ status: Bool) -> Void) {
        completionHandler   =   onCompletion
        requestLocationAuthorization()
    }
    
    func checkForLocationPermission() {
        requestLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation =   locations.last
        if let handler = completionHandler {
            handler(currentLocation, true)
        }
        manager.stopUpdatingLocation()
       
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        resetCurrentLocation()
        if let handler = completionHandler {
            handler(nil, false)
        }
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .notDetermined:
                
                resetCurrentLocation()
                initiateLocationManager()
                locationManager?.stopUpdatingLocation()
            case .restricted, .denied:
                
                resetCurrentLocation()
                initiateLocationManager()
                locationManager?.stopUpdatingLocation()
            case .authorizedAlways, .authorizedWhenInUse:
                
                initiateLocationManager()
                locationManager?.startUpdatingLocation()
            @unknown default:
                
                resetCurrentLocation()
                locationManager?.stopUpdatingLocation()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined, .restricted, .denied:
            resetCurrentLocation()
            initiateLocationManager()
            locationManager?.stopUpdatingLocation()
        case .authorizedAlways, .authorizedWhenInUse:
            initiateLocationManager()
            locationManager?.requestLocation()
        @unknown default:
            locationManager?.stopUpdatingLocation()
        }
    }
    private func showLocationPermissionAlert() {
        
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        
        let VC   =   UIApplication.shared.getTopViewController()
        
        let alertController = UIAlertController(title: NSLocalizedString("Enable Location Services for better results", comment: ""), message: NSLocalizedString("Do you want to enable Location Service for this app?", comment: ""), preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        
        let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        VC.present(alertController, animated: true, completion: nil)
    }
    func getLocationStatus() -> String {
        initiateLocationManager()
        
        var locationStatus: CLAuthorizationStatus?
        
        if #available(iOS 14.0, *) {
            if let status = locationManager?.authorizationStatus {
                locationStatus  =   status
            }
        } else {
            locationStatus = CLLocationManager.authorizationStatus()
        }
        
        if let currentLocationStatus = locationStatus {
            switch currentLocationStatus {
            case .notDetermined:
                return "NOT ALLOWED YET"
            case .restricted:
                return "LOCATION RESTRICTED"
            case .denied:
                return "LOCATION DENIED"
            case .authorizedAlways:
                return "LOCATION AUTHORISED ALWAYS"
            case .authorizedWhenInUse:
                return "LOCATION AUTHORISED WHEN IN USE"
            @unknown default:
                return "LOCATION NOT DETERMINED"
            }
        }else {
            return "NO LOCATION STATUS"
        }
    }
}

