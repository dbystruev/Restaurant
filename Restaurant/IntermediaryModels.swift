//
//  IntermediaryModels.swift
//  Restaurant
//
//  Created by AnaSophia Rua on 05/02/2022.
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
