//
//  AdListInteractor.swift
//  leminicoin
//
//  Created by Pierre Semler on 15/05/2021.
//

import Foundation

final class AdListInteractor {
    var output: AdListPresenterProtocol!
}

extension AdListInteractor: AdListInteractorProtocol {
    
    func loadCategoriesAndAds() {
        let serviceGroup = DispatchGroup()
        var tmpAds = [AdDto]()
        var tmpCats = [CategoryDto]()
        
        serviceGroup.enter()
        
        AppDependencies.shared.networkRepository.loadCategories { (result: Result<[CategoryDto], Error>) in
            switch result {
            case .success(let categories):
                tmpCats = categories
            case .failure(let error):
                #if DEBUG
                    print(error)
                #endif
            }
            serviceGroup.leave()
        }
        
        serviceGroup.enter()
        
        AppDependencies.shared.networkRepository.loadAds { (result: Result<[AdDto], Error>) in
            switch result {
            case .success(let ads):
                tmpAds = ads
            case .failure(let error):
                #if DEBUG
                    print(error)
                #endif
            }
            serviceGroup.leave()
        }
        
        serviceGroup.notify(queue: DispatchQueue.main) { [weak self] in
            self?.output.present(categories: tmpCats, ads: tmpAds)
        }
        
    }
    
    func downloadSmallImage(for url: URL?, forCell: AdCell) {
        guard let url = url else {
            output.present(smallImageData: nil, forCell: forCell)
            return
        }
        AppDependencies.shared.networkRepository.downloadAdImage(at: url) { [weak self] (result: (Result<Data?, Error>)) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.output.present(smallImageData: data, forCell: forCell)
                case .failure:
                    self?.output.present(smallImageData: nil, forCell: forCell)
                }
            }
        }
    }
}
