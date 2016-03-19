//
//  TextFieldDelegate.swift
//  MemeMe v1
//
//  Created by Rodrigo Astorga on 3/19/16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
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
    
    
}
