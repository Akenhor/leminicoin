//
//  AdListInteractor.swift
//  leminicoin
//
//  Created by Pierre Semler on 15/05/2021.
//

import Foundation

final class AdListInteractor {
    var output: AdListPresenterProtocol!
    var appDependency: AppDependencies!
    var ads: [AdDto] = []
    var categories: [CategoryDto] = []
    var filters: [Int] = []
    var searchFilter: String = ""
    
    private func sortByUrgenceAndDate(ads: [AdDto]) -> [AdDto] {
        return ads.filter { adDto in
                guard let _ = adDto.is_urgent, let lhsCreationDate = adDto.creation_date, let _ = DateConverter.date(from: lhsCreationDate, dateType: .iso8601) else {
                    return false
                }
                return true
            }
            .sorted { (lhs, rhs) -> Bool in
            
                if (lhs.is_urgent! != rhs.is_urgent) {
                    return lhs.is_urgent! && !rhs.is_urgent!
                } else {
                    return DateConverter.date(from: lhs.creation_date!, dateType: .iso8601)! > DateConverter.date(from: rhs.creation_date!, dateType: .iso8601)!
                }
            } + ads.filter { adDto in
                guard let _ = adDto.is_urgent, let lhsCreationDate = adDto.creation_date, let _ = DateConverter.date(from: lhsCreationDate, dateType: .iso8601) else {
                    return true
                }
                return false
            }
    }
    
    private func filter(ads: [AdDto]) -> [AdDto] {
        return ads.filter { adDto in
            guard let categoryId = adDto.category_id else { return false }
            if !searchFilter.isEmpty {
                guard let adDtoTitle = adDto.title else { return false }
                return (filters.contains(categoryId) || filters.count == 0) && (adDtoTitle.lowercased() .contains(searchFilter.lowercased()) || searchFilter.isEmpty)
            } else {
                return (filters.contains(categoryId) || filters.count == 0)
            }
        }
    }
    
    private func applyFilter() {
        let filteredAds = self.filter( ads: self.ads)
        self.output.present(categories: self.categories, ads: filteredAds, filters: self.filters)
    }
}

extension AdListInteractor: AdListInteractorProtocol {
 
    func loadCategoriesAndAds() {
        let serviceGroup = DispatchGroup()
        
        serviceGroup.enter()
        
        appDependency.networkRepository.loadCategories { [weak self] (result: Result<[CategoryDto], NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let categories):
                    self?.categories = categories
                case .failure(let error):
                    self?.output.present(error: error)
                }
                serviceGroup.leave()
            }
        }
        
        serviceGroup.enter()
        
        appDependency.networkRepository.loadAds { [unowned self] (result: Result<[AdDto], NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let ads):
                    self.ads = self.sortByUrgenceAndDate(ads: ads)
                case .failure(let error):
                    self.output.present(error: error)
                }
                serviceGroup.leave()
            }
        }
        
        serviceGroup.notify(queue: DispatchQueue.main) { [unowned self] in
            applyFilter()
        }
    }
    
    func downloadSmallImage(for url: URL?, forCell: AdCell, id: Int64) {
        guard let url = url else {
            if(forCell.representedIdentifier == id) {
                output.present(smallImageData: nil, forCell: forCell)
            }
            return
        }
        appDependency.networkRepository.downloadAdImage(at: url) { [weak self] (result: (Result<Data?, NetworkError>)) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if(forCell.representedIdentifier == id) {
                        self?.output.present(smallImageData: data, forCell: forCell)
                    }
                case .failure:
                    if(forCell.representedIdentifier == id) {
                        self?.output.present(smallImageData: nil, forCell: forCell)
                    }
                }
            }
        }
    }
    
    func getDto(for modelId: Int64, categoryId: Int) {
        guard let adDto = ads.first(where: { dto in return dto.id == modelId }), let category = categories.first(where: { category in return category.id == categoryId }), let categoryName = category.name else {
            return
        }
        output.present(dto: adDto, withCategory: categoryName)
    }
    
    func select(filter id: Int) {
        if filters.contains(id) {
            filters.removeAll{ filterId in filterId == id }
        } else {
            filters.append(id)
        }
        applyFilter()
    }
    
    func clearFilter() {
        filters.removeAll()
        applyFilter()
    }
    
    func search(for query: String?) {
        searchFilter = query ?? ""
        applyFilter()
    }
}
