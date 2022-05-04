//
//  AddToOrderDelegate.swift
//  Restaurant
//
//  Created by AnaSophia Rua on 05/02/2022.
//
//
//  Protocol for adding items to the order

protocol AddToOrderDelegate {
    /// Called when menu item is added
    func added(menuItem: MenuItem)
}
