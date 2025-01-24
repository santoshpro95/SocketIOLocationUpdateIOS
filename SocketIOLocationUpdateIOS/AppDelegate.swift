//
//  AppDelegate.swift
//  SocketIOLocationUpdateIOS
//
//  Created by Santosh Kumar on 18/01/25.
//

import UIKit
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        registerForLocalNotifications()
        return true
    }
    
    // Local notification permission
       func registerForLocalNotifications() {
           let center = UNUserNotificationCenter.current()
           center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
               if let error = error {
                   print("Notification permission error: \(error)")
               } else if granted {
                   print("Notification permission granted")
               }
           }
       }

    // Location updates
       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           guard let location = locations.last else { return }
           print("Significant location change detected: \(location)")
           
           // Show local notification
           showLocalNotification(for: location)
       }
       
       // Show local notification
       func showLocalNotification(for location: CLLocation) {
           let content = UNMutableNotificationContent()
           content.title = "Significant Location Change"
           content.body = "Your new location is: \(location.coordinate.latitude), \(location.coordinate.longitude)"
           content.sound = .default
           
           let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
           UNUserNotificationCenter.current().add(request) { error in
               if let error = error {
                   print("Failed to schedule notification: \(error)")
               }
           }
       }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

