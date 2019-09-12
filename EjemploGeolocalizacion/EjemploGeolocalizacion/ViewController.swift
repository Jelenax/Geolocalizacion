//
//  ViewController.swift
//  EjemploGeolocalizacion
//
//  Created by Isaac Velazquez on 06/01/18.
//  Copyright © 2018 MobileStudio. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var btnSatelite: UIButton!
    @IBOutlet var btnHybrid: UIButton!
    @IBOutlet var btnNormal: UIButton!
    
    var manager: CLLocationManager!
    var lonUser: Double = 0.0
    var latUser: Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        startGetLocation()
    }
    
    func startGetLocation() {
        manager = CLLocationManager()
        manager.requestAlwaysAuthorization()
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        
        manager.startUpdatingLocation()
    }
    
    func centerMap() {
        let center = CLLocationCoordinate2D(latitude: latUser,
                                            longitude: lonUser)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05,
                                    longitudeDelta: 0.05)
        
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: true)
        
        mapView.showsUserLocation = true
    }
    
    @IBAction func changeStyle(_ sender: UIButton) {
        switch sender {
        case btnNormal:
            mapView.mapType = .standard
            break
        case btnHybrid:
            mapView.mapType = .hybrid
            break
        case btnSatelite:
            mapView.mapType = .satellite
            break
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alert = UIAlertController(title: "Ups!",
                                      message: "No pudimos encontrarte en este planeta",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            print("Ubicacion \(location.coordinate.longitude) , \(location.coordinate.latitude)")
            
            latUser = location.coordinate.latitude
            lonUser = location.coordinate.longitude
            
            centerMap()
        }
    }
}
