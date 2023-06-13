//
//  RandomPhotoModel.swift
//  WhiteAndFluffy
//
//  Created by Nikita on 11.06.23.
//

import Foundation

struct RandomPhotoModel: Decodable {
    let id: String
    let likes: Int
    let description: String?
    let user: User?
    let downloads: Int
    let created_at: String
    let urls: URLS
    
    struct URLS: Decodable {
            let small: String
            let regular: String
    }
    
    struct User: Decodable {
        let name: String
        let location: String?

    }
    
}


