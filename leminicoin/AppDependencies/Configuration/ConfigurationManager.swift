//
//  ConfigurationManager.swift
//  leminicoin
//
//  Created by Pierre Semler on 16/05/2021.
//

import Foundation

class ConfigurationManager {
    private static let debugInstance = ConfigurationManager(fileName: "Config")
    private static let releaseInstance = ConfigurationManager(fileName: "ConfigRelease")
    
    static var sharedInstance: ConfigurationManager {
        #if DEBUG
            return debugInstance
        #elseif RELEASE
            return releaseInstance
        #endif
    }
    
    let server: ServicesServerConfiguration?
    
    init(fileName: String){
        guard let path = Bundle.main.path(forResource: fileName, ofType: "plist"), let configDictionary = NSDictionary(contentsOfFile: path) else {
            server = nil
            return
        }
        let serverDictionary = configDictionary["server"] as! [String: AnyObject]
        server = ServicesServerConfiguration(with: serverDictionary["services"] as! [String: AnyObject])
    }
}
