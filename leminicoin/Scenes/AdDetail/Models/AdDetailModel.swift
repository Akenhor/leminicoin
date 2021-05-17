//
//  AdDetailModel.swift
//  leminicoin
//
//  Created by Pierre Semler on 16/05/2021.
//

import UIKit

struct AdDetailModel {
    public let categoryName: String
    public let title: String?
    public let description: String?
    public let thumbImageUrl: URL?
    public let price: String
    public let creationDate: String
    public let isUrgentImage: UIImage?
}
