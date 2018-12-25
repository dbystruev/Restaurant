//
//  LocalData.swift
//  Restaurant
//
//  Created by Denis Bystruev on 25/12/2018.
//  Copyright © 2018 Denis Bystruev. All rights reserved.
//

import Foundation

/// Used to provide local data for debug purposes
struct LocalData {
    /// Use local data instead of remote server
    static let isLocal = true
    
    /// List of categories the app should return
    static let categories = [
        "appetizers",
        "entrees",
    ]
    
    static let menuItems = [
        MenuItem(
            id: 1,
            name: "Spaghetti and Meatballs",
            description: "Seasoned meatballs on top of freshly-made spaghetti. Served with a robust tomato sauce.",
            price: 9,
            category: "entrees",
            imageURL: URL(fileURLWithPath: "SpaghettiAndMeatballs")
        ),
        MenuItem(
            id: 2,
            name: "Margherita Pizza",
            description: "Tomato sauce, fresh mozzarella, basil, and extra-virgin olive oil.",
            price: 10,
            category: "entrees",
            imageURL: URL(fileURLWithPath: "MargheritaPizza")
        ),
        MenuItem(
            id: 3,
            name: "Grilled Steelhead Trout Sandwich",
            description: "Pacific steelhead trout with lettuce, tomato, and red onion.",
            price: 9,
            category: "entrees",
            imageURL: URL(fileURLWithPath: "GrilledSteelheadTroutSandwich")
        ),
        MenuItem(
            id: 4,
            name: "Pesto Linguini",
            description: "Stewed sliced beef with yellow onions and garlic in a vinegar-soy sauce. Served with steamed jasmine rice and sautÃ©ed vegetables.",
            price: 9,
            category: "entrees",
            imageURL: URL(fileURLWithPath: "PestoLinguini")
        ),
        MenuItem(
            id: 5,
            name: "Chicken Noodle Soup",
            description: "Delicious chicken simmered alongside yellow onions, carrots, celery, and bay leaves, chicken stock.",
            price: 3,
            category: "appetizers",
            imageURL: URL(fileURLWithPath: "ChickenNoodleSoup")
        ),
        MenuItem(
            id: 6,
            name: "Italian Salad",
            description: "Garlic, red onions, tomatoes, mushrooms, and olives on top of romaine lettuce.",
            price: 5,
            category: "appetizers",
            imageURL: URL(fileURLWithPath: "ItalianSalad")
        ),
    ]
}
