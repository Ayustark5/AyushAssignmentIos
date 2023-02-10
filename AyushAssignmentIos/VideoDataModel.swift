//
//  VideoDataModel.swift
//  Ayush Assignment
//
//  Created by Ayush Raj on 09/02/23.
//

import Foundation

struct VideoDataModel: Codable{
    let page: Int
    let per_page: Int
    let videos: [Video]
    let total_results: Int
    let next_page: String?
    let url: String
}

struct Video: Codable{
    let id: Int
    let width: Int
    let height: Int
    let duration: Int
    let image: String
    let user: User
    let video_files: [VideoFiles]
}

struct User: Codable{
    let id: Int
    let name: String
    let url: String
}

struct VideoFiles: Codable{
    let id: Int
    let file_type: String
    let width: Int
    let height: Int
    let fps: Double?
    let link: String
}
