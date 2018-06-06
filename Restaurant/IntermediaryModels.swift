//
//  IntermediaryModels.swift
//  Restaurant
//
//  Created by Denis Bystruev on 06/06/2018.
//  Copyright © 2018 Denis Bystruev. All rights reserved.
//

// Correspond to keys returned by the API under categories
struct Categories: Codable {
    let categories: [String]
}

struct PreparationTime: Codable {
    let prepTime: Int
    
    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}
