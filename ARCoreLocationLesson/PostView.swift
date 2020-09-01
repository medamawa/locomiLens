//
//  PostView.swift
//  ARCoreLocationLesson
//
//  Created by sogo on 2020/08/21.
//  Copyright © 2020 Sogo Nishihara. All rights reserved.
//

import SwiftUI
import MapKit

struct PostView: View {
    
    @ObservedObject private var locationManager = LocationManager()
    @State var showText = false
    @State var latString = ""
    @State var lngString = ""
    @State var text = ""
    @State var release = "0"
    @State var selected = 0
    @State var birthDate = Date()
    @State var isShowing = false
    
    // クロージャーを保持するためのプロパティ
    var postCallBack: ((PostData) -> Void)?
    
    var body: some View {
        
        let coordinate = self.locationManager.location != nil ? self.locationManager.location!.coordinate: CLLocationCoordinate2D()
        let altitude = self.locationManager.location?.altitude ?? 0.0
        
        return NavigationView {
            
            Form {
                
                if APIRequest().getAuth() {
                    Text("ログイン済みです")
                    
                    Section(header: Text("位置情報、標高")) {
                        Text("緯度：\(coordinate.latitude)")
                        Text("経度：\(coordinate.longitude)")
                        Text("標高：\(altitude)")
                    }
                    
                    Section(header: Text("本文を入力")) {
                        TextField("投稿の本文を入力してください", text: $text)
                    }
                    
                    Section {
                        Button(action: {
                            let postData = PostData(lat: String(coordinate.latitude), lng: String(coordinate.longitude), altitude: self.locationManager.location?.altitude, text: self.text, release: self.release)
                            APIRequest().post(postData)
                            
                            //completionのタイミングでプロパティのクロージャを実行
                            //親ビュー(ARViewController)に投稿した内容を反映させる
                            self.postCallBack?(postData)
                        }) {
                            Text("投稿する")
                        }
                    }
                } else {
                    Text("ログインしていません")
                    
                    Section {
                        Button(action: { self.isShowing.toggle() }) {
                            Text("ログインする")
                                .sheet(isPresented: $isShowing) {
                                    LoginView(isShowing: self.$isShowing)
                                }
                        }
                    }
                }
                
            }.navigationBarTitle("投稿の作成")
            
        }
        
    }
    
}
