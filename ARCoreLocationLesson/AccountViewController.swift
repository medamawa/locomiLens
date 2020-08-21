//
//  AccountViewController.swift
//  ARCoreLocationLesson
//
//  Created by sogo on 2020/08/21.
//  Copyright © 2020 Sogo Nishihara. All rights reserved.
//

import UIKit
import SwiftUI

class AccountViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc: UIHostingController = UIHostingController(rootView: AccountView())
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


struct AccountView: View {
    
    @State private var showingLogin = false
    
    var body: some View {
        
        Button(action: { self.showingLogin.toggle() }) {
            HStack {
                Image(systemName: "person")
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                Text("Login")
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                Image(systemName: "arrow.right")
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
            }
            .padding(.all)
            .background(Color.blue)
            .cornerRadius(10)
            .sheet(isPresented: $showingLogin) {
                LoginView()
            }
        }
        
    }
    
}
