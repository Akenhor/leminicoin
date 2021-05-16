//
//  AdDetailInteractor.swift
//  leminicoin
//
//  Created by Pierre Semler on 16/05/2021.
//

import Foundation

final class AdDetailInteractor {
    var output: AdDetailPresenterProtocol!
    private var ad: AdDto?
    private var category: String?
    
    private func downloadThumbImage(for url: URL?) {
        guard let url = url else {
            output.present(thumbImageData: nil)
            return
        }
        AppDependencies.shared.networkRepository.downloadAdImage(at: url) { [weak self] (result: (Result<Data?, Error>)) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.output.present(thumbImageData: data)
                case .failure:
                    self?.output.present(thumbImageData: nil)
                }
            }
        }
    }
}

extension AdDetailInteractor: AdDetailInteractorProtocol {
    
    func prepare(ad: AdDto, withCategory: String) {
        self.ad = ad
        self.category = withCategory
    }
    
    func loadDetail() {
        guard let ad = self.ad else {
            return
        }
        output.present(ad: ad, withCategory: self.category)
        downloadThumbImage(for: URL(string: ad.images_url?.thumb ?? ""))
    }
}
