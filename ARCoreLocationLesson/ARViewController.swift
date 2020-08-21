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

class ARViewController: UIViewController {
    
    var sceneLocationView = SceneLocationView()
    var spotsData: [(CLLocation, UIImage)] = []
    var comics: [Comic]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        comics = APIRequest().getNearComics(latitude: "34.821413", longitude: "135.538147")
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
    
    @objc func onTap(sender: UIButton) {
        comics = APIRequest().getNearComics(latitude: "34.821413", longitude: "135.538147")
        
        for comic in comics! {
            let coordinate = CLLocationCoordinate2D(latitude: comic.lat, longitude: comic.lng)
            let location = CLLocation(coordinate: coordinate, altitude: 30)
            let image = Utility().drawText(text: comic.text)
            spotsData.append((location, image!))
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataLoad"), object: nil)
        print(spotsData)
    }

}
