//
//  AppDependencies.swift
//  leminicoin
//
//  Created by Pierre Semler on 14/05/2021.
//

import Foundation

final class AppDependencies {
    
    static let shared = AppDependencies()
    
    fileprivate(set) lazy var urlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "raw.githubusercontent.com"
        return components
    }()
    
    fileprivate(set) lazy var networkRepository = NetworkRepository(components: urlComponents)
}
