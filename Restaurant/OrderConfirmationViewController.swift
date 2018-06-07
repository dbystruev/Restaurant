//
//  OrderConfirmationViewController.swift
//  Restaurant
//
//  Created by Denis Bystruev on 07/06/2018.
//  Copyright © 2018 Denis Bystruev. All rights reserved.
//

import UIKit

class OrderConfirmationViewController: UIViewController {

    // Label with time remaining information
    @IBOutlet weak var timeRemainingLabel: UILabel!
    
    // Go back to order list when the dismiss button is pressed
    @IBAction func unwindToOrderList(segue: UIStoryboardSegue) {
    }
    
    // Time remaining in minutes
    var minutes: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
