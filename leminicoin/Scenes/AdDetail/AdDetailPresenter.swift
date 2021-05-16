//
//  AdDetailPresenter.swift
//  leminicoin
//
//  Created by Pierre Semler on 16/05/2021.
//

import UIKit

final class AdDetailPresenter {
    var output: AdDetailViewControllerProtocol!
    
    private func convert(adDto: AdDto, withCategory: String?) -> AdDetailModel? {
        
        guard let categoryName = withCategory,
              let price = adDto.price,
              let creationDate = adDto.creation_date,
              let isUrgent = adDto.is_urgent
        else {
            return nil
        }
        
        return AdDetailModel(
            categoryName: categoryName,
            title: adDto.title,
            description: adDto.description,
            thumbImageUrl: URL(string: adDto.images_url?.thumb ?? ""),
            price: PriceConverter.convert(amount: price),
            creationDate: DateConverter.format(from: creationDate, dateType: .iso8601, withTime: true),
            isUrgentImage: isUrgent ? #imageLiteral(resourceName: "AdIsUrgent") : nil
        )
    }
}

extension AdDetailPresenter: AdDetailPresenterProtocol {
    func present(ad: AdDto, withCategory: String?) {
        guard let adModel = convert(adDto: ad, withCategory: withCategory) else {
           return
        }
        output.display(ad: adModel)
    }
    
    func present(thumbImageData: Data?) {
        var image = #imageLiteral(resourceName: "ImagePlaceholder")
        
        if let data = thumbImageData, let img = UIImage(data: data) {
            image = img
        }
        output.display(thumbImage: image)
    }
}
