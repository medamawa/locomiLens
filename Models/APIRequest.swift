//
//  APIRequest.swift
//  ARCoreLocationLesson
//
//  Created by sogo on 2020/08/21.
//  Copyright © 2020 Sogo Nishihara. All rights reserved.
//

import Foundation

struct APIRequest {
    
    func postLogin (_ dataToRegist: LoginData) {
        
        do {
            
            guard let url = URL(string: "https://locomi.herokuapp.com/api/login") else { return }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(dataToRegist)
            
            URLSession.shared.dataTask(with: urlRequest) { (jsonData, _, _) in
                
                let data = try! JSONDecoder().decode(AuthResponse.self, from: (jsonData)!)
                
                AccessToken().saveToken(token: data.data?.access_token ?? "")
                RefreshToken().saveToken(token: data.data?.refresh_token ?? "")
                UserID().saveID(id: data.data?.id ?? "")
                
                print(data)
                
            }.resume()
            
        } catch {
            
            return
            
        }
        
    }
    
    // 同期通信で取得
    func getAuth () -> Bool {
        
        let semaphore = DispatchSemaphore(value: 0)
        var isOK: Bool = false
        
        guard let url = URL(string: "https://locomi.herokuapp.com/api/refresh-token") else { return false }
        
        let token = RefreshToken().getToken()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { (jsonData, _, _) in
            
            let data = try! JSONDecoder().decode(AuthResponse.self, from: (jsonData)!)

            if data.status == "success" {
                AccessToken().saveToken(token: data.data?.access_token ?? "")
                RefreshToken().saveToken(token: data.data?.refresh_token ?? "")
                UserID().saveID(id: data.data?.id ?? "")
                isOK = true
            }
            
            semaphore.signal()
        }.resume()
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        print(isOK)
        
        return isOK
        
    }
    
    func getSpecifiedUser (_ id: String, completion: @escaping ([User]) -> ()) {
        
        guard let url = URL(string: "https://locomi.herokuapp.com/api/users/\(id)") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            let user = try! JSONDecoder().decode([User].self, from: data!)
            
            DispatchQueue.main.async {
                completion(user)
            }
            
        }.resume()
        
    }
    
    func post (_ dataToPost: PostData) {
        
        do {
            
            guard let url = URL(string: "https://locomi.herokuapp.com/api/post") else { return }
            
            let token = AccessToken().getToken()
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("bearer \(token)", forHTTPHeaderField: "Authorization")
            urlRequest.httpBody = try JSONEncoder().encode(dataToPost)
            
            URLSession.shared.dataTask(with: urlRequest) { (jsonData, _, error) in
                let data = try! JSONDecoder().decode(PostResponse.self, from: jsonData!)

                print(data)
                print(type(of: data))
                
            }.resume()
            
        } catch {
            return
        }
        
    }
    
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
