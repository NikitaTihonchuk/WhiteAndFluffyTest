//
//  PhotoModel.swift
//  WhiteAndFluffy
//
//  Created by Nikita on 13.06.23.
//

import Foundation
import UIKit

class PhotoModel {
  
    var image: String
    var location: String
    var authorName: String
    var downloadCount: String
    var dateAdded: String
    var description: String
    var id: String
    
    init(image: String, location: String, authorName: String, downloadCount: String, dateAdded: String, description: String, id: String) {
        self.image = image
        self.location = location
        self.authorName = authorName
        self.downloadCount = downloadCount
        self.dateAdded = dateAdded
        self.description = description
        self.id = id
    }
}
