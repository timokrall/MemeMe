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
        
    }
    
    
    // MARK: table view setup
    
    
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

}