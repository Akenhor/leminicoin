//
//  AdListConfigurator.swift
//  leminicoin
//
//  Created by Pierre Semler on 15/05/2021.
//

import UIKit

enum AdListConfigurator {
    
    static func configure(viewController: AdListViewController) {
        let router = AdListRouter()
        router.viewController = viewController
        
        let presenter = AdListPresenter()
        presenter.output = viewController
        
        let interactor = AdListInteractor()
        interactor.output = presenter
        interactor.appDependency = AppDependencies.shared
        
        viewController.output = interactor
        viewController.router = router
    }
}
