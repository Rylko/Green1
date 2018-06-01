//
//  UIAlertController+Extensions.swift
//  motem-ios
//
//  Created by Mobexs on 2/21/17.
//  Copyright © 2017 Mobexs.com. All rights reserved.
//

import UIKit
import Foundation

extension UIAlertController {
    
    typealias AlertHandler = ((UIAlertAction) -> Void)?
    
    static func showAlert(target: UIViewController, title: String, message: String, buttonTitle: String, handler: AlertHandler) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: handler)
        alertController.addAction(action)
        target.present(alertController, animated: true, completion: nil)
    }
}

