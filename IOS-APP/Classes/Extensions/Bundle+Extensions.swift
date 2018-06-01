//
//  Bundle+Extensions.swift
//  motem-ios
//
//  Created by Mobexs on 1/18/17.
//  Copyright © 2017 Mobexs.com. All rights reserved.
//

import Foundation

extension Bundle {

    static func getBaseURL() -> String {

        guard let dictionary = Bundle.main.infoDictionary else { return "" }
        return dictionary["BaseURL"] as! String
    }

    static func getWeatherBaseURL() -> String {

        guard let dictionary = Bundle.main.infoDictionary else { return "" }
        return dictionary["WeatherBaseURL"] as! String
    }

    static func getWeatherAPIKey() -> String {

        guard let dictionary = Bundle.main.infoDictionary else { return "" }
        return dictionary["WeatherAPIKey"] as! String
    }
    
    static func getAppVersion() -> String {
        
        guard let dictionary = Bundle.main.infoDictionary else { return "" }
        return dictionary["CFBundleShortVersionString"] as! String
    }
    
    static func getNativeLoginURL() -> String {
        
        guard let dictionary = Bundle.main.infoDictionary else { return "" }
        return dictionary["NativeLoginURL"] as! String
    }
}
