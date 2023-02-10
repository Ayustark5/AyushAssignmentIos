//
//  PhotoDataModel.swift
//  Ayush Assignment
//
//  Created by Ayush Raj on 09/02/23.
//

import Foundation


struct PhotoDataModel: Codable
{
    let page: Int?
    let per_page: Int?
    let total_results: Int?
    let photos: [Photo]?
    let next_page: String?
}

struct Photo: Codable {
    let id: Int?
    let photographer: String?
    let alt: String?
    let src: ImageSource?
}

struct ImageSource: Codable {
    let original: String?
    let tiny: String?
}
