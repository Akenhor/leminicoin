//
//  NetworkService.swift
//  leminicoin
//
//  Created by Pierre Semler on 14/05/2021.
//

import Foundation

enum NetworkError: Error {
    case badResponse(URLResponse?)
    case noData
    case badLocalUrl
    case mappingError(Error)
}

final class NetworkService {
    
    private let session = URLSession(configuration: .default)
    private let queue = DispatchQueue(label: "NetworkService", qos: .userInitiated, attributes: .concurrent)
    private let components: URLComponents
    
    init(with components: URLComponents) {
        self.components = components
    }
    
    func request<T: Decodable>(urlRequest: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        queue.async { [weak self] in
            let task = self?.session.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NetworkError.badResponse(response)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    completion(.success(try decoder.decode(T.self, from: data)))
                } catch let error {
                    completion(.failure(NetworkError.mappingError(error)))
                }
            }
            task?.resume()
        }
    }
    
    func request<T: Decodable>(urlRequest: URLRequest, completion: @escaping (Result<[T], Error>) -> Void) {
        queue.async { [weak self] in
            let task = self?.session.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NetworkError.badResponse(response)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    completion(.success(try decoder.decode([T].self, from: data)))
                } catch let error {
                    completion(.failure(NetworkError.mappingError(error)))
                }
            }
            task?.resume()
        }
    }
    
    func download(urlRequest: URLRequest, completion: @escaping (Result<Data?, Error>) -> Void) {
        queue.async { [weak self] in
            
            let task = self?.session.downloadTask(with: urlRequest) { (tmpUrl, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NetworkError.badResponse(response)))
                    return
                }
                
                guard let tmpUrl = tmpUrl else {
                    completion(.failure(NetworkError.badLocalUrl))
                    return
                }
                
                do {
                    completion(.success(try Data(contentsOf: tmpUrl)))
                } catch let error {
                    completion(.failure(NetworkError.mappingError(error)))
                }
            }
            task?.resume()
        }
    }
    
}
