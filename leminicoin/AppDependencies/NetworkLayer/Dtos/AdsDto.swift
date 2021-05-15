//
//  AdsDto.swift
//  leminicoin
//
//  Created by Pierre Semler on 14/05/2021.
//

struct AdDto: Decodable {
    public let id: Int64?
    public let category_id: Int?
    public let title: String?
    public let description: String?
    public let price: Float?
    public let images_url: AdImageDto?
    public let creation_date: String?
    public let is_urgent: Bool?
}
