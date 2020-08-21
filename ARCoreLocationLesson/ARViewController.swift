//
//  ViewController.swift
//  ARCoreLocationLesson
//
//  Created by sogo on 2020/08/19.
//  Copyright © 2020 Sogo Nishihara. All rights reserved.
//

import UIKit
import ARCL
import CoreLocation

class ARViewController: UIViewController, CLLocationManagerDelegate {
    
    var sceneLocationView = SceneLocationView()
    var locationManager: CLLocationManager!
    var spotsData: [(CLLocation, UIImage)] = []
    var comics: [Comic]?
    var location: CLLocation? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        
        let coordinate = self.locationManager.location != nil ? self.locationManager.location!.coordinate: CLLocationCoordinate2D()
        print(String(coordinate.latitude))
        print(String(coordinate.longitude))
        
        comics = APIRequest().getNearComics(latitude: String(coordinate.latitude), longitude: String(coordinate.longitude))
        for comic in comics! {
            let coordinate = CLLocationCoordinate2D(latitude: comic.lat, longitude: comic.lng)
            let location = CLLocation(coordinate: coordinate, altitude: 45)
            let image = Utility().drawText(text: comic.text)
            spotsData.append((location, image!))
        }
        print(spotsData)
        
        Utility().addLocations(sceneLocationView: sceneLocationView, spotsData: spotsData)
        
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        
        let button = UIButton(type: .system)
        button.setTitle("更新する", for: .normal)
        button.sizeToFit()
        button.center = view.center
        button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        view.addSubview(button)
    }
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()

      sceneLocationView.frame = view.bounds
    }
    
    // 位置情報取得 start
    func setupLocationManager() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()

        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        self.location = location
    }
    // 位置情報取得 end
    
    @objc func onTap(sender: UIButton) {
        // データ初期化
        spotsData = []
        
        comics = APIRequest().getNearComics(latitude: "34.821413", longitude: "135.538147")
        
        for comic in comics! {
            let coordinate = CLLocationCoordinate2D(latitude: comic.lat, longitude: comic.lng)
            print(self.location?.altitude)
            let location = CLLocation(coordinate: coordinate, altitude: self.location?.altitude ?? 10)
            let image = Utility().drawText(text: comic.text)
            spotsData.append((location, image!))
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataLoad"), object: nil)
        print(spotsData)
    }

}
