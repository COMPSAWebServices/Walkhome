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
        
        let whPin = CustomAnnotation()
        whPin.coordinate = CLLocationCoordinate2DMake(44.228454, -76.494484)
        whPin.title = "WalkHome HQ"
        whPin.imageName = "WalkHomeHQ"
        
        let csPin = CustomAnnotation()
        csPin.coordinate = CLLocationCoordinate2DMake(44.225315, -76.498425)
        csPin.title = "Campus Security"
        csPin.imageName = "CampusSecurity"

        mapView.addAnnotation(whPin)
        mapView.addAnnotation(csPin)

        
        // Isabel Centre Blue Lights x2, West Campus x10, Harkness x2, Goodes x7, Stauffer x2, JDUC x2, Kin x1, ARC x6, Dupuis x1, WLH x2, Miller x1, Bruce Wing x1, Katheen Ryan x2, Nicol x1, Gordon x1, Douglas x1, Fleming x2, Grant x1, Kingston x1, Nixon Underground x4, Founders Row x1, Earl Hall x1, BioSci x1, Cataraqui x1, Cancel Research Institute x1, Wally x2, KGH x1, MCLaughlin x1
        // To do: Add the blue lights on campus, and make the option to hide the blue lights
        let blLat = [44.220355, 44.221264, 44.224576, 44.223813, 44.224725, 44.225449, 44.227653, 44.226679, 44.225250, 44.224528, 44.223522, 44.229975, 44.230088, 44.230081, 44.228578, 44.228498, 44.228491, 44.228047, 44.227789, 44.227700, 44.227732, 44.228022, 44.229008, 44.228843, 44.228082, 44.228845, 44.228902, 44.228995, 44.229276, 44.229394, 44.229377, 44.229693, 44.228681, 44.228223, 44.227765, 44.227637, 44.226912, 44.226770, 44.226356, 44.227219, 44.226975, 44.227729, 44.226595, 44.226315, 44.226039, 44.225501, 44.225376, 44.224644, 44.224671, 44.224452, 44.225414, 44.227114, 44.226312, 44.225717, 44.224966, 44.224838, 44.224116, 44.223397, 44.222783, 44.224435, 44.223787]
        let blLong = [-76.507071, -76.506446, -76.509949, -76.513372, -76.513421, -76.514355, -76.514087, -76.516331, -76.516608, -76.516004, -76.515209, -76.516415, -76.497494, -76.497933, -76.497471,  -76.497948, -76.498151, -76.497865, -76.497740, -76.498158, -76.498021, -76.496618, -76.495883, 76.495386, -76.494686, -76.493141, -76.494458, -76.494284, -76.494703, -76.494104, -76.493692, -76.494316, -76.492179, -76.491696, -76.491683, -76.492972, -76.493336, -76.492542, -76.492495, -76.493992, -76.494643,  -76.495372, -76.494231, -76.494045, -76.494819, -76.494505, -76.495151, -76.494424, -76.493998, -76.495275, -76.492918, -76.490860, -76.491681, -76.491152, -76.490990, -76.491794, -76.491418, -76.491611, -76.491114, -76.493697, -76.495562]
        let size = blLat.count
        
        for i in 0..<size {
            let blPin = CustomAnnotation()
            blPin.coordinate = CLLocationCoordinate2DMake(blLat[i], blLong[i])
            blPin.title = "Blue Light"
            blPin.imageName = "BlueLight"
            mapView.addAnnotation(blPin)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
