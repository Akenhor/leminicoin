//
//  NetworkRepository.swift
//  leminicoin
//
//  Created by Pierre Semler on 14/05/2021.
//

import Foundation

protocol NetworkDependency {
    var networkService: NetworkService { get }
    func loadAds(completion: @escaping (Result<[AdDto], NetworkError>) -> Void)
    func loadCategories(completion: @escaping (Result<[CategoryDto], NetworkError>) -> Void)
    func downloadAdImage(at url: URL?, completion: @escaping (Result<Data?, NetworkError>) -> Void)
}

class NetworkRepository: NetworkDependency {
    
    private var components: URLComponents
    fileprivate(set) lazy var networkService: NetworkService = NetworkService(with: components)
    fileprivate lazy var emptyUrl = { return URL(fileURLWithPath: "")}()
    
    init(components: URLComponents) {
        self.components = components
    }

    func loadAds(completion: @escaping (Result<[AdDto], NetworkError>) -> Void) {
        self.components.path = "/leboncoin/paperclip/master/listing.json"
        networkService.request(urlRequest: URLRequest(url: components.url ?? emptyUrl), completion: completion)
    }
    
    func loadCategories(completion: @escaping (Result<[CategoryDto], NetworkError>) -> Void) {
        self.components.path = "/leboncoin/paperclip/master/categories.json"
        networkService.request(urlRequest: URLRequest(url: components.url ?? emptyUrl), completion: completion)
    }
    
    func downloadAdImage(at url: URL?, completion: @escaping (Result<Data?, NetworkError>) -> Void) {
        networkService.download(urlRequest: URLRequest(url: url ?? emptyUrl), completion: completion)
    }
}
