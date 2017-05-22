//
//  ViewController.swift
//  MemeMev1.0
//
//  Created by Satyan on 5/8/17.
//  Copyright © 2017 Satyan. All rights reserved.
//

import UIKit

struct Meme {
    
    // MARK: Properties
    
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
    
}


class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {

    @IBOutlet weak var ImagePickerView: UIImageView!
    
    @IBOutlet weak var YourTextField: UITextField!
   
    @IBOutlet weak var YourOtherTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var TopBar: UIToolbar!
    
    let customDelegate = CustomTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        self.YourTextField.delegate = customDelegate
        YourTextField.defaultTextAttributes = memeTextAttributes
        YourTextField.text = "TOP"
        YourTextField.textAlignment = .center
        
        
        self.YourOtherTextField.delegate = customDelegate
        YourOtherTextField.defaultTextAttributes = memeTextAttributes
        YourOtherTextField.text = "BOTTOM"
        YourOtherTextField.textAlignment = .center
        
        checkForImage(imageView: ImagePickerView)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let memeTextAttributes:[String: Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size:40)!,
        NSStrokeWidthAttributeName: 0.0
    ]
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification:Notification) {
        
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(_ notification:Notification) {
         view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @IBAction func Cancel_Meme() {
        YourTextField.text = "TOP"
        YourOtherTextField.text = "BOTTOM"
        
        ImagePickerView.image = nil
    }
    
    func checkForImage(imageView: UIImageView) {
        shareButton.isEnabled = imageView.image != nil ? true : false
    }

    @IBAction func PickFromCamera(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func PickAnImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ImagePickerView.image = selectedImage;
            checkForImage(imageView: ImagePickerView)
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func save(memedImage: UIImage) {
        // Create the meme
       _ = Meme(topText: YourTextField.text!, bottomText: YourOtherTextField.text!, originalImage: ImagePickerView.image!, memedImage: memedImage)
    }
    
    
    func generateMemedImage() -> UIImage {
        
        // Hide the navigation bar and toolbar
        navigationController?.isNavigationBarHidden = true
        toolbar.isHidden = true
        TopBar.isHidden = true
        
        // Get the image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show the navigation bar and toolbar
        navigationController?.isNavigationBarHidden = false
        toolbar.isHidden = false
        TopBar.isHidden = false
        
        return memedImage
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
            if completed {
                self.save(memedImage: memedImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(activityViewController, animated: true, completion: nil)
    }
    

}

