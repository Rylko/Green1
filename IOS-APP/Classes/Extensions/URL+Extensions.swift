//
//  URL+Extensions.swift
//  motem-ios-web
//
//  Created by Mobexs on 4/11/18.
//  Copyright © 2018 Mobexs.com. All rights reserved.
//

import Foundation

extension URL {
    
    func changeScheme(toScheme: String) -> URL? {
        
        var urlComponents = self.absoluteString.components(separatedBy: "//")
        
        guard urlComponents.count >= 2 else { return nil }
        urlComponents[0] = "\(toScheme)://"
        let newURLString: String = urlComponents.joined()
        let newURL = URL(string: newURLString)
        
        return newURL
    }
}
