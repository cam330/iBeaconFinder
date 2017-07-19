//
//  ViewController.swift
//  beaconFinder
//
//  Created by Cameron Wilcox on 7/18/17.
//  Copyright © 2017 Cameron Wilcox. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet var latLabel: UILabel!
    @IBOutlet var lngLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "5122CBA8-9020-40B5-A252-AC84F6041A02")!, identifier: "Estimotes")
    var longitude = String()
    var latitude = String()
    
    let annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeacons(in: region)
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
//        locationManager.requestLocation()
    }

    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let knownBeacons = beacons.filter{$0.proximity != CLProximity.unknown}

        let trimmed = String(format: "%.2", longitude)
//        print(trimmed)
        
        
        
        if knownBeacons.count > 0 {
            let closestBeacon = knownBeacons[0] as CLBeacon
//            print(closestBeacon)
            var lbl = closestBeacon.accuracy
            distanceLabel.text = String(format: "%.2f", arguments: [lbl])
            
            let latValue = Int(closestBeacon.major) * 2
            let lngValue = Int(closestBeacon.minor) * 2
            
            latLabel.text = longitude + String(lngValue)
            lngLabel.text = latitude + String(latValue)
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: Double(latitude + String(latValue))!, longitude: Double(longitude + String(lngValue))!)
            mapView.addAnnotation(annotation)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        // get the particular pin that was tapped
        let pinToZoomOn = view.annotation
        
        // optionally you can set your own boundaries of the zoom
        let span = MKCoordinateSpanMake(0.1, 0.1)
        
        // or use the current map zoom and just center the map
        // let span = mapView.region.span
        
        // now move the map
        let region = MKCoordinateRegion(center: pinToZoomOn!.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
//        let location = locations[0]
        

        
        let when = DispatchTime.now() + 1
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            if let location = locations.first {
                self.longitude = String(location.coordinate.longitude)
                let lngRange: Range<String.Index> = self.longitude.range(of: ".")!
                let lngIndex: Int = self.longitude.distance(from: self.longitude.startIndex, to: lngRange.lowerBound)
                print(lngIndex)
                
                self.latitude = String(location.coordinate.latitude)
                let latRange: Range<String.Index> = self.latitude.range(of: ".")!
                let latIndex: Int = self.latitude.distance(from: self.latitude.startIndex, to: latRange.lowerBound)

                let lngTrimIndex = self.longitude.index(self.longitude.startIndex, offsetBy: lngIndex+2)
                self.longitude = self.longitude.substring(to: lngTrimIndex)
                let latTrimIndex = self.latitude.index(self.latitude.startIndex, offsetBy: latIndex+2)
                self.latitude = self.latitude.substring(to: latTrimIndex)
                print(self.longitude)
                print(self.latitude)
            }
        }
        
    }
    
    
}

