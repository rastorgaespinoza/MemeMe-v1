//
//  ViewController.swift
//  MemeMe v1
//
//  Created by Rodrigo Astorga on 3/13/16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    private var activeField: UITextField?
    private var isUp: Bool = false
    
    private let textFieldDelegate = TextFieldDelegate()
    
    //MARK: - Lyfe Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFields()

//        topTextField.defaultTextAttributes = memeTextAttributes
//        bottomTextField.defaultTextAttributes = memeTextAttributes
//        topTextField.textAlignment = .Center
//        bottomTextField.textAlignment = .Center
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        
        if imagePickerView.image == nil {
            shareButton.enabled = false
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //MARK: - Actions.
    
    func setupTextFields() {
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),             NSForegroundColorAttributeName : UIColor.whiteColor(),             NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        
        let textFieldArray = [topTextField, bottomTextField]
        
        for i in 0...1 {
            i == 0 ? (topTextField.text = "TOP") : (bottomTextField.text = "BOTTOM")
            
            
            textFieldArray[i].defaultTextAttributes = memeTextAttributes
            textFieldArray[i].textAlignment = .Center
            textFieldArray[i].delegate = textFieldDelegate
        }
//        for i in 0...1 {
//            
//            if let meme = self.meme {
//                i == 0 ? (textFieldArray[i].text = meme.topText) : (textFieldArray[i].text = meme.bottomText)
//            } else {
//                i == 0 ? (textFieldArray[i].text = "TOP TEXT") : (textFieldArray[i].text = "BOTTOM TEXT")
//            }
//            
//            textFieldArray[i].textAlignment = .Center
//            textFieldArray[i].defaultTextAttributes = memeTextAttributes
//            textFieldArray[i].delegate = textFieldDelegate
//        }
    }
    
    @IBAction func shareAction(sender: AnyObject) {
        
        let memedImage = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)

        presentViewController(activityViewController, animated: true, completion: { () -> Void in
            self.saveMeme(memedImage)
        })
        
        
    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        navigationBar.hidden = true
        bottomToolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar
        navigationBar.hidden = false
        bottomToolbar.hidden = false
        
        
        return memedImage
    }
    
    func saveMeme(memedImage: UIImage) {
        _ = Meme(topString: topTextField.text!, bottomString: bottomTextField.text!, image: imagePickerView.image!, memedImage: memedImage)
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imagePickerView.image = nil
        shareButton.enabled = false
    }
    

    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        pickAnImageFrom(.PhotoLibrary)
        
    }

    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        pickAnImageFrom(.Camera)
    }
    
    func pickAnImageFrom(sourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    //MARK: - textfield delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
           
        }
//         activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
//        activeField = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func subscribeToKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
//        guard !isUp else {
//            return
//        }
//        let kbHeight = getKeyboardHeight(notification)
////        view.frame.origin.y -= kbHeight
//        
//        var aRect : CGRect = view.frame
//        aRect.size.height -= kbHeight
//        if let activeField = textField {
//            if (!CGRectContainsPoint(aRect, activeField!.frame.origin)) {
//                isUp = true
//                view.frame.origin.y -= kbHeight
//            }
//        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0.0
//        let kbHeight = getKeyboardHeight(notification)
//        
//        if isUp {
//            isUp = false
//            view.frame.origin.y += kbHeight
//        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
}

//MARK: - imagepicker delegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imagePickerView.image = image
            shareButton.enabled = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
