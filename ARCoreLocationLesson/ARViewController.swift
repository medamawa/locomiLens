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

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let coordinate1 = CLLocationCoordinate2D(latitude: 34.812323475848686, longitude: 135.53659200668335)
        let location1 = CLLocation(coordinate: coordinate1, altitude: 30)
        let image1 = Utility().drawText(image: UIImage(named: "pocky")!, text: "万博公園")
        let coordinate2 = CLLocationCoordinate2D(latitude: 34.822259043034734, longitude: 135.5382227897644)
        let location2 = CLLocation(coordinate: coordinate2, altitude: 30)
        let image2 = Utility().drawText(image: UIImage(named: "pocky")!, text: "ゴルフ場")
        spotsData = [(location1, image1!), (location2, image2!)]
        
        Utility().addLocations(sceneLocationView: sceneLocationView, spotsData: spotsData)
        
        sceneLocationView.run()

        view.addSubview(sceneLocationView)
    }

    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()

      sceneLocationView.frame = view.bounds
    }

}
