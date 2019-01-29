//
//  KeyboardAdjustments.swift
//  Meme This Pic
//
//  Created by Najeeb Chaudhry on 12/23/18.
//  Copyright © 2018 Najeeb Chaudhry. All rights reserved.
//
//  Move views above keyboard as keyboard slides up, move views back down as keyboard slides down
//

import Foundation
import UIKit

class KeyboardAdjustments {
    
    static var view: UIView!
    static var bottomTextFieldClicked: Bool = false     
    
    //Notification announce of keyboard appearing/disappearing
    @objc func keyboardWillShow(_ notification: Notification) {
        if KeyboardAdjustments.bottomTextFieldClicked { //Move views up when keyboard pops up only for bottom text field
            KeyboardAdjustments.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        KeyboardAdjustments.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue //of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
