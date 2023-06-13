//
//  SearchPhotoModel.swift
//  WhiteAndFluffy
//
//  Created by Nikita on 13.06.23.
//

import Foundation

struct SearchPhotoModel: Decodable {
    let results: [SearchPhotos]
}


struct SearchPhotos: Decodable {
    let id: String
    let description: String?
    let urls: URLS
    
    struct URLS: Decodable {
        let small: String
        let regular: String
    }
}
