//
//  AdListVIP.swift
//  leminicoin
//
//  Created by Pierre Semler on 15/05/2021.
//

import UIKit

protocol AdListViewControllerProtocol: class {
    func display(categories: [CategoryModel], ads: [AdListModel])
    func display(smallImage: UIImage, forCell: AdCell)
    func displayDto(dto: AdDto, withCategory: String)
    func display(error title: String, message: String?)
}

protocol AdListInteractorProtocol {
    func loadCategoriesAndAds()
    func getDto(for modelId: Int64, categoryId: Int)
    func downloadSmallImage(for url: URL?, forCell: AdCell, id: Int64)
    func select(filter id: Int)
    func search(for query: String?)
    func clearFilter()
}

protocol AdListPresenterProtocol {
    func present(categories: [CategoryDto], ads: [AdDto], filters: [Int])
    func present(smallImageData: Data?, forCell: AdCell)
    func present(dto: AdDto, withCategory: String)
    func present(error: NetworkError)
}

protocol AdListRouterProtocol: class {
    func navigateToAdDetail(with ad: AdDto, withCategory: String)
}
