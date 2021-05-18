//
//  AdDetailConfigurator.swift
//  leminicoin
//
//  Created by Pierre Semler on 16/05/2021.
//

import Foundation

enum AdDetailConfigurator {
    
    static func configure(viewController: AdDetailViewController) {
        
        let presenter = AdDetailPresenter()
        presenter.output = viewController
        
        let interactor = AdDetailInteractor()
        interactor.output = presenter
        interactor.appDependency = AppDependencies.shared
        
        viewController.output = interactor
    }
}
