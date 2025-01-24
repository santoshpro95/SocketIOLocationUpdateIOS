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
        
        // requestNotificationPermission
        requestNotificationPermission()
     
        // Set up location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true // Allow updates in the background
        locationManager.pausesLocationUpdatesAutomatically = false // Keep updating continuously
        locationManager.requestAlwaysAuthorization() // Request "Always" permission
               
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
                self.locationManager.startMonitoringSignificantLocationChanges()
            }
        }
    }

    // Delegate method called when location updates
       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           guard let location = locations.last else { return }
           let latitude = location.coordinate.latitude
           let longitude = location.coordinate.longitude
           
           SocketManagerService.shared.emit(event: "message", data: "Location updated: Latitude: \(latitude), Longitude: \(longitude)")
      
           showNotification(title: "Location", body: "Update Location", identifier: "Tracking");
       }
       
       // Handle errors
       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("Failed to find user's location: \(error.localizedDescription)")
       }
    
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error)")
            } else if granted {
                print("Permission granted")
            } else {
                print("Permission denied")
            }
        }
    }
    
    // MARK: Show Notification
    func showNotification(title: String, body: String, identifier: String){
            let userNotificationCenter = UNUserNotificationCenter.current()
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = title
            notificationContent.body = body
            notificationContent.badge = NSNumber(value: 0)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: identifier,
                                                content: notificationContent,
                                                trigger: trigger)

            userNotificationCenter.add(request) { (error) in
                if let error = error {
                    print("Notification Error: ", error)
                }
            }
        }
    
}

