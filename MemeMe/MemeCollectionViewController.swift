//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Timo Krall on 11/14/15.
//  Copyright © 2015 Timo Krall. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {

    // MARK: outlets
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    // MARK: variable declarations
    
    // access meme array stored in AppDelegate
    var memes: [Meme] {
        
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        
    }
    
    // MARK: view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        // set spacing between cells
        flowLayout.minimumInteritemSpacing = space
        
        // set spacing between rows
        flowLayout.minimumLineSpacing = space
        
        // set size of cells
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }

    // ensure displayed memes are up-to-date
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // update data
        self.collectionView!.reloadData()
        
        // set tab bar visible
        tabBarController?.tabBar.hidden = false
        
    }

    
    // MARK: collection view setup
    
    
    // essential collection view function: how many items
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return memes.count
    }


    // essential collection view function: how each item will look like
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        
        // retrieve different meme for different items
        let meme = memes[indexPath.row]
        
        // set image for item
        cell.setCellImage(meme.memedImage)
        
        return cell
    }

    
    // essential collection view function: what happens when user selects one item
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // instantiate view MemeDetailViewController
        let detailController = storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        // retrieve different meme for different items
        let meme = memes[indexPath.row]
        
        // pass meme and its index to view controller
        detailController.meme = meme
        detailController.memeIndex = indexPath.row
        
        // display view controller
        self.navigationController?.pushViewController(detailController, animated: true)
    }

    
}