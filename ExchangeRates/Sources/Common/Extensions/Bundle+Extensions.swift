//
//  Bundle+Extensions.swift
//  ExchangeRates
//
//  Created by Vladyslav Vdovychenko on 14.03.2022.
//

import Foundation

extension Bundle {
    
    class func getIdentifier() -> String {
        guard let info = Bundle.main.infoDictionary,
            let bundleIdentifier = info["CFBundleIdentifier"] as? String else {
                return ""
        }
        
        return bundleIdentifier
    }
    
    class func getVersion() -> String {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String else {
                return ""
        }
        
        return currentVersion
    }
    
}
