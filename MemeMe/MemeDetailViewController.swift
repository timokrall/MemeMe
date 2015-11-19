//
//  ImageViewController.swift
//  MemeMe
//
//  Created by Timo Krall on 11/14/15.
//  Copyright © 2015 Timo Krall. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    // MARK: outlets
    
    // added an outlet for imageView following a hint by OSteven https://discussions.udacity.com/t/nsunknownkeyexception-when-clicking-on-stored-memes/38568/2
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!

    // MARK: variable declarations
    var meme : Meme!
    var memeIndex : Int!

    // MARK: view life cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // display the memed image in the memeImageView
        memeImageView.image = meme.memedImage
        
        // display the navigation bar
        // code found at http://stackoverflow.com/questions/29209453/how-to-hide-a-navigation-bar-from-first-viewcontroller-in-swift
        navigationController?.navigationBarHidden = false
        
        // hide tab bar
        tabBarController?.tabBar.hidden = true
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // generate a new button in the navigation bar and associate the meme delete action with it
        // code found at https://www.hackingwithswift.com/example-code/uikit/how-to-add-a-bar-button-to-a-navigation-bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editMeme:")
    
        // create toolbar with trash icon that executes the deleteMeme function
        // code found at https://www.hackingwithswift.com/example-code/uikit/how-to-show-and-hide-a-toolbar-inside-a-uinavigationcontroller
        
        let trash = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "deleteMeme:")
        let spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        
        toolbarItems = [spacer, trash, spacer]
        navigationController?.setToolbarHidden(false, animated: true)
        
        // shift meme detail controller toolbar down to cover tab bar
        // code suggested by laneseals https://discussions.udacity.com/t/why-is-the-toolbar-automatically-shifted-upwards/38693
        navigationController?.toolbar.layer.position.y = (navigationController?.toolbar.layer.position.y)! + (tabBarController?.tabBar.bounds.height)!

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // show tab bar
        tabBarController?.tabBar.hidden = false
        
        // hide meme detail controller toolbar
        navigationController?.setToolbarHidden(true, animated: false)
        
    }
    
    // MARK: button actions
    
    @IBAction func editMeme(sender: UIBarButtonItem) {
        
        // instantiate EditorViewController
        let memeEditorViewController = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        
        // pass meme and its index to EditorViewContoller
        memeEditorViewController.memeToEdit = meme
        memeEditorViewController.memeToEditIndex = memeIndex
        
        // display EditorViewController
        navigationController?.pushViewController(memeEditorViewController, animated: true)
    }
    
    @IBAction func deleteMeme(sender: UIBarButtonItem) {
    
        // delete currently edited meme
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(memeIndex)
        
        // return to MemeCollectionViewController after meme is deleted
        navigationController?.popToRootViewControllerAnimated(true)
    
    }
    
}