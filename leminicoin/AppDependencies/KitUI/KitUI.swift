//
//  KitUI.swift
//  leminicoin
//
//  Created by Pierre Semler on 15/05/2021.
//

import Foundation

protocol KitUIDependency {
    static func showLoader()
    static func hideLoader()
}

class KitUI: KitUIDependency {
    fileprivate(set) static var loader: Loader = Loader()
    
    static func showLoader() {
        loader.show()
    }
    
    static func hideLoader() {
        loader.hide()
    }
}
