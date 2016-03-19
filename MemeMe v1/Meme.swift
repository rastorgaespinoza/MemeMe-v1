//
//  Meme.swift
//  MemeMe v1
//
//  Created by Rodrigo Astorga on 3/19/16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    let topString: String!
    let bottomString: String!
    let image: UIImage!
    let memedImage: UIImage!
    
    init(topString: String, bottomString: String, image: UIImage, memedImage: UIImage) {
        self.topString = topString
        self.bottomString = bottomString
        self.image = image
        self.memedImage = memedImage
    }
    
    
    
}