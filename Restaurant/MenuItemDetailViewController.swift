//
//  MenuItemDetailViewController.swift
//  Restaurant
//
//  Created by Denis Bystruev on 05/06/2018.
//  Copyright © 2018 Denis Bystruev. All rights reserved.
//
//  View controller for the details of a particular food

import UIKit

class MenuItemDetailViewController: UIViewController {
    
    /// Food name
    @IBOutlet weak var titleLabel: UILabel!
    
    /// Food image
    @IBOutlet weak var imageView: UIImageView!
    
    /// Food price
    @IBOutlet weak var priceLabel: UILabel!
    
    //// Food description
    @IBOutlet weak var descriptionLabel: UILabel!
    
    /// Food ordering button
    @IBOutlet weak var addToOrderButton: UIButton!
    
    /// Action called when user taps Add To Order button
    @IBAction func addToOrderButtonTapped(_ sender: UIButton) {
        // quick bounce animation after the button is pressed
        UIView.animate(withDuration: 0.3) {
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 3, y: 3)
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    /// Holds MenuItem received from MenuTableViewController
    var menuItem: MenuItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // update the screen with menuItem values
        updateUI()
    }
    
    /// Update outlets' properties to match menuItem values
    func updateUI() {
        // the name of the food
        titleLabel.text = menuItem.name
        
        // food price
        priceLabel.text = String(format: "$%.2f", menuItem.price)
        
        // detailed food description
        descriptionLabel.text = menuItem.description
        
        // make button's corners round
        addToOrderButton.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
