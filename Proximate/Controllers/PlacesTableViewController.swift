//
//  PlacesTableViewController.swift
//  Proximate
//
//  Created by Rivaldo Fernandes on 28/01/23.
//

import UIKit
import MapKit

class PlacesTableViewController: UITableViewController {
    var userLocation: CLLocation
    var places: [PlaceAnnotation]
    
    init(userLocation: CLLocation, places: [PlaceAnnotation]) {
        self.userLocation = userLocation
        self.places = places
        super.init(nibName: nil, bundle: nil)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "place_cell")
        self.places.swapAt(indexForSelectionRow ?? 0, 0)
    }
    
    private var indexForSelectionRow: Int? {
        self.places.firstIndex(where: { $0.isSelected == true })
    }
    
    private func calculateDistance(from: CLLocation, to: CLLocation) -> CLLocationDistance{
        from.distance(from: to)
    }
    
    private func formatDistanceForDisplay(_ distance: CLLocationDistance) -> String {
        let meters = Measurement(value: distance, unit: UnitLength.meters)
//        return meters.converted(to: .miles).formatted()
        return meters.formatted()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "place_cell", for: indexPath)
        let place = places[indexPath.row]
        
        //cell configuration
        var content = cell.defaultContentConfiguration()
        content.text = place.name
        
        let distance = calculateDistance(from: userLocation, to: place.location)
        content.secondaryText = formatDistanceForDisplay(distance)
        
        cell.contentConfiguration = content
        cell.backgroundColor = place.isSelected ? UIColor.lightGray : UIColor.clear
        return cell
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

