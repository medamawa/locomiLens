//
//  struct.swift
//  ARCoreLocationLesson
//
//  Created by sogo on 2020/08/21.
//  Copyright © 2020 Sogo Nishihara. All rights reserved.
//

import Foundation

struct LoginData: Encodable {
    
    var email: String
    var password: String
    
}

struct AuthResponse: Codable {
    
    var status: String
    var messages: ValidateMessages?
    var auth_message: String?
    var data: AuthResponseData?
    
}

struct AuthResponseData: Codable {
    
    var id: String
    var access_token: String
    var refresh_token: String
    
}


// getUsers
struct User: Codable, Identifiable {
    
    var id: String
    var screen_name: String
    var name: String
    var profile_image: String?
    var email: String
    var updated_at: String?
    var created_at: String?
    
}


// post
struct PostData: Codable {
    
    var lat: String
    var lng: String
    var altitude: Double?
    var text: String
    var release: String
    
}

struct PostResponse: Codable {
    
    var status: String
    var messages: ValidateMessages?
    var auth_message: String?
    var data: PostResponseData?
    
}

struct PostResponseData: Codable {
    
    var email: String?
    var password: String?
    var lat: String?
    var lng: String?
    var text: String?
    var release: String?
    var location: locationData?
    
}

struct locationData: Codable {
    
    var latitude: String?
    var longitude: String?
    
}


struct Comic: Codable, Identifiable {
    
    var id: String
    var user_id: String
    var lat: Double
    var lng: Double
    var altitude: Double?
    var text: String
    var deleted_at: String?
    var created_at: String?
    var updated_at: String?
    var distance: Double
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case user_id
        case lat = "X(location)"
        case lng = "Y(location)"
        case altitude
        case text
        case deleted_at
        case created_at
        case updated_at
        case distance
        
    }
    
}


// Versatility messages template
struct ValidateMessages: Codable {
    
    var screen_name: [String]?
    var name: [String]?
    var email: [String]?
    var password: [String]?
    var password_confirmation: [String]?
    var lat: [String]?
    var lng: [String]?
    var text: [String]?
    var release: [String]?
    
}
