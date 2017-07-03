//
//  map.swift
//  cliq
//
//  Created by Paul Crews on 6/20/17.
//  Copyright © 2017 Madacien. All rights reserved.
//

import UIKit
import MapKit


class artistLocation {
    
    var long:Double = 0.0
    var lat:Double = 0.0
}
class rap : NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var rappers: Users
    
    init(coord: CLLocationCoordinate2D, artist: Users) {
        self.coordinate = coord
        self.rappers = artist
    }
}
class imgName : MKPointAnnotation{
    var image: MKAnnotationView
    var imgnm: String
    var img: UIImageView
    init(pic: MKAnnotationView, picName: String, picView: UIImageView){
        self.image = pic
        self.imgnm = picName
        self.img = picView
    }
}
