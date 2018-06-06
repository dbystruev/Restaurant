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
    /// Instance of MenuController to make network requests
    let menuController = MenuController()
    
    /// Names of the menu categories
    var categories = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the list of categories
        menuController.fetchCategories{ (categories) in
            // if we indeed got the list of categories
            if let categories = categories {
                // update the table with categories
                self.updateUI(with: categories)
            }
        }
    }
    
    /// Update the categories table
    /// - parameters:
    ///     - categories: Array of categories to display
    func updateUI(with categories: [String]) {
        // Since network requests are called on a background thread we need to return to the main thread to update UI immediately
        DispatchQueue.main.async {
            self.categories = categories
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
