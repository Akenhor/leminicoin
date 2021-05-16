//
//  AdDetailVIP.swift
//  leminicoin
//
//  Created by Pierre Semler on 16/05/2021.
//

import Foundation
import UIKit

protocol AdDetailViewControllerProtocol: class {
    func display(ad: AdDetailModel)
    func display(thumbImage: UIImage)
    func display(date: String)
}

protocol AdDetailInteractorProtocol {
    func prepare(ad: AdDto, withCategory: String)
    func loadDetail()
}

protocol AdDetailPresenterProtocol {
    func present(ad: AdDto, withCategory: String?)
    func present(thumbImageData: Data?)
}
