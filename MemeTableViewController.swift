//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Timo Krall on 11/14/15.
//  Copyright © 2015 Timo Krall. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    
    // obtain memes array from app delegate
    
    var memes: [Meme]{
        
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        
    }

    // MARK: view life cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // refresh table
        tableView!.reloadData()
        
        // make tab bar visible
        tabBarController?.tabBar.hidden = false
        
        // display the navigation bar
        // code found at http://stackoverflow.com/questions/29209453/how-to-hide-a-navigation-bar-from-first-viewcontroller-in-swift
        navigationController?.navigationBarHidden = false
        
    }
    
    
    // MARK: table view setup
    // table view corrected after comparing with https://github.com/FrazJ/MemeMe-v2.0.git
    
    
    // essential table function: how many cells
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    // essential table function: how the cells look like
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
            
            // different meme is displayed depending on the cell
            let meme = memes[indexPath.row]
            
            // display meme text in cell
            let topMemeText = meme.textOne
            let bottomMemeText = meme.textTwo
            let cellText = topMemeText + " " + bottomMemeText
            cell.textLabel?.text = cellText
            
            // display memed image in cell
            cell.imageView?.image = meme.memedImage
            
            // create the cell with the parameters set above
            return cell
            
    }
    
    // essential table function: what happens if cell is selected by the user
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // launch MemeDetailViewController
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        // each cell in the table is associated with a different meme
        let meme = memes[indexPath.row]
        
        // pass the information about the meme and its index to the MemeDetailViewController
        detailController.meme = meme
        detailController.memeIndex = indexPath.row
        
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    // table function that allows to define what happens if user swipes a row
    // code found at http://stackoverflow.com/questions/29294099/delete-a-row-in-table-view-in-swift
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // describe what happens when user swipes the row and then clicks on delete
        if editingStyle == .Delete {
            
                // delete the meme associated with the row that was swiped
                (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
                tableView.reloadData()
        
        }
    }

}