//
//  StorageDetailsViewController.swift
//  GraduateWork
//
//  Created by Matvey Semenov on 29.04.23.
//

import UIKit
import MapKit

class StorageDetailsViewController: UIViewController {

    let storage: Storage

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

    init(storage: Storage) {
        self.storage = storage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white

        view.addSubview(mapKitView)
        view.addSubview(storageNameLabel)
        view.addSubview(storageAddressLabel)

        mapKitView.translatesAutoresizingMaskIntoConstraints = false
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

    override func viewDidLoad() {
        super.viewDidLoad()

        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(storage.address, completionHandler: { [weak self] (placemarks, error) in
            guard let self = self, error == nil else {
                return
            }

            if let placemarks = placemarks { // array of placemarks (geocodes/coordinates of address)
                // get first placemark
                let placemark = placemarks[0]
                // add annotation
                let annotation = MKPointAnnotation()
                annotation.title = self.storage.name

                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    // display annotation
                    self.mapKitView.showAnnotations([annotation], animated: true) // show pin
                    self.mapKitView.selectAnnotation(annotation, animated: true) // show buble
                }
            }
        })

        storageNameLabel.text = storage.name
        storageAddressLabel.text = storage.address
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

