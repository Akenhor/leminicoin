//
//  ServicesServerConfiguration.swift
//  leminicoin
//
//  Created by Pierre Semler on 16/05/2021.
//

import Foundation

struct ServicesServerConfiguration {
    let serverProtocol: String
    let hostName: String
    
    init(with dictionary: [String: AnyObject]) {
        serverProtocol = dictionary["protocol"] as? String ?? ""
        hostName = dictionary["host"] as? String ?? ""
    }
}
