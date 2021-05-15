//
//  PriceConverter.swift
//  leminicoin
//
//  Created by Pierre Semler on 15/05/2021.
//

import Foundation

protocol PriceConverterHelper {
    static func convert(amount: Float) -> String
}

final class PriceConverter: PriceConverterHelper {
    fileprivate static var numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.locale = Locale.current
        nf.allowsFloats = true
        return nf
    }()
    
    static func convert(amount: Float) -> String {
        guard let price = numberFormatter.string(from: NSNumber(value: amount)) else {
            return "N/A"
        }
        
        return price
    }
}
