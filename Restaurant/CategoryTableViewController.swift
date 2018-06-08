//
//  CategoryTableViewController.swift
//  Restaurant
//
//  Created by Denis Bystruev on 05/06/2018.
//  Copyright © 2018 Denis Bystruev. All rights reserved.
//
//  View controller for the first screen of the app — menu categories

import UIKit

class CategoryTableViewController: UITableViewController {
    /// Names of the menu categories
    var categories = [String]()
    
    /// Array of menu items to be fetched from the server
    var menuItems = [MenuItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the menu for all categories
        MenuController.shared.fetchMenuItems() { (menuItems) in
            // if we indeed got the menu items
            if let menuItems = menuItems {
                // compose the list of categories
                for item in menuItems {
                    // get the item's category
                    let category = item.category
                    
                    // add category only if it was not added before
                    if !self.categories.contains(category) {
                        self.categories.append(category)
                    }
                }
                
                // remember the list of items
                self.menuItems = menuItems
                
                // update the table with categories
                self.updateUI(with: self.categories)
            }
        }
    }
    
    /// Update the categories table
    /// - parameters:
    ///     - categories: Array of categories to display
    func updateUI(with categories: [String]) {
        // since network requests are called on a background thread we need to return to the main thread to update UI immediately
        DispatchQueue.main.async {
            // remember the list of categories to display in the table
            self.categories = categories
            
            // reload the categories table
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // There is only one section — the list of categories
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // number of sections is equal to number of categories we have
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // reuse a category prototype cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellIdentifier", for: indexPath)

        // Configure the cell...
        configure(cell: cell, forItemAt: indexPath)

        return cell
    }
    
    /// Configure the table cell with category data
    /// - parameters:
    ///     - cell: The cell to be configured
    ///     - indexPath: An index path locating a row in tableView
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        // get the name of the category
        let categoryString = categories[indexPath.row]
        
        // make sure it is capitalized to clean up the appearance of categories
        cell.textLabel?.text = categoryString.capitalized
        
        // find the first item in the category for image fetching
        guard let menuItem = menuItems.first(where: { item in
            return item.category == categoryString
        }) else { return }
        
        // fetch the image from the server
        MenuController.shared.fetchImage(url: menuItem.imageURL) { image in
            // check that the image was fetched successfully
            guard let image = image else { return }
            
            // return to main thread after the network request in background
            DispatchQueue.main.async {
                // get the current index path
                guard let currentIndexPath = self.tableView.indexPath(for: cell) else { return }
                
                // check if the cell was not yet recycled
                guard currentIndexPath == indexPath else { return }
                
                // set the thumbnail image
                cell.imageView?.image = image
                
                // fit the image to the cell
                self.fitImage(in: cell)
            }
        }
    }
    
    // adjust the cell height to make images look better
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // Need to pass the name of the chosen category before showing the category menu
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // make sure the segue is from category to menu table view controllers
        if segue.identifier == "MenuSegue" {
            // we can safely downcast to MenuTableViewController
            let menuTableViewController = segue.destination as! MenuTableViewController
            
            // index in the category array is equal to the selected table row number
            let index = tableView.indexPathForSelectedRow!.row
            
            // store the name of the category in the destination menu table view controller
            menuTableViewController.category = categories[index]
        }
    }

}
