//
//  ViewController.swift
//  ARCoreLocationLesson
//
//  Created by sogo on 2020/08/19.
//  Copyright © 2020 Sogo Nishihara. All rights reserved.
//

import UIKit
import SwiftUI
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
            var altitude: Double = 45
            if comic.altitude != nil {
                altitude = comic.altitude!
            }
            let location = CLLocation(coordinate: coordinate, altitude: altitude)
            let image = Utility().drawText(text: comic.text)
            spotsData.append((location, image!))
        }
        print(spotsData)
        
        Utility().addLocations(sceneLocationView: sceneLocationView, spotsData: spotsData)
        
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        
        let button = UIButton(type: .custom)
        let weightConfig = UIImage.SymbolConfiguration(weight: .heavy)
        let scaleConfig = UIImage.SymbolConfiguration(scale: .large)
        let imageConfig = scaleConfig.applying(weightConfig)
        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        let blue = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1)
        
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = blue
        button.layer.borderWidth = 4
        button.layer.borderColor = blue.cgColor
        button.layer.cornerRadius = 30
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 10
        
        let x = self.view.frame.maxX - 80
        let y = self.tabBarController!.tabBar.frame.origin.y - 110
        button.frame = CGRect(x: x, y: y, width: 60, height: 60)
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
        let postView = UIHostingController(rootView: PostView())
        self.present(postView, animated: true, completion: nil)
    }

}
