//
//  MemeObject.swift
//  Meme This Pic
//
//  Created by Najeeb Chaudhry on 12/23/18.
//  Copyright © 2018 Najeeb Chaudhry. All rights reserved.
//

import Foundation
import UIKit

class MemeObject {

    struct Meme {
        let topText: String
        let bottomText: String
        let originalImage: UIImage
        let memedImage: UIImage
        
        init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
            self.topText = topText
            self.bottomText = bottomText
            self.originalImage = originalImage
            self.memedImage = memedImage
        }
    }
    
    func generateMemedImage(view: UIView) -> UIImage {  //Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return memedImage
    }
}
