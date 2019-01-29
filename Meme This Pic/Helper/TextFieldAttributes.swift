//
//  TextFieldAttributes.swift
//  Meme This Pic
//
//  Created by Najeeb Chaudhry on 12/22/18.
//  Copyright © 2018 Najeeb Chaudhry. All rights reserved.
//

import Foundation
import UIKit

/*
Read: https://developer.apple.com/documentation/foundation/nsattributedstring/key
The UITextField class comes with a defaultTextAttributes property. This property takes a dictionary of attributes chosen from the Keys specified in the NSAttributedString. class. We set this property once using a dictionary. From then on text will be displayed with the defined characteristics.
*/
class TextFieldAttributes {
    let textFieldTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.white,
        NSAttributedString.Key.foregroundColor: UIColor.black,
        NSAttributedString.Key.font: UIFont(name: "KohinoorTelugu-Light", size: 30)!,
        NSAttributedString.Key.strokeWidth: 10.0
    ]
}

