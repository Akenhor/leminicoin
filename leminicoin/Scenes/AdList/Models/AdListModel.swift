//
//  AdListModel.swift
//  leminicoin
//
//  Created by Pierre Semler on 15/05/2021.
//

import UIKit

struct AdListModel {
    public let id: Int64
    public let category: CategoryModel
    public let title: String?
    public let smallImageUrl: URL?
    public let price: String
    public let isUrgentImage: UIImage?
}
