//
//  UITableViewControllerExtension.swift
//  Restaurant
//
//  Created by Denis Bystruev on 07/06/2018.
//  Copyright © 2018 Denis Bystruev. All rights reserved.
//

import UIKit

extension UITableViewController {
    /// Goes through visible cells and fits the detail (price) labels
    func fitDetailLabels() {
        // go through the list of visible cells
        for cell in tableView.visibleCells {
            fitDetailLabel(in: cell)
        }
    }
    
    /// Fit the detail (price) label in particular cell
    func fitDetailLabel(in cell: UITableViewCell) {        
        // get the image view
        guard let imageView = cell.imageView else { return }
        
        // get the main text label
        guard let textLabel = cell.textLabel else { return }
        
        // get the detail text label
        guard let detailTextLabel = cell.detailTextLabel else { return }
        
        // get the widht of image view
        let imageWidth = imageView.frame.width
        
        // remember the original width of main text label
        let textWidth = textLabel.frame.width
        
        // remember the original width of detail text label
        let detailWidth = detailTextLabel.frame.width
        
        // calculate the total width of image and two labels (could be less than cell width)
        let totalWidth = imageWidth + textWidth + detailWidth
        
        // fit the detail text label
        detailTextLabel.sizeToFit()
        
        // make sure the image width does not change
        imageView.frame.size.width = imageWidth
        
        // get the new detail text label width
        let newDetailWidth = detailTextLabel.frame.width
        
        // calculate the new main text label width based on detailed text label widht
        let newTextWidth = totalWidth - imageWidth - newDetailWidth
        
        // if there are no changes needed — exit
        guard newTextWidth < textWidth else { return }
        
        // set the new width of main text label
        textLabel.frame.size.width = newTextWidth
        
        // fit the width with new font
        textLabel.adjustsFontSizeToFitWidth = true
        
        // move the new origin of detail text label
        detailTextLabel.frame.origin.x -= newDetailWidth - detailWidth
    }
    
    /// Fit image in particular cell
    func fitImage(in cell: UITableViewCell) {
        // check if we can get the image view
        guard let imageView = cell.imageView else { return }
        
        // remember the old image view width
        let oldWidth = imageView.frame.width
        
        // set the image view size
        imageView.frame.size = CGSize(width: 100, height: 100)
        
        // calculate the shift to the left
        let leftShift = oldWidth - imageView.frame.width
        
        // get the main text label
        guard let textLabel = cell.textLabel else { return }

        // move the label left
        textLabel.frame.origin.x -= leftShift        
    }
}
