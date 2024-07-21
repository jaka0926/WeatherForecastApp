//
//  MapViewController.swift
//  WeatherForecast
//
//  Created by Jaka on 2024-07-21.
//

import Foundation
import SnapKit
import MapKit


class MapViewController: UIViewController {
    
    var mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.toolbar.isHidden = true
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
