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
        
        // display the memed image int he memeImageView
        memeImageView.image = meme.memedImage
        
        // hide tab bar
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // show tab bar
        tabBarController?.tabBar.hidden = false
    }
    
    // MARK: button actions
    
    @IBAction func editMeme(sender: UIBarButtonItem) {
        
        // instantiate EditorViewController
        let memeEditorViewController = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        
        // pass meme and its indext to EditorViewContoller
        memeEditorViewController.memeToEdit = meme
        memeEditorViewController.memeToEditIndex = memeIndex
        
        // display EditorViewController
        navigationController?.pushViewController(memeEditorViewController, animated: true)
    }
    
}