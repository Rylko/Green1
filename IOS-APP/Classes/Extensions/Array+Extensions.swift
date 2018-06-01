//
//  Array+Extensions.swift
//  motem-ios
//
//  Created by Mobexs on 2/10/17.
//  Copyright © 2017 Mobexs.com. All rights reserved.
//

import Foundation

extension Array where Element : Equatable {
    
    mutating func remove(object: Element) {
        
        if let index = index(of: object) {
            
            remove(at: index)
        }
    }
}
