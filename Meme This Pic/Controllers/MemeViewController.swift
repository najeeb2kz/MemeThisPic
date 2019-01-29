//
//  ViewController.swift
//  Meme This Pic
//
//  Created by Najeeb Chaudhry on 12/20/18.
//  Copyright © 2018 Najeeb Chaudhry. All rights reserved.
//

import UIKit
import AVFoundation

class MemeViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navigationbar: UINavigationBar!
    
    let pickerControllerAlbum = UIImagePickerController()
    let pickerControllerCamera = UIImagePickerController()
    let textFieldAttributes = TextFieldAttributes()
    let keyboardAdjustments = KeyboardAdjustments()
    let memeObject = MemeObject()
    let defaultText = "Write here"
    var userPickedImage: UIImage? = nil
    var memedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        KeyboardAdjustments.view = view     //Set rootview to KeyboardAdjustments.swift
        self.topTextField.delegate = self
        self.topTextField.defaultTextAttributes = textFieldAttributes.textFieldTextAttributes
        self.bottomTextField.delegate = self
        self.bottomTextField.defaultTextAttributes = textFieldAttributes.textFieldTextAttributes
        pickerControllerAlbum.delegate = self
        pickerControllerCamera.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideStatusBar()
        if imageView.image == nil {
            shareButton.isEnabled = false
        }
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)  //Returns bool, check if camera in device
        keyboardAdjustments.subscribeToKeyboardNotifications()  //Subscribe to keyboard notifications to allow view to raise when necessary
        self.topTextField.textAlignment = .center
        self.bottomTextField.textAlignment = .center
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showStatusBar() //If I don't unhide status bar then it will stay hidden for other controller also
        keyboardAdjustments.unsubscribeToKeyboardNotifications()
    }

    func save() {   //Create the meme
        let meme = MemeObject.Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
        //Add meme to memes array in the AppDelegate.swift
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        print("......... meme saved in appDelegate")
    }
    
    func openCamera() {
        pickerControllerCamera.sourceType = .camera  //Take a new pic or make movie
        present(pickerControllerCamera, animated: true, completion: nil)
    }
    
    func showAlertViewController() {
        let controller = UIAlertController()
        controller.title = "Camera access required for capturing photos"
        controller.message = "To enable access, close this app, go to phone's Settings > Privacy > Camera > turn on Camera access for this app"
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { action in
            self.dismiss(animated: true, completion: nil)
        }
        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)
    }
    
    func dismissThisSelfViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickImageButtonPressedPickImageFromAlbum(_ sender: Any) {
        pickerControllerAlbum.sourceType = .photoLibrary  //Choose from saved pics or vidoes
        present(pickerControllerAlbum, animated: true, completion: nil)
    }
    
    @IBAction func pickImageButtonPressedPickImageFromCamera(_ sender: Any) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
        case .authorized:
            print("......... Camera permission authorized")
            openCamera()
        case .notDetermined:
            print("......... Camera permission notDetermined")
            openCamera()
        case .restricted:
            print("......... Camera permission restricted")
            openCamera()
        case .denied:
            print("......... Camera permission denied")
            showAlertViewController()
        }
    }
    
    @IBAction func resetApp(_ sender: Any) {
        if imageView.image == nil {
            dismissThisSelfViewController()  //rootViewController is TabBarController
        } else {
            imageView.image = nil
            shareButton.isEnabled = false
            putDefaultTextInTopTextField()
            putDefaultTextInBotomTextField()
        }
    }
    
    @IBAction func shareMemedImage(_ sender: Any) {
        hideNavigationBar()
        hideToolbar()
        memedImage = memeObject.generateMemedImage(view: view)
        showNavigationBar()
        showToolbar()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.present(controller, animated: true) {
            self.save()
        }
        //Following will dismiss Meme editor upon completion (done or cancelled by user) of UIActivityViewController
        controller.completionWithItemsHandler = { activity, completed, items, errors in
            self.dismissThisSelfViewController()
        }
    }
}

extension MemeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //print("......... image picked info.description: " + info.description)  //Uncomment if image info needed
        if let image = info[.editedImage] as? UIImage {
            userPickedImage = image
        } else if let image = info[.originalImage] as? UIImage {
            userPickedImage = image
        }
        imageView.image = userPickedImage
        picker.dismiss(animated: true, completion: nil)
        shareButton.isEnabled = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        emptyTopTextField()
        emptyBottomTextField()
        putDefaultTextInTopTextField()
        putDefaultTextInBotomTextField()
        picker.dismiss(animated: true, completion: nil)
    }
}

extension MemeViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Move views up when keyboard pops up only for bottom text field, TopTextField.tag = 0, BottomTextField.tag = 1
        if textField.tag == 1 { KeyboardAdjustments.bottomTextFieldClicked = true }
        else if textField.tag == 0 { KeyboardAdjustments.bottomTextFieldClicked = false }
        if textField.text == defaultText {  //if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //Close keyboard
        if topTextField.text == "" { putDefaultTextInTopTextField() }
        else if bottomTextField.text == "" { putDefaultTextInBotomTextField() }
        textField.resignFirstResponder()
        return true
    }
    
    func emptyTopTextField() {
        topTextField.text = ""
    }
    
    func emptyBottomTextField() {
        bottomTextField.text = ""
    }
    
    func putDefaultTextInTopTextField() {
        topTextField.text = defaultText
    }
    
    func putDefaultTextInBotomTextField() {
        bottomTextField.text = defaultText
    }
}

extension MemeViewController {
    func hideToolbar() {
        self.toolbar.isHidden = true
    }
    
    func showToolbar() {
        self.toolbar.isHidden = false
    }
    
    func hideStatusBar() { //status bar shows signal, time and battery
        UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.statusBar
    }
    
    func showStatusBar() {
        UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.normal
    }
    
    func hideNavigationBar() {
        self.navigationbar.isHidden = true
    }
    
    func showNavigationBar() {
        self.navigationbar.isHidden = false
    }
}

