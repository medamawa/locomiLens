//
//  LocomiViewController.swift
//  ARCoreLocationLesson
//
//  Created by sogo on 2020/08/20.
//  Copyright © 2020 Sogo Nishihara. All rights reserved.
//

import UIKit

class LocomiViewController: UIViewController {
    
    override func viewDidLoad() {
        view.backgroundColor = .systemIndigo
        
        let url = URL(string: "locomi://")!
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: {
                    (success) in
                    print("Open \(success)")
                })
            }else{
                UIApplication.shared.openURL(url)
            }
        }
    }
    
}
