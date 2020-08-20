//
//  LocomiViewController.swift
//  ARCoreLocationLesson
//
//  Created by sogo on 2020/08/20.
//  Copyright © 2020 Sogo Nishihara. All rights reserved.
//

import UIKit
import SwiftUI

class LocomiViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc: UIHostingController = UIHostingController(rootView: LocomiView())
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
        
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.heightAnchor.constraint(equalToConstant: 320).isActive = true
        vc.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        vc.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        vc.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
}


struct LocomiView: View {
    
    var body: some View {
        
        Button(action: {
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
        }) {
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                Text("locomi")
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                Image(systemName: "arrowshape.turn.up.right")
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
            }
            .padding(.all)
            .background(Color.blue)
            .cornerRadius(10)
        }
        
    }
    
}
