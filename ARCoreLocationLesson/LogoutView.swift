//
//  LogoutView.swift
//  ARCoreLocationLesson
//
//  Created by sogo on 2020/09/02.
//  Copyright © 2020 Sogo Nishihara. All rights reserved.
//

import SwiftUI


struct Logout: View {
    
    @Binding var isShowing: Bool
    
    var body: some View {
        
        NavigationView {
            
            Form {
                
                Section {
                    
                    Button(action: {
                        
                        AccessToken().removeToken()
                        RefreshToken().removeToken()
                        UserID().removeID()
                        // モーダルを閉じる
                        self.isShowing = false
                        
                    }) {
                        
                        Text("ログアウトする")
                        
                    }
                    
                }
                
            }
            .navigationBarTitle("ログアウト")
            
        }
        
    }
    
}
