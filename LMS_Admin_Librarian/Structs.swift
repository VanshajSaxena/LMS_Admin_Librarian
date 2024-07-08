//
//  Structs.swift
//  LMSAdmin
//
//  Created by Hitesh Rupani on 04/07/24.
//

import Foundation

struct Books: Decodable {
    let items: [BookItem]
}

struct BookItem: Decodable {
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Decodable {
    let title: String
    let subtitle: String?
    let authors: [String]
    let publishedDate: String
    let pageCount: Int
    let language: String
    let imageLinks: ImageLinks
}

struct ImageLinks: Decodable {
    let smallThumbnail: String
    let thumbnail: String
}
