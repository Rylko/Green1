//
//  UIView+Extensions.swift
//  motem-ios
//
//  Created by Mobexs on 1/30/17.
//  Copyright © 2017 Mobexs.com. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: self.classForCoder), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
}
