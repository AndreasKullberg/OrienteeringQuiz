//
//  MapViewController.swift
//  OrienteeringQuiz
//
//  Created by Andreas Kullberg on 2019-04-09.
//  Copyright © 2019 Andreas Kullberg. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class MapViewController: UIViewController, fbListenerProtocol {
    func addQuizzes(quizzes: [Quiz]) {
        addAnnotions(quizzes: quizzes)

        print(quizzes[0].latitude)
    }
    
    @IBOutlet weak var mapView: MKMapView!
   
    
    let locationManager = CLLocationManager()
    
    let fbHelper = FBHelper()
    var quizzes: [Quiz] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationservices()
        fbHelper.quizzesDelegate = self
        fbHelper.readQuizFromDatabase()
        fbHelper.addQuizToDatabase()
        
        //print(quizzes[0].name)
        //addAnnotions(quizzes: quizzes)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func setupLoccationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationservices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLoccationManager()
            checkLocationAuthorization()
        }
        else{
            // Säg åt användaren att sätta på locations i settings
        }
    }
    
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate{ // coordinate longitud och latitud
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.setRegion(region, animated: true)
        }
        
    }
    
    func checkLocationAuthorization()  {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.stopUpdatingLocation()
            break
        case .denied:
            break
        case .notDetermined:
            //(locationManeger.requestAlwaysAuthorization() eventuellt använda denna
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .authorizedAlways:
            // Får tillgång till platsinformation när appen är stängd, kan behövas om man ska få notis.
            break
        }
    }

    func addAnnotions(quizzes: [Quiz]) {
        
        for quiz in quizzes {
            print(quiz.name)
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(quiz.latitude as! CLLocationDegrees, quiz.longitude as! CLLocationDegrees)
            mapView.addAnnotation(annotation)
        }
    }

}

extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {return}
        
        let centre = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: centre, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
        
        // do stuff
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        checkLocationAuthorization()
    }
    
    
}
