//
//  ViewController.swift
//  Proximate
//
//  Created by Rivaldo Fernandes on 28/01/23.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    lazy var mapView: MKMapView = {
       let map = MKMapView()
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    private func setupUI(){
        view.addSubview(mapView)
        
        //add constraint mapview
        NSLayoutConstraint.activate([
            mapView.widthAnchor.constraint(equalTo: view.widthAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor),
            mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        
        ])
        
    }

}

