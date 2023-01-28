//
//  PlacesAnnotation.swift
//  Proximate
//
//  Created by Rivaldo Fernandes on 28/01/23.
//

import Foundation
import MapKit

class PlaceAnnotation: MKPointAnnotation {
    let mapItem: MKMapItem
    let id = UUID()
    var isSelected: Bool = false
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
        super.init()
        self.coordinate = mapItem.placemark.coordinate
    }
    
    var name: String {
        mapItem.name ?? ""
    }
    
    var phone: String {
        mapItem.phoneNumber ?? ""
    }
    
    var location: CLLocation {
        mapItem.placemark.location ?? CLLocation.default
    }
    
    var address: String {
        "\(mapItem.placemark.subThoroughfare ?? "") \(mapItem.placemark.thoroughfare ?? "") \(mapItem.placemark.locality ?? "") \(mapItem.placemark.countryCode ?? "")"
    }
}
