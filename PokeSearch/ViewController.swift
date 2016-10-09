//
//  ViewController.swift
//  PokeSearch
//
//  Created by Evgeny Vlasov on 10/5/16.
//  Copyright © 2016 Evgeny Vlasov. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var mapHasCenteredOnce = false
    var geoFire:GeoFire!
    var geoFireRef: FIRDatabaseReference!
    
    var poke: Pokemon!
    var loc: CLLocation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        geoFireRef = FIRDatabase.database().reference()
        geoFire = GeoFire(firebaseRef: geoFireRef)
        
//        locationAuthStatus()

    }

    override func viewDidAppear(_ animated: Bool) {
        locationAuthStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        if poke != nil {
            
            mapHasCenteredOnce = true
            createSighting(forLocation: loc, withPokemon: poke.pokemonId)
            
            centerMapOnLocation(location: loc, animated: false)
        }
    }
    
    
    func locationAuthStatus () {
       
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
    
    func centerMapOnLocation (location: CLLocation, animated: Bool) {
        
        if animated == true {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        mapView.setRegion(coordinateRegion, animated: true)
        } else if animated == false {
            
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
            
            print(loc.coordinate)
            
            mapView.setRegion(coordinateRegion, animated: false)
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let loc = userLocation.location {
            if !mapHasCenteredOnce {
                centerMapOnLocation(location: loc, animated: true)
                mapHasCenteredOnce = true
            }
            
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView: MKAnnotationView!
        var annoIdentifier = "Pokemon"
        
        if annotation.isKind(of: MKUserLocation.self) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            annotationView.image = UIImage(named: "ash")
        } else if let deqAnno = mapView.dequeueReusableAnnotationView(withIdentifier: annoIdentifier) {
            
            annotationView = deqAnno
            annotationView?.annotation = annotation
        } else {
            
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annoIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av
        }
        
        if let annotationView = annotationView, let anno = annotation as? PokeAnnotation {
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "\(anno.pokemonNumber)")
            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn.setImage(UIImage(named: "map"), for: .normal)
            annotationView.rightCalloutAccessoryView = btn
        }
        
        return annotationView
    }
    
    
    func createSighting(forLocation location: CLLocation, withPokemon pokemonId: Int) {
        
        geoFire.setLocation(location, forKey: "\(pokemonId)")
        print("Sighting Created.")
    }
    
    func showSightingsOnMap(location: CLLocation) {
        
        let circleQuery = geoFire!.query(at: location, withRadius: 2.5)
        _ = circleQuery?.observe(GFEventType.keyEntered, with: { (key, location) in
            
            if let key = key, let location = location {
               let anno = PokeAnnotation(coordinate: location.coordinate, pokemonNumber: Int(key)!)
                self.mapView.addAnnotation(anno)
            
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        showSightingsOnMap(location: loc)
        

    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let anno = view.annotation as? PokeAnnotation {
           
            var place: MKPlacemark!
            
            if #available(iOS 10.0, *) {
                place = MKPlacemark(coordinate: anno.coordinate)
            } else {
                place = MKPlacemark(coordinate: anno.coordinate, addressDictionary: nil)
            }
            
            
            let destination = MKMapItem(placemark: place)
            destination.name = "Pokemon Sighting"
            let regionDistance: CLLocationDistance = 1000
            let regionSpan = MKCoordinateRegionMakeWithDistance(anno.coordinate, regionDistance, regionDistance)
            
            let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span), MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving] as [String : Any]
            
            MKMapItem.openMaps(with: [destination], launchOptions: options)
        }
    }
    
    @IBAction func spotRandomPokemon(_ sender: AnyObject) {
    
        loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        performSegue(withIdentifier: "ChoosePokemonVC", sender: loc)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChoosePokemonVC" {
            if let choosePokeVC = segue.destination as? ChoosePokemonVC {
                if let loc = sender as? CLLocation {
                    
                    choosePokeVC.loc = loc
                }
            }
        }
    }

}












