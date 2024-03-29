//
//  ViewController.swift
//  Proximate
//
//  Created by Rivaldo Fernandes on 28/01/23.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    var locationManager: CLLocationManager?
    private var places : [PlaceAnnotation] = []
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.layer.cornerRadius = 10
        searchTextField.delegate = self
        searchTextField.clipsToBounds = true
        searchTextField.backgroundColor = .systemBackground
        
        searchTextField.textColor = .label
        searchTextField.placeholder = "Search"
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        searchTextField.leftViewMode = .always
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        return searchTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize location manager
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
        
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    private func setupUI(){
        
        view.addSubview(searchTextField)
        
        //add constraint searchTextField
        NSLayoutConstraint.activate([
            searchTextField.heightAnchor.constraint(equalToConstant: 44),
            searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTextField.widthAnchor.constraint(equalToConstant: view.bounds.size.width / 1.2),
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 60)
        ])
        searchTextField.returnKeyType = .go
        
        
        view.addSubview(mapView)
        view.bringSubviewToFront(searchTextField)
        
        //add constraint mapview
        NSLayoutConstraint.activate([
            mapView.widthAnchor.constraint(equalTo: view.widthAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor),
            mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
    private func checkLocationAuthorization(){
        guard let locationManager = locationManager,
              let location = locationManager.location else { return }
        
        switch locationManager.authorizationStatus {
            
        case .authorizedWhenInUse, .authorizedAlways:
            print("")
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 750, longitudinalMeters: 750)
            mapView.setRegion(region, animated: true)
        case .denied:
            print("Location services has been denied")
        case .notDetermined, .restricted:
            print("Location restricted or cannot be determined")
        @unknown default:
            print("Error occured")
            
        }
    }
    
    private func presentPlacesSheet(places: [PlaceAnnotation]){
        
        guard let locationManager = locationManager, let userLocation = locationManager.location else { return }
        
        let placesTableViewController = PlacesTableViewController(userLocation: userLocation , places: places)
        placesTableViewController.modalPresentationStyle = .pageSheet
        
        if let sheet = placesTableViewController.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            present(placesTableViewController, animated: true)
        }
    }
    
    private func findNearbyPlaces(by query: String){
        //clear annotations in maps
        mapView.removeAnnotations(mapView.annotations)
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let response = response, error == nil else { return }
            
            self?.places = response.mapItems.map(PlaceAnnotation.init)
            self?.places.forEach { place in
                self?.mapView.addAnnotation(place )
            }
            if let places = self?.places {
                self?.presentPlacesSheet(places: places)
            }
            
        }
    }
}

extension ViewController: MKMapViewDelegate {
    
    private func clearAllSelections(){
        self.places = self.places.map{ place in
            place.isSelected = false
            return place
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        
        //clear all selections
        clearAllSelections()
        
        guard let selectedAnnotation = annotation as? PlaceAnnotation else { return }
        
        let placeAnnotation = self.places.first(where: { $0.id == selectedAnnotation.id})
        placeAnnotation?.isSelected = true
        
        presentPlacesSheet(places: self.places)
    }
}


extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text ?? ""
        if !text.isEmpty {
            textField.resignFirstResponder()
            
            //find nearby places
            findNearbyPlaces(by: text)
        }
        
        return true
    }
}
