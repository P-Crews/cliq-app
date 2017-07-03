//
//  MapViewController.swift
//  cliq
//
//  Created by Paul Crews on 6/23/17.
//  Copyright © 2017 Madacien. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import SDWebImage

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var manager = CLLocationManager()
    var updateCount = 0
    var artists = artistLocation()
    var long = [Double]()
    var lat = [Double]()
    var i = 0
    var artist : [Users] = []
    let fbArtist = Users()
    override func viewDidLoad() {
        super.viewDidLoad()
//        FIRDatabase.database().reference().child("Users").observe(FIRDataEventType.value, with: { (snip) in
//            let snap = snip.value as! NSDictionary
//            
//            print("Snip Count: \(snap)")
//            for _ in 1...snap.count{
//            }
//        })
        FIRDatabase.database().reference().child("Users").observe(FIRDataEventType.childAdded, with: { (snapshot) in
            let snap = snapshot.value as! NSDictionary
            
            self.artists.long = snap["Long"] as! Double
            self.artists.lat = snap["Lat"] as! Double
            self.fbArtist.city = snap["City"] as! String
            self.fbArtist.email = snap["Email"] as! String
            self.fbArtist.imageURL = snap["Image"] as! String
            self.fbArtist.name = snap["Name"] as! String
            self.artist.append(self.fbArtist)
            //print("Snap count is \(snap.count)")
            print("FB Artist \(self.fbArtist.name)")
            self.long.append(self.artists.long)
            self.lat.append(self.artists.lat)
            //print("\(snap)")
            //print("LAT: \(snap["Long"] as! Double) {} LONG: \(snap["Lat"] as! Double)")
            //print("LAT: \(self.artists.lat as! Double) {} LONG: \(self.artists.long as! Double)")
        })
        
        manager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            
            mapView.delegate = self
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
            
            
           Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (timer) in
            
                if let coord = self.manager.location?.coordinate{
                    let anno = rap(coord: coord, artist: self.artist[Int(arc4random_uniform(UInt32(self.artist.count)))])
                    anno.coordinate.longitude = self.long[self.i]
                    anno.coordinate.latitude = self.lat[self.i]
                    
                    print("LAT: \(self.lat[self.i]) ~~~ LONG: \(self.long[self.i])")
                    
                    self.mapView.addAnnotation(anno)
                    
                    if self.i < self.long.count - 1{
                        
                         self.i += 1

            
                    }else{
                        timer.invalidate()
                    }
            }
           })
        }else{
                manager.requestWhenInUseAuthorization()
        }
        
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation{
            let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            
            annoView.image = UIImage(named: "rapper")
            
            var frame = annoView.frame
            
            frame.size.height = 50
            frame.size.width = 40
            
            annoView.frame = frame
            return annoView
        }else{
            let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            let use = (annotation as! rap).rappers
            var locImg = use.imageURL
            
            annoView.canShowCallout = true
            annoView.image = UIImage(named: "rapper-2")
        
        var frame = annoView.frame
        
        frame.size.height = 50
        frame.size.width = 40
        
        annoView.frame = frame
        return annoView
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if updateCount < 3{
            
        let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 500, 500)

        mapView.setRegion(region, animated: true)
            updateCount += 1
        }else{
            manager.stopUpdatingLocation()
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation!, animated: true)
        
        if view.annotation! is MKUserLocation{
            return
        }
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 500, 500)
        
        mapView.setRegion(region, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            
            if let coord = self.manager.location?.coordinate{
                if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)){
                    let alertVC = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        
                        
                    })
                    alertVC.addAction(okAction)
                    self.present(alertVC, animated: true, completion: nil)
                }else{
                    let alertVC = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        
                        
                    })
                    alertVC.addAction(okAction)
                    self.present(alertVC, animated: true, completion: nil)
                }
        }
        }
    }
    
    @IBAction func centerLocation(_ sender: Any) {
        if let coord = manager.location?.coordinate{
        let region = MKCoordinateRegionMakeWithDistance(coord, 500, 500)
        
        mapView.setRegion(region, animated: true)
        }
    }
}
