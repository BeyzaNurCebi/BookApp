//
//  Book.swift
//  BookApp
//
//  Created by Beyza Nur Çebi on 25.04.2020.
//  Copyright © 2020 Beyza Nur Çebi. All rights reserved.
//

import UIKit
struct Book: Codable {
    let items: [Item]
}

struct Item: Codable{
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable{
    let title: String
    let authors: [String]
    let descriptions: String?
    let averageRating: Double?
    let imageLinks: ImageLinks
    
    enum CodingKeys: String,CodingKey {
        case title
        case authors
        case descriptions = "description"
        case averageRating
        case imageLinks
    }
   
}

struct ImageLinks: Codable {
    let thumbnail: String
}
