//
//  MapViewController.swift
//  Walkhome
//
//  Created by Raymond Chung on 2016-07-16.
//  Copyright © 2016 COMPSA Web Services. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager() //This will give us the user's current location

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Map"
        mapView.delegate = self
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        //let lat = locationManager.location!.coordinate.latitude
        //let long = locationManager.location!.coordinate.longitude
        //print ("Latitude", lat, "Longitude: ", long)
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2DMake(44.228454, -76.494484)
        pin.title = "Walkhome HQ"
        mapView.addAnnotation(pin)
        let region = MKCoordinateRegionMakeWithDistance(
            (locationManager.location?.coordinate)!, 2000, 2000)
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(mapView: MKMapView,
                 viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) { return nil }
        
        let reuseID = "chest"
        var customV = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
        
        if customV != nil {
            customV!.annotation = annotation
        } else {
            customV = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            
            customV!.image = UIImage(named:"MapMarker")
        }
        
        return customV
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
