//
//  ViewController.swift
//  MemeMe
//
//  Created by Timo Krall on 11/3/15.
//  Copyright © 2015 Timo Krall. All rights reserved.
//

import UIKit
import AVFoundation

// set tab bar controller as initial view controller after reading hint by OSteven at https://discussions.udacity.com/t/nsunknownkeyexception-when-clicking-on-stored-memes/38568/2
// do not set the MemeEditorViewController as the initial view controller or otherwise the view controller could not be dismissed properly after a meme is saved

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {


    // MARK: outlets
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var textFieldBottom: UITextField!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UIToolbar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    // MARK: variable declarations
    var memeToEdit : Meme!
    var memeToEditIndex : Int!
    
    
    // MARK: text setup
    
    // define text attributes for the two meme labels
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -4
    ]
    
    // function for configuring text fields
    func configureTextField(textField: UITextField, text: String, delegate: UITextFieldDelegate,
        attributes: [String : NSObject], alignment: NSTextAlignment) {
            
            textField.text = text
            textField.delegate = delegate
            textField.defaultTextAttributes = attributes
            textField.textAlignment = alignment
    }
    
    
    // MARK: keyboard setup
    // shift screen to keep edited content visible
    
    // functions for moving the screen
    // fixed after reading https://discussions.udacity.com/t/need-help-for-hiding-keyboard-and-meme-struct/15614/4
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    // find keyboard height
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    // move screen up if the lower text field is used
    // this function requires the keyboard height function
    // without an if statement, the screen would move weirdly when the upper text field is used
    func keyboardWillShow(notification: NSNotification) {
        
        if textFieldBottom.editing {
            
            view.frame.origin.y -= getKeyboardHeight(notification)
            
        }
        
    }
    
    // move screen back down
    func keyboardWillHide(notification: NSNotification) {
        
        view.frame.origin.y = 0
        
    }
    
    // use a delegate method to dismiss keyboard when enter is pressed
    // fixed after reading http://sourcefreeze.com/uitextfield-and-uitextfield-delegate-in-swift/
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: view lifecycle
    
    override func viewWillAppear(animated: Bool) {
    
        // subscribe to keyboard notifications to allow the screen to shift when necessary
        subscribeToKeyboardNotifications()
        
        // deactivate camera if no camera in device
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // apply text attributes to bottom label
        textFieldBottom.defaultTextAttributes = memeTextAttributes
        textFieldBottom.textAlignment = NSTextAlignment.Center
        
        // apply text attributes to top label
        textFieldTop.defaultTextAttributes = memeTextAttributes
        textFieldTop.textAlignment = NSTextAlignment.Center
        
        // hide tab bar
        tabBarController?.tabBar.hidden = true
        
        // hide navigation bar
        // code found at http://stackoverflow.com/questions/29209453/how-to-hide-a-navigation-bar-from-first-viewcontroller-in-swift
        navigationController?.navigationBarHidden = true

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // check whether exisiting or new meme is edited
        
        if memeToEdit == nil {

            // reset labels if new meme is created
            configureTextField(textFieldTop,
                text: "TOP",
                delegate: self,
                attributes: memeTextAttributes,
                alignment: .Center)

            configureTextField(textFieldBottom,
                text: "BOTTOM",
                delegate: self,
                attributes: memeTextAttributes,
                alignment: .Center)
            
            // temporarily deactivate sharing button if new meme is created
            deactivateButtons()
            
        } else {
            
            // keep texts and images if existing meme is edited
            configureTextField(textFieldTop,
                text: memeToEdit.textOne,
                delegate: self,
                attributes: memeTextAttributes,
                alignment: .Center)
            
            configureTextField(textFieldBottom,
                text: memeToEdit.textTwo,
                delegate: self,
                attributes: memeTextAttributes,
                alignment: .Center)
            
            imagePickerView.image = memeToEdit.originalImage
            
            // ensure sharing button is active if existing meme is edited
            activateButtons()
        }

        // enable delegate methods so that the delegate method can be called when enter is pressed
        textFieldBottom.delegate = self
        textFieldTop.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // dispose of any resources that can be recreated
    }
    
    
    // hide the keyboard when the view will disappear
    override func viewWillDisappear(animated: Bool) {
        unsubscribeFromKeyboardNotifications()
        
        // display the tab bar
        tabBarController?.tabBar.hidden = false
        
        // display the navigation bar
        // code found at http://stackoverflow.com/questions/29209453/how-to-hide-a-navigation-bar-from-first-viewcontroller-in-swift
        navigationController?.navigationBarHidden = false
        
    }
    
    // MARK: functions
    
    // define functions for temporarily deactivating buttons
    func deactivateButtons(){
        
        shareButton.enabled = false
        
    }
    
    // define functions for re-activating buttons
    func activateButtons(){
        
        shareButton.enabled = true
        
    }
    
    // delete old meme
    func deleteOldMeme() {
        //remove meme from meme array
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(memeToEditIndex)
    }

    // set image for editing
    // code error removed after reading https://discussions.udacity.com/t/error-after-updated-to-xcode-7-0/33214
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    func generateMemedImage() -> UIImage
    {
        // hide toolbar and navbar
        toolBar.hidden = true
        navBar.hidden = true
        
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // show toolbar and navbar
        toolBar.hidden = false
        navBar.hidden = false
        
        return memedImage
    }
    
    func save() {
        
        // create meme object
        let memedImage = generateMemedImage()
        
        let meme = Meme(textOne: textFieldTop.text!, textTwo: textFieldBottom.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        // add meme to memes array
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
    
    // MARK: button actions
    
    // action for picking an image from album
    @IBAction func pickAnImage(sender: AnyObject) {
        
        // reactivate share button
        activateButtons()
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    // action for picking an image from camera
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
    
        // reactivate share button
        activateButtons()
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }

    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        
        // code fixed after looking up https://discussions.udacity.com/t/finishing-meme1-0-but-still-stuck/33854/28
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        // error "Application tried to present modally an active controller" fixed after looking up https://discussions.udacity.com/t/value-of-type-view-controller-has-no-member-named-memedimage-error/37194/13
        
        activityViewController.completionWithItemsHandler = { activity, completed, items, error in
            if completed {
                
                // save image
                self.save()
                
                // dismiss activity controller
                self.dismissViewControllerAnimated(true, completion: nil)
                
                // delete old meme
                if self.memeToEdit != nil {
                    
                    self.deleteOldMeme()
                
                }
                    
                // return to MemeCollectionViewController
                self.navigationController?.popToRootViewControllerAnimated(true)

            }
        }
        
        presentViewController(activityViewController, animated: true, completion: nil)

    }
    
}