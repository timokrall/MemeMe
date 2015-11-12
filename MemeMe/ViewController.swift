//
//  ViewController.swift
//  MemeMe
//
//  Created by Timo Krall on 11/3/15.
//  Copyright © 2015 Timo Krall. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var textFieldBottom: UITextField!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UIToolbar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    // define text attributes
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -4
    ]
    
    // function for moving the screen
    // fixed after reading https://discussions.udacity.com/t/need-help-for-hiding-keyboard-and-meme-struct/15614/4
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
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
        
    }
    
    // define functions for temporarily deactivating buttons
    func deactivateButtons(){
        
        shareButton.enabled = false
        cancelButton.enabled = false
        
    }
    
    // define functions for re-activating buttons
    func activateButtons(){
        
        shareButton.enabled = true
        cancelButton.enabled = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // temporarily deactivate sharing and cancel buttons
        deactivateButtons()

        // enable delegate methods so that the delegate method can be called when enter is pressed
        textFieldBottom.delegate = self
        textFieldTop.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // function for hiding the keyboard
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    // hide the keyboard when the view will disappear
    override func viewWillDisappear(animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }

    // set image for editing
    // code error removed after reading https://discussions.udacity.com/t/error-after-updated-to-xcode-7-0/33214
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // use a delegate method to dismiss keyboard when enter is pressed
    // fixed after reading http://sourcefreeze.com/uitextfield-and-uitextfield-delegate-in-swift/
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    // action for picking an image from album
    @IBAction func pickAnImage(sender: AnyObject) {
        
        // reactivate share and cancel button
        activateButtons()
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    // action for picking an image from camera
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
    
        // reactivate share and cancel button
        activateButtons()
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    struct Meme {
        
        var textOne: String!
        var textTwo: String!
        var originalImage: UIImage?
        var memedImage: UIImage?
    
    }
    
    func generateMemedImage() -> UIImage
    {
        // hide toolbar and navbar
        toolBar.hidden = true
        navBar.hidden = true
        
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // show toolbar and navbar
        toolBar.hidden = false
        navBar.hidden = false
        
        return memedImage
    }
    
    func save() {
        // create meme object
        _ = Meme(textOne: textFieldTop.text!, textTwo: textFieldBottom.text!, originalImage: imagePickerView.image, memedImage: generateMemedImage())
        
    }
    
    // cancel the meme creation process
    @IBAction func cancelMemedImage(sender: AnyObject) {
        
        textFieldTop.text = "TOP"
        textFieldBottom.text = "BOTTOM"
        imagePickerView.image = nil
        deactivateButtons()
        
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        
        // code fixed after looking up https://discussions.udacity.com/t/finishing-meme1-0-but-still-stuck/33854/28
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        presentViewController(controller, animated: true, completion: nil)
        
        controller.completionWithItemsHandler = {
            (activity: String?, completed: Bool, items: [AnyObject]?, error: NSError?) -> Void in
            if completed {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        save()

    }
    
    
}