//
//  MenuController.swift
//  Restaurant
//
//  Created by Denis Bystruev on 06/06/2018.
//  Copyright © 2018 Denis Bystruev. All rights reserved.
//

import UIKit

// Controller with all the networking code
class MenuController {
    /// Used to share MenuController across all view controllers in the app
    static let shared = MenuController()
    
    /// Base URL where all requests should go.  Change this to your own server.
    /// The server app for macOS can be downloaded [here](https://www.dropbox.com/sh/bmbhzxqi1886kix/AABFwZJiMj_wxqaUphHFJh5ba?dl=1)
    let baseURL = URL(string: "http://api.armenu.net:8090/")!
    
    /// Execute GET request for the categories with /categories
    /// - parameters:
    ///     - completion: The closure which accepts the array of strings returned by JSON
    func fetchCategories(completion: @escaping ([String]?) -> Void) {
        
        // if data is local use it
        if LocalData.isLocal {
            completion(LocalData.categories)
            return
        }
        
        // full URL for category request is.../categories
        let categoryURL = baseURL.appendingPathComponent("categories")
        
        // create a task for network call to get the list of categories
        let task = URLSession.shared.dataTask(with: categoryURL) { data, response, error in
            // /categories endpoint decoded into a Categories object
            if let data = data,
                let jsonDictionary = try? JSONSerialization.jsonObject(with: data) as? [String:Any],
                let categories = jsonDictionary?["categories"] as? [String] {
                completion(categories)
            } else {
                completion(nil)
            }
        }
        
        // begin the network call to get the list of categories
        task.resume()
    }
    
    /// Execute GET request from /menu with query parameter — category name
    /// - parameters:
    ///     - categoryName: The name of the category
    ///     - completion: The closure which accepts the MenuItem array returned by JSON
    func fetchMenuItems(categoryName: String = "", completion: @escaping([MenuItem]?) -> Void) {
        
        // if data is local use it
        if LocalData.isLocal {
            completion(LocalData.menuItems.filter { $0.category == categoryName || categoryName.isEmpty })
            return
        }
        
        // add /menu to the request URL
        let initialMenuURL = baseURL.appendingPathComponent("menu")
        
        // create category=<category name> component
        var components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!
        
        // add ?category=<category name> only if categoryName is not empty
        if categoryName != "" {
            components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        }
        
        // compose the full url .../menu?category=<category name>
        let menuURL = components.url!
        
        // create a task for category menu network call
        let task = URLSession.shared.dataTask(with: menuURL) { data, response, error in
            // data from /menu converted into an array of MenuItem objects
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let menuItems = try? jsonDecoder.decode(MenuItems.self, from: data) {
                completion(menuItems.items)
            } else {
                completion(nil)
            }
        }
        
        // begin the category menu network call
        task.resume()
    }
    
    /// Execute POST request to /order with the user's order
    /// - parameters:
    ///     - menuIds: Array of the dishes' IDs in the order
    ///     - completion: A closure that takes the order preparation time
    func submitOrder(menuIds: [Int], completion: @escaping (Int?) -> Void) {
        
        // if data is local fake the preparation time
        if LocalData.isLocal {
            completion(5 * menuIds.count)
            return
        }
        
        // full URL for order posting is .../order
        let orderURL = baseURL.appendingPathComponent("order")
        
        // create a request for order posting
        var request = URLRequest(url: orderURL)
        
        // modify request's method to POST
        request.httpMethod = "POST"
        
        // tell the server what kind of data we are sending — JSON
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // encode the array of menu IDs into JSON
        let data: [String: [Int]] = ["menuIds": menuIds]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        
        // data for a POST must be stored within the body of the request
        request.httpBody = jsonData
        
        // create a task for order network call
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // POST to /order returns JSON data which has to be decoded into PreparationTime
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let preparationTime = try? jsonDecoder.decode(PreparationTime.self, from: data) {
                completion(preparationTime.prepTime)
            } else {
                completion(nil)
            }
        }
        
        // begin the order network call
        task.resume()
    }
    
    /// Fetch an image from the server
    /// - parameters:
    ///     - url: An image URL
    ///     - completion: A handler that receives UIImage data
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        
        // if data is local use it
        if LocalData.isLocal {
            completion(UIImage(named: url.relativeString))
            return
        }
        
        // construct URL components from URL
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
        
        // replace the host for the base URL's host
        components.host = baseURL.host
        
        // construct the new url with the replaced host
        guard let url = components.url else { return }
        
        // create a task for image fetch URL call
        let task = URLSession.shared.dataTask(with: url) { data, responce, error in
            // check the data is returned and image is valid
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        
        // begin the image fetch network call
        task.resume()
    }
}
