//
//  Utility.swift
//  ARCoreLocationLesson
//
//  Created by sogo on 2020/08/20.
//  Copyright © 2020 Sogo Nishihara. All rights reserved.
//

import ARCL
import ARKit
import CoreLocation

class Utility {

    /// 条件をクリアするまで待つ
    ///
    /// - Parameters:
    ///   - waitContinuation: 待機条件
    ///   - compleation: 通過後の処理
    func wait(_ waitContinuation: @escaping (()->Bool), compleation: @escaping (()->Void)) {
        var wait = waitContinuation()
        // 0.01秒周期で待機条件をクリアするまで待つ
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            while wait {
                DispatchQueue.main.async {
                    wait = waitContinuation()
                    semaphore.signal()
                }
                semaphore.wait()
                Thread.sleep(forTimeInterval: 0.01)
            }
            // 待機条件をクリアしたので通過後の処理を行う
            DispatchQueue.main.async {
                compleation()
            }
        }
    }
    
    /// 複数のスポットを追加する
    ///
    /// - Parameters:
    ///   - sceneLocationView: 追加先のView
    ///   - spotsData: 追加するスポットのデータリスト
    func addLocations(sceneLocationView: SceneLocationView, spotsData: [(CLLocation, UIImage)])
    {
        for spotData in spotsData {
            let (location, image) = spotData
            let annotationNode = LocationAnnotationNode(location: location, image: image)
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        }
    }
    
    /// 全てのスポットを削除する
    ///
    /// - Parameters:
    ///   - sceneLocationView: 削除先のView
    func removeLocations(sceneLocationView: SceneLocationView)
    {
        sceneLocationView.removeAllNodes()
    }
    
    /// 画像に文字を追加する
    ///
    /// - Parameters:
    ///   - image: 追加先の元画像
    ///   - text: 追加するテキスト
    ///   - distance: キョリ
    func drawText(text: String, distance: Double) -> UIImage?
    {
        var newImage: UIImage?
        
        if text.count <= 9 {
            newImage = smallImage(text: text, distance: distance)
        } else if text.count <= 17 {
            newImage = bigImage(text: text, distance: distance)
        } else {
            let t = String(text.prefix(17)) + "..."
            newImage = bigImage(text: t, distance: distance)
        }

        return newImage
    }
    
    private func smallImage(text: String, distance: Double) -> UIImage?
    {
        let image = randomImage()
        let distanceValue = "キョリ：" + String(round(distance*100000)/100) + "m"
        
        let font = UIFont.boldSystemFont(ofSize: 32)
        let subheadline = UIFont.systemFont(ofSize: 12)
        let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)

        UIGraphicsBeginImageContext(image.size);

        image.draw(in: imageRect)

        let textRect = CGRect(x: 10, y: 8, width: image.size.width - 5, height: image.size.height - 5)
        let subheadlineRect = CGRect(x: 15, y: 46, width: image.size.width - 5, height: image.size.height - 5)
        let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        let textFontAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.paragraphStyle: textStyle
        ]
        let subheadlineAttributes = [
            NSAttributedString.Key.font: subheadline,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.paragraphStyle: textStyle
        ]
        text.draw(in: textRect, withAttributes: textFontAttributes)
        distanceValue.draw(in: subheadlineRect, withAttributes: subheadlineAttributes)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        
        let resizedImage: UIImage = resizeImage(image: newImage!, distance: distance)
        
        return resizedImage
    }
    
    private func bigImage(text: String, distance: Double) -> UIImage?
    {
        let image = randomBigImage()
        let t1 = String(text.prefix(9))
        let t2 = String(text.suffix(text.count - 9))
        let distanceValue = "キョリ：" + String(round(distance*100000)/100) + "m"
        
        let font = UIFont.boldSystemFont(ofSize: 32)
        let subheadline = UIFont.systemFont(ofSize: 12)
        let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)

        UIGraphicsBeginImageContext(image.size);

        image.draw(in: imageRect)

        let textRect1 = CGRect(x: 10, y: 8, width: image.size.width - 5, height: image.size.height - 5)
        let textRect2 = CGRect(x: 10, y: 46, width: image.size.width - 5, height: image.size.height - 5)
        let subheadlineRect = CGRect(x: 15, y: 84, width: image.size.width - 5, height: image.size.height - 5)
        let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        let textFontAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.paragraphStyle: textStyle
        ]
        let subheadlineAttributes = [
            NSAttributedString.Key.font: subheadline,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.paragraphStyle: textStyle
        ]
        t1.draw(in: textRect1, withAttributes: textFontAttributes)
        t2.draw(in: textRect2, withAttributes: textFontAttributes)
        distanceValue.draw(in: subheadlineRect, withAttributes: subheadlineAttributes)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        
        let resizedImage: UIImage = resizeImage(image: newImage!, distance: distance)
        
        return resizedImage
    }
    
    private func randomImage() -> UIImage
    {
        let iValue = Int.random(in: 0 ... 3)
        let image: UIImage
        
        switch iValue {
        case 0:
            image = UIImage(named: "hukidashi-blue")!
        case 1:
            image = UIImage(named: "hukidashi-green")!
        case 2:
            image = UIImage(named: "hukidashi-orange")!
        case 3:
            image = UIImage(named: "hukidashi-purple")!
        default:
            image = UIImage(named: "hukidashi-gray")!
        }
        
        return image
    }
    
    private func randomBigImage() -> UIImage
    {
        let iValue = Int.random(in: 0 ... 3)
        let image: UIImage
        
        switch iValue {
        case 0:
            image = UIImage(named: "hukidashi-blue-big")!
        case 1:
            image = UIImage(named: "hukidashi-green-big")!
        case 2:
            image = UIImage(named: "hukidashi-orange-big")!
        case 3:
            image = UIImage(named: "hukidashi-purple-big")!
        default:
            image = UIImage(named: "hukidashi-gray-big")!
        }
        
        return image
    }
    
    private func resizeImage(image: UIImage, distance: Double) -> UIImage
    {
        let magnification = (100 - distance * 0.7) / 100    // 1mで0.7%小さくなる
        let width = Double(image.size.width) * magnification
        let height = Double(image.size.height) * magnification
        
        let resizedSize = CGSize(width: width, height: height)
        
        // リサイズ後のUIImageを生成して返却
        UIGraphicsBeginImageContext(resizedSize)
        image.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
    }
    
}
