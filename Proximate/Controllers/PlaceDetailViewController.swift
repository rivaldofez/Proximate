//
//  PlaceDetailViewController.swift
//  Proximate
//
//  Created by Rivaldo Fernandes on 28/01/23.
//

import UIKit

class PlaceDetailViewController: UIViewController {
    let place: PlaceAnnotation
    
    
    
    
    init(place: PlaceAnnotation){
        self.place = place
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        
    }
}
