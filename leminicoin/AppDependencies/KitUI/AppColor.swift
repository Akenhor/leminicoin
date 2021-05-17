//
//  AppColor.swift
//  leminicoin
//
//  Created by Pierre Semler on 17/05/2021.
//

import UIKit

enum AppColor {
    case primaryColor
    
    var color: UIColor {
        switch self {
        case .primaryColor:
            return #colorLiteral(red: 0.968627451, green: 0.4196078431, blue: 0.09411764706, alpha: 1)
        }
    }
}
