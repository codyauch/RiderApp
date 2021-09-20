//
//  ViewController.swift
//  Rider
//
//  Created by Cody Auch on 2020-04-27.
//  Copyright © 2020 Cody Auch. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var compassImageView: UIImageView!
    @IBOutlet weak var speedLabel: UILabel!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if CLLocationManager.locationServicesEnabled() { //makes sure location services are enabled
            initializeMapView()
        }
    }
    
    func initializeMapView() {
        locationManager = CLLocationManager() //initialize the location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization() //request location permission
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        mapView.showsUserLocation = true //puts the user's location on the map
        mapView.isRotateEnabled = false //prevents the user from manually rotating the map
        mapView.mapType = MKMapType.hybrid //sets the map type to hybrid
        mapView.showsCompass = false //hides the MKMapView compass
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        // last location in the CLLocation array
//        let location = locations.last!
//
//        // sets the centre of the map to the location set above
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//
//        // sets how much of the map is shown
//        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//
//        // sets the region of the map that should be shown
//        let region = MKCoordinateRegion(center: center, span: span)
//
//
//        // actually shows the region set above
//        self.mapView.setRegion(region, animated: false)
//
        // Calculate the users speed and display it in the UI
        speedLabel.text = String(formatSpeed(speed: locationManager.location!.speed)) + " KM/H"
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        // Follows the user without a CLLocationManagerDelegate
        mapView.userTrackingMode = .followWithHeading
        
        // Rotates the mapView based on which way the user is facing
        mapView.camera.heading = newHeading.trueHeading
        mapView.setCamera(mapView.camera, animated: true)
        
        // Rotate the compass icon based on the users heading
        let angle = newHeading.trueHeading * (.pi / -180) // converts the compass bearing to radians
        compassImageView.transform = CGAffineTransform(rotationAngle: CGFloat(angle)) // rotates the UIImage
        
        // Calculate the users speed and display it in the UI
        //speedLabel.text = String(formatSpeed(speed: locationManager.location!.speed)) + " KM/H"
    }
    
    func formatSpeed(speed: Double) -> Int {
        let kmhSpeed = speed * 3.6 // convert from m/s to km/h
        
        if kmhSpeed <= 0 {
            return 0
        }
        return Int(kmhSpeed)
    }
    
}

