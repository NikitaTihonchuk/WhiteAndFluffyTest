//
//  RealmPhotoModel.swift
//  WhiteAndFluffy
//
//  Created by Nikita on 12.06.23.
//

import Foundation
import RealmSwift

class RealmPhotoModel: Object {
    @objc dynamic var photo: String = ""
    @objc dynamic var author: String = ""
    @objc dynamic var decription: String = ""
    @objc dynamic var created_at: String = ""
    @objc dynamic var downloads: Int = 0
    @objc dynamic var location: String = ""
    @objc dynamic var id: String = ""
    
    convenience init(photo: String, author: String, decription: String, id: String, created_at: String, downloads: Int, location: String) {
        self.init()
        
        self.photo = photo
        self.author = author
        self.decription = decription
        self.id = id
        self.location = location
        self.downloads = downloads
        self.created_at = created_at
    }
    
}
