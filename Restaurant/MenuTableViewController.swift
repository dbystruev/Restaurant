//
//  MenuTableTableViewController.swift
//  Restaurant
//
//  Created by Denis Bystruev on 05/06/2018.
//  Copyright © 2018 Denis Bystruev. All rights reserved.
//
//  View controller for the screen after the category was selected

import UIKit

class MenuTableViewController: UITableViewController {
    /// The category name we should receive from CategoryTableViewController
    var category: String!
    
    /// Array of menu items to be displayed in the table
    var menuItems = [MenuItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Table title is capitalized category name
        title = category.capitalized
        
        // Load the menu for a given category
        MenuController.shared.fetchMenuItems(categoryName: category) { (menuItems) in
            // if we indeed got the menu items
            if let menuItems = menuItems {
                // update the interface
                self.updateUI(with: menuItems)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // fit the detail (price) labels
        fitDetailLabels()
    }
    
    override func viewWillLayoutSubviews() {
        // fit the detail (price) labels
        fitDetailLabels()
    }
    
    /// Goes through visible cells and fits the detail (price) labels
    func fitDetailLabels() {
        // go through the list of visible cells
        for cell in tableView.visibleCells {
            // get the main text label
            guard let textLabel = cell.textLabel else { continue }
            
            // get the detail text label
            guard let detailTextLabel = cell.detailTextLabel else { continue }
            
            // remember the original width of main text label
            let textWidth = textLabel.frame.width
            
            // remember the original width of detail text label
            let detailWidth = detailTextLabel.frame.width
            
            // calculate the total width of two labels (could be less than cell width)
            let totalWidth = textWidth + detailWidth
            
            // fit the detail text label
            detailTextLabel.sizeToFit()
            
            // get the new detail text label width
            let newDetailWidth = detailTextLabel.frame.width
            
            // calculate the new main text label width based on detailed text label widht
            let newTextWidth = totalWidth - newDetailWidth
            
            // if there are no changes needed — exit
            guard newTextWidth < textWidth else { continue }
            
            // set the new width of main text label
            textLabel.frame.size.width = newTextWidth
            
            // fit the width with new font
            textLabel.adjustsFontSizeToFitWidth = true
            
            // move the new origin of detail text label
            detailTextLabel.frame.origin.x -= newDetailWidth - detailWidth
        }
    }
    
    /// Set the property and update the interface
    func updateUI(with menuItems: [MenuItem]) {
        // have to go back to main queue from background queue where network requests are exectured
        DispatchQueue.main.async {
            // remember the menu items for diplaying in the table
            self.menuItems = menuItems
            
            // reload the table
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // there is only one section
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // the number of cells is equal to the size of menu items array
        return menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // reuse the menu list prototype cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCellIdentifier", for: indexPath)

        // configure the cell with menu list data
        configure(cell: cell, forItemAt: indexPath)

        return cell
    }
    
    /// Configure the table cell with menu list data
    /// - parameters:
    ///     - cell: The cell to be configured
    ///     - indexPath: An index path locating a row in tableView
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        // get the needed menu item for corresponding table row
        let menuItem = menuItems[indexPath.row]
        
        // the left label of the cell should display the name of the item
        cell.textLabel?.text = menuItem.name
        
        // the right label displays the price along with currency symbol
        cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price)
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

    /// Passes MenuItem to MenuItemDetailViewController before the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // checks this segue is from MenuTableViewController to MenuItemDetailViewController
        if segue.identifier == "MenuDetailSegue" {
            // we can safely downcast to MenuItemDetailViewController
            let menuItemDetailViewController = segue.destination as! MenuItemDetailViewController
            
            // selected cell's row is the index for array of menuItems
            let index = tableView.indexPathForSelectedRow!.row
            
            // pass selected menuItem to destination MenuItemDetailViewController
            menuItemDetailViewController.menuItem = menuItems[index]
        }
    }

}
