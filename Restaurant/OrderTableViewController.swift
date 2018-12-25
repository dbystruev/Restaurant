//
//  OrderTableViewController.swift
//  Restaurant
//
//  Created by Denis Bystruev on 05/06/2018.
//  Copyright © 2018 Denis Bystruev. All rights reserved.
//
//  View controller for the order list

import UIKit

class OrderTableViewController: UITableViewController, AddToOrderDelegate {
    
    /// The list of ordered items
    var menuItems = [MenuItem]()
    
    /// Minutes remaining for the order
    var orderMinutes = 0

    /// Alert the user that their order will be submitted if they continue
    @IBAction func submitTapped(_ sender: UIBarButtonItem) {
        // calculate the total order cost
        let orderTotal = menuItems.reduce(0.0) { (result, menuItem) -> Double in
            return result + menuItem.price
        }
        
        // format the order total price
        let formattedOrder = String(format: "$%2.f", orderTotal)
        
        // prepare an alert for the user
        let alert = UIAlertController(
            title: "Confirm Order",
            message: "You are about to submit your order with a total of \(formattedOrder)",
            preferredStyle: .alert
        )
        
        // add upload order action on submit
        alert.addAction(UIAlertAction(title: "Submit", style: .default) { action in
            self.uploadOrder()
        })
        
        // add cancel on dismiss
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // present the alert for the user about order submission
        present(alert, animated: true, completion: nil)
    }
    
    /// Go back to order list when the dismiss button is pressed
    @IBAction func unwindToOrderList(segue: UIStoryboardSegue) {
        // check that we indeed dismissing the confirmation screen
        if segue.identifier == "DismissConfirmation" {
            // clear order menu items
            menuItems.removeAll()
            
            // reload the table to show empty list
            tableView.reloadData()
            
            // update the number of items in the order list
            updateBadgeNumber()
        }
    }
    
    /// Make the request using the submitOrder() method defined in MenuController
    func uploadOrder() {
        // create an array menu IDs selected for the order
        let menuIds = menuItems.map { $0.id }
        
        // call submitOrder() from MenuController
        MenuController.shared.submitOrder(menuIds: menuIds) { minutes in
            // return to the main queue as network requests are executed in background
            DispatchQueue.main.async {
                // check if minutes were returned successfully
                if let minutes = minutes {
                    // remember the minutes remaining
                    self.orderMinutes = minutes
                    
                    // perform the segue to confirmation screen
                    self.performSegue(withIdentifier: "ConfirmationSegue", sender: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // display an Edit button in the navigation bar for this view controller.
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // fit the detail (price) labels
        fitDetailLabels()
    }
    
    override func viewWillLayoutSubviews() {
        // fit the detail (price) labels
        fitDetailLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // the number of rows is equal to the number of items in menuItems array
        return menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // reuse the order list prototype cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCellIdentifier", for: indexPath)
        
        // configure the cell with menu list data
        configure(cell: cell, forItemAt: indexPath)

        return cell
    }
    
    /// Configure the cell with order list data
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

    // Confirm which items (all) support editing (deleting menu items) of the order table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // All items are editable (deletable)
        return true
    }

    // Support editing the order table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the item from the order list
            menuItems.remove(at: indexPath.row)
            
            // Remove the row from the table
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Update the number of items on the badge
            updateBadgeNumber()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // fit the detail (price) label in cell
        fitDetailLabel(in: cell)
    }

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

    /// Pass order minutes before the segue to order confirmation page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // check that we indeed performing the order confirmation seque
        if segue.identifier == "ConfirmationSegue" {
            // get the new view controller using segue.destinationViewController.
            let orderConfirmationViewController = segue.destination as! OrderConfirmationViewController
            
            // pass the minutes remaining to the destination view controller
            orderConfirmationViewController.minutes = orderMinutes
        }
        // Pass the selected object to the new view controller.
    }
    
    /// Called when menu item is added
    func added(menuItem: MenuItem) {
        // append the menu item to the menuItems array
        menuItems.append(menuItem)
        
        // get the total number of menu items
        let count = menuItems.count
        
        // calculate index path for the last row
        let indexPath = IndexPath(row: count - 1, section: 0)
        
        // insert the menu item row to the end of the order table
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        // update the badge with the number of items in the order
        updateBadgeNumber()
    }
    
    /// Update the badge value of the order tab to match the number of items in the order
    func updateBadgeNumber() {
        // get the number of items in the order
        let badgeValue = 0 < menuItems.count ? "\(menuItems.count)" : nil
        
        // assign the badge value to the order tab
        navigationController?.tabBarItem.badgeValue = badgeValue
    }
}
