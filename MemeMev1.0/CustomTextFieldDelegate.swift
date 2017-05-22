//
//  CustomTextFieldDelegate.swift
//  MemeMev1.0
//
//  Created by Satyan on 5/8/17.
//  Copyright © 2017 Satyan. All rights reserved.
//

import Foundation
import UIKit

class CustomTextFieldDelegate: NSObject, UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}
