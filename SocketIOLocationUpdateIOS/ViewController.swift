//
//  ViewController.swift
//  SocketIOLocationUpdateIOS
//
//  Created by Santosh Kumar on 18/01/25.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()

    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        SocketManagerService.shared.connect()
        
        
        // Set up location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true // Allow updates in the background
        locationManager.pausesLocationUpdatesAutomatically = false // Keep updating continuously
        locationManager.requestAlwaysAuthorization() // Request "Always" permission
               
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
            }
        }
    }

    // Delegate method called when location updates
       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           guard let location = locations.last else { return }
           let latitude = location.coordinate.latitude
           let longitude = location.coordinate.longitude
           
           SocketManagerService.shared.emit(event: "message", data: "Location updated: Latitude: \(latitude), Longitude: \(longitude)")
       }
       
       // Handle errors
       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("Failed to find user's location: \(error.localizedDescription)")
       }
    
}

