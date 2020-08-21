//
//  struct.swift
//  ARCoreLocationLesson
//
//  Created by sogo on 2020/08/21.
//  Copyright © 2020 Sogo Nishihara. All rights reserved.
//

import Foundation

struct Comic: Codable, Identifiable {
    
    var id: String
    var user_id: String
    var lat: Double
    var lng: Double
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
        case text
        case deleted_at
        case created_at
        case updated_at
        case distance
        
    }
    
}
