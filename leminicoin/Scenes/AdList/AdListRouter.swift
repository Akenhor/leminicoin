//
//  AdListRouter.swift
//  leminicoin
//
//  Created by Pierre Semler on 16/05/2021.
//

import Foundation

final class AdListRouter {
    var viewController: AdListViewController!
}

extension AdListRouter: AdListRouterProtocol {
    func navigateToAdDetail(with ad: AdDto, withCategory: String) {
        let vc = AdDetailViewController()
        vc.output.prepare(ad: ad, withCategory: withCategory)
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
}
