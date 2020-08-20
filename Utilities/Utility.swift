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
    
    /// 画像に文字を追加する
    ///
    /// - Parameters:
    ///   - image: 追加先の元画像
    ///   - text: 追加するテキスト   
    func drawText(image: UIImage, text: String) -> UIImage?
    {
        let font = UIFont.boldSystemFont(ofSize: 32)
        let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)

        UIGraphicsBeginImageContext(image.size);

        image.draw(in: imageRect)

        let textRect  = CGRect(x: 5, y: 5, width: image.size.width - 5, height: image.size.height - 5)
        let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        let textFontAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.paragraphStyle: textStyle
        ]
        text.draw(in: textRect, withAttributes: textFontAttributes)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return newImage
    }
    
}
