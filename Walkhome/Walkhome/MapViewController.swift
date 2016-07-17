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
        //let pin = MKPointAnnotation()
        //pin.coordinate = CLLocationCoordinate2DMake(44.228454, -76.494484)
        //pin.title = "Walkhome HQ"
        //mapView.addAnnotation(pin)
        
        /*
        var pin1 = CustomAnnotation()
        pin1.coordinate = CLLocationCoordinate2DMake(44.228454, -76.494484)
        pin1.title = "WalkHome HQ"
        pin1.imageName = "WalkHomeHQ"
        
        var pin2 = CustomAnnotation()
        pin2.coordinate = CLLocationCoordinate2DMake(44.2253833,-76.499311)
        pin2.title = "Somewhere"
        pin2.imageName = "MapMarker"

        mapView.addAnnotation(pin1)
        mapView.addAnnotation(pin2)
        */
        
        // WalkHome HQ, Campus Security, Isabel Centre Blue Lights x2, West Campus x9
        let colocLat = [44.228454, 44.2253833, 44.220355, 44.221264, 44.224576, 44.223813, 44.224725, 44.225449, 44.227653, 44.226679, 44.225250, 44.224528, 44.223522]
        let colocLong = [-76.494484, -76.499311, -76.507071, -76.506446, -76.509949, -76.513372, -76.513421, -76.514355, -76.514087, -76.516331, -76.516608, -76.516004, -76.515209]
        let colocImage = ["WalkHomeHQ", "Current", "MapMarker", "MapMarker", "MapMarker", "MapMarker", "MapMarker", "MapMarker", "MapMarker", "MapMarker", "MapMarker", "MapMarker", "MapMarker"]
        let colocTitle = ["WalkHome HQ", "Campus Security", "Blue Light", "Blue Light", "Blue Light", "Blue Light", "Blue Light", "Blue Light", "Blue Light", "Blue Light", "Blue Light", "Blue Light", "Blue Light"]
        let size = colocLat.count
        
        for i in 0..<size {
            let pin = CustomAnnotation()
            pin.coordinate = CLLocationCoordinate2DMake(colocLat[i], colocLong[i])
            pin.title = colocTitle[i]
            pin.imageName = colocImage[i]
            mapView.addAnnotation(pin)
        }
        
        
 
        let region = MKCoordinateRegionMakeWithDistance(
            (locationManager.location?.coordinate)!, 2000, 2000)
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        
        var customV = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if customV == nil {
            customV = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            customV!.canShowCallout = true
        }
        else {
            customV!.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
        let cpa = annotation as! CustomAnnotation
        customV!.image = UIImage(named:cpa.imageName)
        
        return customV
    }
    
    /*
    func mapView(mapView: MKMapView,
                 viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) { return nil }
        
        let reuseID = "test"
        var customV = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
        
        if customV != nil {
            customV!.annotation = annotation
        } else {
            customV = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            
            customV!.image = UIImage(named:"WalkHomeHQ")
        }
        
        return customV
    }
    */
    
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
