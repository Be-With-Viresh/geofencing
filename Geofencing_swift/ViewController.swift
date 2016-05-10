//
//  ViewController.swift
//  Geofencing_swift
//
//  Created by Viresh Madabhavi on 06/05/16.
//  Copyright © 2016 Viresh Madabhavi. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var mapview: MKMapView!
    var locationManager: CLLocationManager?
    var usersCurrentLocation:CLLocationCoordinate2D?
    var localNotification: UILocalNotification?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = CLLocationManager()
        
        if CLLocationManager.authorizationStatus() == .NotDetermined{
            locationManager?.requestAlwaysAuthorization()
        }
        
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = 200
        locationManager?.delegate = self
        startUpdatingLocation()
        
        usersCurrentLocation = CLLocationCoordinate2DMake(19.474540, 72.829875)
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegionMake(usersCurrentLocation!, span)
        mapview.setRegion(region, animated: true)
        mapview.delegate = self
        mapview.showsUserLocation = true
        
        // Add annotation to Mapview
        let usersCurrentAnnotation = MKPointAnnotation()
        usersCurrentAnnotation.coordinate = usersCurrentLocation!
        usersCurrentAnnotation.title = "Built.io"
        usersCurrentAnnotation.subtitle = "Virar"
        mapview.addAnnotation(usersCurrentAnnotation)
        
        // Initilaise Local notification
        
        localNotification = UILocalNotification()
        localNotification?.fireDate = NSDate(timeIntervalSinceNow: 5)
        localNotification?.timeZone = NSTimeZone.defaultTimeZone()
        
    }
    
    //MARK: CLLocationManagerDelegate methods
    
    func startUpdatingLocation() {
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        self.locationManager?.stopUpdatingLocation()
    }
    
    //MARK: Geofencing methods
    
    func regionWithGeofencing()-> CLCircularRegion {
        
        let monitoringRegion = CLCircularRegion(center: usersCurrentLocation!, radius: 50, identifier: "Built.io")
        locationManager?.startMonitoringForRegion(monitoringRegion)
        monitoringRegion.notifyOnEntry = true
        monitoringRegion.notifyOnExit = true
        
        return monitoringRegion
        
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion){
        print("Entered the Region")
        localNotification?.alertBody = "Entered the Region"
        localNotification?.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification!)
        
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion){
        print("Exited the Region")
        localNotification?.alertBody = "Exited the Region"
        localNotification?.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification!)
    }
    
    // MARK: MKMapViewDelegate
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation){
        mapview.centerCoordinate = userLocation.location!.coordinate
        mapview.showsUserLocation = true
        regionWithGeofencing()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

