//
//  Product.swift
//  avito-tech-task
//
//  Created by macbook on 26.08.2023.
//

import Foundation

// MARK: - Advertisements
struct Advertisements: Codable {
    let advertisements: [Advertisement]
}

// MARK: - Advertisement
struct Advertisement: Codable {
    let id, title, price, location : String
    let description, email, phoneNumber, address: String?
    let imageURL: String
    let createdDate: String

    enum CodingKeys: String, CodingKey {
        case id, title, price, location, description, email, address
        case imageURL = "image_url"
        case createdDate = "created_date"
        case phoneNumber = "phone_number"
    }
}

   
