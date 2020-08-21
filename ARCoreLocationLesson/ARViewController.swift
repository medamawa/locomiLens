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
        
//        let coordinate1 = CLLocationCoordinate2D(latitude: 34.812323475848686, longitude: 135.53659200668335)
//        let location1 = CLLocation(coordinate: coordinate1, altitude: 30)
//        let image1 = Utility().drawText(text: "万博公園ー太陽の塔だよ。文字数稼ぎよわあ")
//
//        let coordinate2 = CLLocationCoordinate2D(latitude: 34.822259043034734, longitude: 135.5382227897644)
//        let location2 = CLLocation(coordinate: coordinate2, altitude: 30)
//        let image2 = Utility().drawText(text: "ゴルフ場")
//        spotsData = [(location1, image1!), (location2, image2!)]
        
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
