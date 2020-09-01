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
    
    @State var isShowing = false
    
    var body: some View {
        
        if APIRequest().getAuth() {
            
            UserInfo(id: UserID().getID())
            
        } else {
            
            Button(action: { self.isShowing.toggle() }) {
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
                .sheet(isPresented: $isShowing) {
                    LoginView(isShowing: self.$isShowing)
                }
            }
            
        }
        
    }
    
}

struct UserInfo: View {
    
    @State private var showingLogout = false
    @State var id = ""
    @State var screen_name = "---"
    @State var name = "---"
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Image("user_icon")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 60, height: 60)
                    .padding(8)
                
                VStack(alignment: .leading) {
                    
                    Text("\(self.screen_name)")
                    
                    Text("@\(self.name)")
                        .foregroundColor(.gray)
                        .font(.callout)
                }
                
            }
            .onAppear {
                APIRequest().getSpecifiedUser(self.id) { User in
                    self.screen_name = User[0].screen_name
                    self.name = User[0].name
                }
                
            }
            
            Button(action: { self.showingLogout.toggle() }) {
                Text("logout")
                    .foregroundColor(Color.white)
                    .padding(3)
                    .background(Color.blue)
                    .cornerRadius(5)
            }.sheet(isPresented: $showingLogout) {
                Logout(isShowing: self.$showingLogout)
            }
            
        }
        
    }
    
}
