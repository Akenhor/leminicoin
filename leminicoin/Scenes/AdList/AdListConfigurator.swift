//
//  AdListConfigurator.swift
//  leminicoin
//
//  Created by Pierre Semler on 15/05/2021.
//

import UIKit

enum AdListConfigurator {
    
    static func configure(viewController: AdListViewController) {
        
        let presenter = AdListPresenter()
        presenter.output = viewController
        
        let interactor = AdListInteractor()
        interactor.output = presenter
        
        viewController.output = interactor
    }
}