//
//  AdListVIP.swift
//  leminicoin
//
//  Created by Pierre Semler on 15/05/2021.
//

import UIKit

protocol AdListViewControllerProtocol: class {
    func display(categories: [CategoryModel], ads: [AdModel])
    func display(smallImage: UIImage, forCell: AdCell)
}

protocol AdListInteractorProtocol {
    func loadCategoriesAndAds()
    func downloadSmallImage(for url: URL?, forCell: AdCell)
}

protocol AdListPresenterProtocol {
    func present(categories: [CategoryDto], ads: [AdDto])
    func present(smallImageData: Data?, forCell: AdCell)
    func present(error: Error)
}

protocol AdListRouterProtocol: class {
}
