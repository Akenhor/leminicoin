//
//  AdListPresenter.swift
//  leminicoin
//
//  Created by Pierre Semler on 15/05/2021.
//

import Foundation
import UIKit

final class AdListPresenter {
    var output: AdListViewControllerProtocol!
    
    private func convert(categories: [CategoryDto]) -> [CategoryModel] {
        return categories
            .compactMap { category in
                guard let id = category.id,
                      let name = category.name else {
                    return nil
                }
                return CategoryModel(id: id, name: name)
            }
    }
    
    private func convert(ads: [AdDto], categories: [CategoryModel]) -> [AdModel] {
        return ads.compactMap { (adDto: AdDto) in
            guard let id = adDto.id,
                  let categoryId = adDto.category_id,
                  let category = categories.first(where: { category in category.id == categoryId }),
                  let price = adDto.price,
                  let creationDate = adDto.creation_date
            else {
                return nil
            }
            
            return AdModel(
                id: id,
                category: category,
                title: adDto.title,
                description: adDto.description,
                smallImageUrl: URL(string: adDto.images_url?.small ?? ""),
                thumbImageUrl: URL(string: adDto.images_url?.thumb ?? ""),
                price: PriceConverter.convert(amount: price),
                creationDate: DateConverter.format(from: creationDate, dateType: .iso8601, withTime: true),
                isUrgent: adDto.is_urgent ?? false
            )
        }
    }
}

extension AdListPresenter: AdListPresenterProtocol {
    func present(smallImageData: Data?, forCell: AdCell) {
        var image = #imageLiteral(resourceName: "ImagePlaceholder")
        
        if let data = smallImageData, let img = UIImage(data: data) {
            image = img
        }
        output.display(smallImage: image, forCell: forCell)
    }
    
    func present(categories: [CategoryDto], ads: [AdDto]) {
        let categories = convert(categories: categories)
        let ads = convert(ads: ads, categories: categories)
        output?.display(categories: categories, ads: ads)
    }
    
    func present(error: Error) {
        
    }
}
