//
//  APIRequest.swift
//  ARCoreLocationLesson
//
//  Created by sogo on 2020/08/21.
//  Copyright © 2020 Sogo Nishihara. All rights reserved.
//

import Foundation

struct APIRequest {
    
    // 同期通信で取得
    func getNearComics(latitude lat: String, longitude lng: String) -> [Comic]? {
        let semaphore = DispatchSemaphore(value: 0)
        let url = URL(string: "https://locomi.herokuapp.com/api/comics/near?lat=\(lat)&lng=\(lng)")!
        let urlRequest = NSMutableURLRequest(url: url)
        var data: [Comic]?
        
        URLSession.shared.dataTask(with: urlRequest as URLRequest) { (jsonData, _, _) in
            data = try! JSONDecoder().decode([Comic].self, from: (jsonData)!)
            
            semaphore.signal()
        }.resume()
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        print(data)
        
        return data
    }
    
}
