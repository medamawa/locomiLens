//
//  LoginView.swift
//  ARCoreLocationLesson
//
//  Created by sogo on 2020/08/21.
//  Copyright © 2020 Sogo Nishihara. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @State var showText = false
    @State var email = ""
    @State var password = ""
    @State var selected = 0
    @State var birthDate = Date()
    
    var body: some View {
        
        NavigationView {
            
            Form {
                
                Section(header: Text("メールアドレス入力")) {
                    
                    TextField("メールアドレスを入力してください", text: $email)
                    
                }
                
                Section(header: Text("パスワード入力")) {
                    
                    TextField("パスワードを入力してください", text: $password)
                    
                }
                
                Section {
                    
                    Button(action: {
                        let loginData = LoginData(email: self.email, password: self.password);
                        APIRequest().postLogin(loginData)
                    }) {
                        
                        Text("ログインする")
                        
                    }
                    
                }
                
            }
            .navigationBarTitle("ログイン")
            
        }
        
    }
    
}
