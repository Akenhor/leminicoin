//
//  NetworkRepository.swift
//  leminicoin
//
//  Created by Pierre Semler on 14/05/2021.
//

import Foundation

protocol NetworkDependency {
    var networkService: NetworkService { get }
    func loadAds(completion: @escaping (Result<[AdDto], Error>) -> Void)
    func loadCategories(completion: @escaping (Result<[CategoryDto], Error>) -> Void)
    func downloadAdImage(at url: URL?, completion: @escaping (Result<Data?, Error>) -> Void)
}

final class NetworkRepository: NetworkDependency {
    
    private var components: URLComponents
    fileprivate(set) lazy var networkService: NetworkService = NetworkService(with: components)
    fileprivate lazy var emptyUrl = { return URL(fileURLWithPath: "")}()
    
    init(components: URLComponents) {
        self.components = components
    }

    func loadAds(completion: @escaping (Result<[AdDto], Error>) -> Void) {
        self.components.path = "/leboncoin/paperclip/master/listing.json"
        networkService.request(urlRequest: URLRequest(url: components.url ?? emptyUrl), completion: completion)
    }
    
    func loadCategories(completion: @escaping (Result<[CategoryDto], Error>) -> Void) {
        self.components.path = "/leboncoin/paperclip/master/categories.json"
        networkService.request(urlRequest: URLRequest(url: components.url ?? emptyUrl), completion: completion)
    }
    
    func downloadAdImage(at url: URL?, completion: @escaping (Result<Data?, Error>) -> Void) {
        networkService.download(urlRequest: URLRequest(url: url ?? emptyUrl), completion: completion)
    }
}
