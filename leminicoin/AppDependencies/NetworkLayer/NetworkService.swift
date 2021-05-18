//
//  NetworkService.swift
//  leminicoin
//
//  Created by Pierre Semler on 14/05/2021.
//

import Foundation

enum NetworkError: Error {
    case dataTaskError(Error)
    case badResponse(URLResponse?)
    case noData
    case badLocalUrl
    case mappingError(Error)
}

class NetworkService {
    
    let session = URLSession(configuration: .default)
    let queue = DispatchQueue(label: "NetworkService", qos: .userInitiated, attributes: .concurrent)
    private let components: URLComponents
    private let cache = NSCache<NSString, NSData>()
    
    init(with components: URLComponents) {
        self.components = components
    }
    
    func request<T: Decodable>(urlRequest: URLRequest, completion: @escaping (Result<[T], NetworkError>) -> Void) {
        queue.async { [weak self] in
            let task = self?.session.dataTask(with: urlRequest) { (data, response, error) in
                
                if let error = error {
                    completion(.failure(NetworkError.dataTaskError(error)))
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
    
    func download(urlRequest: URLRequest, completion: @escaping (Result<Data?, NetworkError>) -> Void) {
        queue.async { [weak self] in
            if let url = urlRequest.url, let image = self?.cache.object(forKey: url.absoluteString as NSString) {
                completion(.success(image as Data))
            }
            
            let task = self?.session.downloadTask(with: urlRequest) { (localUrl, response, error) in
                if let error = error {
                    completion(.failure(NetworkError.dataTaskError(error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NetworkError.badResponse(response)))
                    return
                }
                
                guard let localUrl = localUrl else {
                    completion(.failure(NetworkError.badLocalUrl))
                    return
                }
                
                do {
                    let data = try Data(contentsOf: localUrl)
                    if let url = urlRequest.url {
                        self?.cache.setObject(data as NSData, forKey: url.absoluteString as NSString)
                    }
                    completion(.success(data))
                } catch let error {
                    completion(.failure(NetworkError.mappingError(error)))
                }
            }
            task?.resume()
        }
    }
    
}
