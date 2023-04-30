//
//  StorageDetailsViewController.swift
//  GraduateWork
//
//  Created by Matvey Semenov on 29.04.23.
//

import UIKit
import MapKit

class StorageDetailsViewController: UIViewController {

    let locationManager = CLLocationManager()
    
    var mapKitView : MKMapView = {
        var mapKit = MKMapView()
        mapKit.layer.borderColor = UIColor.darkGray.cgColor
        mapKit.layer.borderWidth = 1
        mapKit.layer.cornerRadius = 10
        return mapKit
    }()
    var storageNameLabel : UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.text = "Cклад №1"
        return label
    }()
    var storageAddressLabel : UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "Пр. Независимости 87"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(mapKitView)
        view.addSubview(storageNameLabel)
        view.addSubview(storageAddressLabel)
        
        mapKitView.translatesAutoresizingMaskIntoConstraints = false
        mapKitView.delegate = self
        NSLayoutConstraint.activate([
            mapKitView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            mapKitView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            mapKitView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            mapKitView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        storageNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            storageNameLabel.topAnchor.constraint(equalTo: mapKitView.bottomAnchor, constant: 30),
            storageNameLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            storageNameLabel.widthAnchor.constraint(equalToConstant: 100),
            storageNameLabel.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        storageAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            storageAddressLabel.topAnchor.constraint(equalTo: storageNameLabel.bottomAnchor, constant: 15),
            storageAddressLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            storageAddressLabel.widthAnchor.constraint(equalToConstant: 180),
            storageAddressLabel.heightAnchor.constraint(equalToConstant: 34)
        ])
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationEnable()
    }
    func checkLocationEnable() {
        if CLLocationManager.locationServicesEnabled() {
            setupManager()
            checkAuthorization()
        } else {
            showAlertLocation(title: "Система геолокации выключена", message: "Хотите ее включить?", url: URL(string: "App-Prefs:root=LOCATION_SERVICES"))
        }
    }
    func setupManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func checkAuthorization() {
        switch CLLocationManager.authorizationStatus(){
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapKitView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            break
        case .denied:
            showAlertLocation(title: "Использование геолокации запрещено", message: "Хотите ее включить?", url: URL(string: UIApplication.openSettingsURLString))
            break
        case .restricted:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func showAlertLocation(title: String, message: String?, url: URL?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Настройки", style: .default) { (alert) in
            if let url = URL(string: "App-Prefs:root=LOCATION_SERVICES"){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension StorageDetailsViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate{
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 2000, longitudinalMeters: 2000)
            mapKitView.setRegion(region, animated: true)
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorization()
    }
}
extension StorageDetailsViewController : MKMapViewDelegate {
    
}

