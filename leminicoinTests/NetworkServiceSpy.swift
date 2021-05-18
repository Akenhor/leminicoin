//
//  NetworkServiceSpy.swift
//  leminicoinTests
//
//  Created by Pierre Semler on 18/05/2021.
//

import Foundation
import UIKit
@testable import leminicoin

class NetworkServiceSpy: NetworkService {
    
    let mockCatsData = "[{\"id\":3, \"name\":\"Sport\"},{\"id\":4, \"name\":\"Art\"}]".data(using: .utf8)!
    let mockAdsData = "[{\"id\":1,\"category_id\":4,\"title\":\"Reproduction d'un Picasso\",\"description\":\"Un superbe tableau peint par Picasso\",\"price\":2300000,\"images_url\":{},\"creation_date\":\"2018-04-20T23:40:58+0000\",\"is_urgent\":false},{\"id\":2,\"category_id\":3,\"title\":\"Chaussures Nike\",\"description\":\"Une paire détenue par Usain Bolt selon la légende\",\"price\":4300,\"images_url\":{},\"creation_date\":\"2018-04-20T23:40:58+0000\",\"is_urgent\":true},{\"id\":3,\"category_id\":3,\"images_url\":{},\"is_urgent\":true},{\"id\":4,\"category_id\":3,\"title\":\"Maillot du PSG\",\"description\":\"Un maillot de Neymar au couleur du PSG. Prix imbattable\",\"price\":600,\"images_url\":{},\"creation_date\":\"2021-02-01T08:02:30+0000\",\"is_urgent\":false},{\"id\":5,\"category_id\":4,\"creation_date\":\"2019-08-29T15:30:10+0000\"},{\"id\":6,\"category_id\":4,\"title\":\"Cours de sculpture sur bois\",\"description\":\"Professeur depuis 20 ans, je donne des cours aux débutants.\",\"price\":40,\"images_url\":{},\"creation_date\":\"2019-08-29T15:30:10+0000\",\"is_urgent\":true},{\"id\":7,\"category_id\":2,\"images_url\":{}}]".data(using: .utf8)!
    
    override func request<T>(urlRequest: URLRequest, completion: @escaping (Result<[T], NetworkError>) -> Void) where T : Decodable {
        
        var data: Data = Data()
        
        guard urlRequest.url?.path != "/genericError" else {
            completion(.failure(NetworkError.noData))
            return
        }
        
        if urlRequest.url?.path == "/loadCat" {
            data = mockCatsData
        } else if urlRequest.url?.path == "/loadAds" {
            data = mockAdsData
        }
        
        do {
            completion(.success(try JSONDecoder().decode([T].self, from: data)))
        } catch let error {
            completion(.failure(NetworkError.mappingError(error)))
        }
    }
    
    override func download(urlRequest: URLRequest, completion: @escaping (Result<Data?, NetworkError>) -> Void) {
        if urlRequest.url?.path == "/downloadImage" {
            completion(.success(UIImage(named: "ImagePlaceholder")?.pngData()))
        } else {
            completion(.failure(NetworkError.badLocalUrl))
        }
    }
}
