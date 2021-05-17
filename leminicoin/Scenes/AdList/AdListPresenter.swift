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
    
    private func convert(categories: [CategoryDto], filters: [Int]) -> [CategoryModel] {
        return categories
            .compactMap { category in
                guard let id = category.id,
                      let name = category.name else {
                    return nil
                }
                let backgroundColor = filters.contains(id) ? AppColor.primaryColor.color : .white
                let titleColor = filters.contains(id) ? .white : AppColor.primaryColor.color
                return CategoryModel(id: id, name: name, backgroundColor: backgroundColor, titleColor: titleColor)
            }
    }
    
    private func convert(ads: [AdDto], categories: [CategoryModel]) -> [AdListModel] {
        return ads.compactMap { (adDto: AdDto) in
            guard let id = adDto.id,
                  let categoryId = adDto.category_id,
                  let category = categories.first(where: { category in category.id == categoryId }),
                  let price = adDto.price,
                  let isUrgent = adDto.is_urgent
            else {
                return nil
            }
            
            return AdListModel(
                id: id,
                category: category,
                title: adDto.title,
                smallImageUrl: URL(string: adDto.images_url?.small ?? ""),
                price: PriceConverter.convert(amount: price),
                isUrgentImage: isUrgent ? #imageLiteral(resourceName: "AdIsUrgent") : nil
            )
        }
    }
    
    private func convert(error: NetworkError) -> (String?) {
        switch error {
        case .dataTaskError:
            return L10n.Error.DataTask.message
        case .badResponse:
            return L10n.Error.BadResponse.message
        case .noData:
            return L10n.Error.NoData.message
        default:
            return nil
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
    
    func present(categories: [CategoryDto], ads: [AdDto], filters: [Int]) {
        let categories = convert(categories: categories, filters: filters)
        let ads = convert(ads: ads, categories: categories)
        output?.display(categories: categories, ads: ads)
    }
    
    func present(error: NetworkError) {
        let customMessage = convert(error: error)
        output.display(error: L10n.Error.Generic.title, message: customMessage)
    }
    
    func present(dto: AdDto, withCategory: String) {
        output.displayDto(dto: dto, withCategory: withCategory)
    }
}
