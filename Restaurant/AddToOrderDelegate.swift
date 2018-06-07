//
//  AddToOrderDelegate.swift
//  Restaurant
//
//  Created by Denis Bystruev on 07/06/2018.
//  Copyright © 2018 Denis Bystruev. All rights reserved.
//
//  Protocol for adding items to the order

protocol AddToOrderDelegate {
    /// Called when menu item is added
    func added(menuItem: MenuItem)
}
