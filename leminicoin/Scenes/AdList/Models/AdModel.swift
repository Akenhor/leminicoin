//
//  AdModel.swift
//  leminicoin
//
//  Created by Pierre Semler on 15/05/2021.
//

import Foundation

struct AdModel {
    public let id: Int64
    public let category: CategoryModel
    public let title: String?
    public let description: String?
    public let smallImageUrl: URL?
    public let thumbImageUrl: URL?
    public let price: String
    public let creationDate: String
    public let isUrgent: Bool
}
