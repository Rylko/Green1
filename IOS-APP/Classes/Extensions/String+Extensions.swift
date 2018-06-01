//
//  String+Extensions.swift
//  motem-ios
//
//  Created by Mobexs on 1/6/17.
//  Copyright © 2017 Mobexs.com. All rights reserved.
//

import Foundation
import UIKit


extension String {
    
    var length: Int {
        return self.count
    }
    
    subscript (i: Int) -> String {
        return self[Range(i ..< i + 1)]
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, length) ..< length)]
    }
    
    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[Range(start ..< end)])
    }
    
    func underlineString(fontSize: CGFloat, color : UIColor) -> NSAttributedString {

        let attributes = [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: fontSize),
            NSAttributedStringKey.foregroundColor : color,
            NSAttributedStringKey.underlineStyle  : NSUnderlineStyle.styleSingle.rawValue
        ] as [NSAttributedStringKey : Any]
        
        return NSAttributedString(string: self, attributes: attributes)
    }
}
