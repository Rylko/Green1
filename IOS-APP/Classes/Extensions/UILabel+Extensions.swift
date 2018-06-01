//
//  UILabel+Extensions.swift
//  motem-ios
//
//  Created by Mobexs on 9/4/17.
//  Copyright © 2017 Mobexs.com. All rights reserved.
//

import UIKit

extension UILabel {
    
    var isTruncated: Bool {
        
        guard let labelText = text else {
            return false
        }
        
        let labelTextSize = (labelText as NSString).boundingRect(
            
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedStringKey.font: font],
            context: nil).size
        
        return labelTextSize.height > bounds.size.height
    }
}
