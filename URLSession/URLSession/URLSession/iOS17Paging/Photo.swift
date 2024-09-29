//
//  Photo.swift
//  URLSession
//
//  Created by 김동경 on 9/30/24.
//

import Foundation

struct Photo: Identifiable, Codable, Hashable {
    var id: String
    var author: String
    var url: URL
    var downloadURLString: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case url
        case downloadURLString = "download_url"
    }
    
    var downloadloadURL: URL? {
        URL(string: downloadURLString)
    }
    
    var imageURL: URL? {
        URL(string: "https://picsum.photos/id/\(id)/256/256.jpg")
    }
}

