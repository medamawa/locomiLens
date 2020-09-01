//
//  ViewController.swift
//  ARCoreLocationLesson
//
//  Created by sogo on 2020/08/19.
//  Copyright © 2020 Sogo Nishihara. All rights reserved.
//

import UIKit
import SwiftUI
import ARCL
import CoreLocation

class ARViewController: UIViewController, CLLocationManagerDelegate {
    
    var ActivityIndicator: UIActivityIndicatorView!
    var indicatorBackgroundView: UIView!
    var indicator: UIActivityIndicatorView!
    var sceneLocationView = SceneLocationView()
    var locationManager: CLLocationManager!
    var spotsData: [(CLLocation, UIImage)] = []
    var comics: [Comic]?
    var location: CLLocation? = nil
    let blue = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        
        // ARビューの生成
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        
        // ActivityIndicatorを作成＆中央に配置
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        ActivityIndicator.center = self.view.center
        ActivityIndicator.style = .large
        ActivityIndicator.color = blue
        ActivityIndicator.hidesWhenStopped = true       // クルクルをストップした時に非表示する

        view.addSubview(ActivityIndicator)
        ActivityIndicator.startAnimating()          // loading開始
        
        // 投稿ボタンの生成
        let postButton = makePostButton()
        view.addSubview(postButton)
        
        // 更新ボタンの生成
        let reloadButton = makeReloadButton()
        view.addSubview(reloadButton)
    }
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()

      sceneLocationView.frame = view.bounds
    }
    
    // (処理に多少時間がかかるので)viewが表示されてから追加する
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // 現在のタグを全て削除
        Utility().removeLocations(sceneLocationView: sceneLocationView)
        // タグ追加
        loadSpotsData()
        Utility().addLocations(sceneLocationView: sceneLocationView, spotsData: spotsData)
        ActivityIndicator.stopAnimating()           // loading終了
    }
    
    // 位置情報取得
    func setupLocationManager() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()

        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        self.location = location
    }
    
    
    // spotsDataを取得
    private func loadSpotsData() {
        spotsData = []          // 初期化
        
        let coordinate = self.locationManager.location != nil ? self.locationManager.location!.coordinate: CLLocationCoordinate2D()
        print(String(coordinate.latitude))
        print(String(coordinate.longitude))
        
        comics = APIRequest().getNearComics(latitude: String(coordinate.latitude), longitude: String(coordinate.longitude))
        for comic in comics! {
            let coordinate = CLLocationCoordinate2D(latitude: comic.lat, longitude: comic.lng)
            var altitude: Double = 45           // 標高の情報が含まれていればそちらを使う、なければデフォルト値（45）を使う
            if comic.altitude != nil {
                altitude = comic.altitude!
            }
            let location = CLLocation(coordinate: coordinate, altitude: altitude)
            let image = Utility().drawText(text: comic.text, distance: comic.distance)
            spotsData.append((location, image!))
        }
        print(spotsData)
    }
    
    
    // 投稿ボタンの生成
    private func makePostButton() -> UIButton {
        let postButton = UIButton(type: .custom)
        let postButtonWeightConfig = UIImage.SymbolConfiguration(weight: .heavy)
        let postButtonScaleConfig = UIImage.SymbolConfiguration(scale: .large)
        let postButtonImageConfig = postButtonScaleConfig.applying(postButtonWeightConfig)
        let postButtonImage = UIImage(systemName: "plus", withConfiguration: postButtonImageConfig)
        
        postButton.setImage(postButtonImage, for: .normal)
        postButton.tintColor = .white
        postButton.backgroundColor = blue
        postButton.layer.borderWidth = 4
        postButton.layer.borderColor = blue.cgColor
        postButton.layer.cornerRadius = 30
        postButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        postButton.layer.shadowOpacity = 0.5
        postButton.layer.shadowRadius = 10
        
        let x = self.view.frame.maxX - 80
        let y = self.tabBarController!.tabBar.frame.origin.y - 185
        postButton.frame = CGRect(x: x, y: y, width: 60, height: 60)
        postButton.addTarget(self, action: #selector(onTapPostButton), for: .touchUpInside)
        
        return postButton
    }
    
    @objc func onTapPostButton(sender: UIButton) {
        let postView = UIHostingController(rootView: PostView(postCallBack: { (postData) in self.callBack(data: postData) }))
        // postViewにあるプロパティにクロージャを渡す
        // postDataがpostViewから戻る時に渡される引数です
        self.present(postView, animated: true, completion: nil)
    }
    
    // 更新ボタンの生成
    private func makeReloadButton() -> UIButton {
        let reloadButton = UIButton(type: .custom)
        let reloadButtonWeightConfig = UIImage.SymbolConfiguration(weight: .heavy)
        let reloadButtonScaleConfig = UIImage.SymbolConfiguration(scale: .large)
        let reloadButtonImageConfig = reloadButtonScaleConfig.applying(reloadButtonWeightConfig)
        let reloadButtonImage = UIImage(systemName: "arrow.clockwise", withConfiguration: reloadButtonImageConfig)
        
        reloadButton.setImage(reloadButtonImage, for: .normal)
        reloadButton.tintColor = .white
        reloadButton.backgroundColor = blue
        reloadButton.layer.borderWidth = 4
        reloadButton.layer.borderColor = blue.cgColor
        reloadButton.layer.cornerRadius = 30
        reloadButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        reloadButton.layer.shadowOpacity = 0.5
        reloadButton.layer.shadowRadius = 10
        
        let rX = self.view.frame.maxX - 80
        let rY = self.tabBarController!.tabBar.frame.origin.y - 110
        reloadButton.frame = CGRect(x: rX, y: rY, width: 60, height: 60)
        reloadButton.addTarget(self, action: #selector(onTapReloadButton), for: .touchUpInside)
        
        return reloadButton
    }
    
    @objc func onTapReloadButton(sender: UIButton) {
        Utility().removeLocations(sceneLocationView: sceneLocationView)       // 現在のタグを全て削除
        
        ActivityIndicator.startAnimating()          // loading開始
        // タグ追加
        loadSpotsData()
        Utility().addLocations(sceneLocationView: sceneLocationView, spotsData: spotsData)
        ActivityIndicator.stopAnimating()           // loading終了
    }
    
    
    //画面遷移から戻ってきたときに実行する関数(投稿した内容をARViewControllerに反映)
    func callBack(data: PostData) {
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        
        let coordinate = CLLocationCoordinate2D(latitude: Double(data.lat)!, longitude: Double(data.lng)!)
        let altitude: Double = data.altitude ?? 45
        let location = CLLocation(coordinate: coordinate, altitude: altitude)
        let image = Utility().drawText(text: data.text, distance: 0.0)
        let spotData: [(CLLocation, UIImage)] = [(location, image!)]
        spotsData.append(spotData[0])
        
        Utility().addLocations(sceneLocationView: sceneLocationView, spotsData: spotData)

    }

}
