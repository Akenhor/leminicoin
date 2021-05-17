//
//  AdListInteractor.swift
//  leminicoin
//
//  Created by Pierre Semler on 15/05/2021.
//

import Foundation

final class AdListInteractor {
    var output: AdListPresenterProtocol!
    var ads: [AdDto] = []
    var categories: [CategoryDto] = []
    var filters: [Int] = []
    var searchFilter: String = ""
    
    private func sortByUrgenceAndDate(ads: [AdDto]) -> [AdDto] {
        return ads.sorted { (lhs, rhs) -> Bool in
            guard let lhsIsUrgent = lhs.is_urgent, let rhsIsUrgent = rhs.is_urgent, let lhsCreationDate = lhs.creation_date, let rhsCreationDate = rhs.creation_date, let lhsDate = DateConverter.date(from: lhsCreationDate, dateType: .iso8601), let rhsDate = DateConverter.date(from: rhsCreationDate, dateType: .iso8601) else {
                return false
            }
            if (lhsIsUrgent != rhsIsUrgent) {
                return lhsIsUrgent && !rhsIsUrgent
            } else {
                return lhsDate > rhsDate
            }
        }
    }
    
    private func filter(ads: [AdDto]) -> [AdDto] {
        return ads.filter { adDto in
            guard let categoryId = adDto.category_id, let adTitle = adDto.title else { return false }
            return (filters.contains(categoryId) || filters.count == 0) && (adTitle.lowercased() .contains(searchFilter.lowercased()) || searchFilter.isEmpty)
        }
    }
    
    private func applyFilter() {
        let filteredAds = self.filter( ads: self.ads)
        self.output.present(categories: self.categories, ads: filteredAds, filters: self.filters)
    }
    
    private func manageError(error: Error) {
        if let err = error as? NetworkError {
            switch err {
                case .dataTaskError,
                     .badLocalUrl,
                     .noData:
                    output.present(error: err)
                default:
                    break
                }
        }
        #if DEBUG
            print(error)
        #endif
    }
}

extension AdListInteractor: AdListInteractorProtocol {
 
    func loadCategoriesAndAds() {
        let serviceGroup = DispatchGroup()
        
        serviceGroup.enter()
        
        AppDependencies.shared.networkRepository.loadCategories { [weak self] (result: Result<[CategoryDto], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let categories):
                    self?.categories = categories
                case .failure(let error):
                    self?.manageError(error: error)
                }
                serviceGroup.leave()
            }
        }
        
        serviceGroup.enter()
        
        AppDependencies.shared.networkRepository.loadAds { [unowned self] (result: Result<[AdDto], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let ads):
                    self.ads = self.sortByUrgenceAndDate(ads: ads)
                case .failure(let error):
                    self.manageError(error: error)
                }
                serviceGroup.leave()
            }
        }
        
        serviceGroup.notify(queue: DispatchQueue.main) { [unowned self] in
            applyFilter()
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
    
    func getDto(for model: AdListModel) {
        guard let adDto = ads.first(where: { dto in return dto.id == model.id }), let category = categories.first(where: { category in return category.id == model.category.id }), let categoryName = category.name else {
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
