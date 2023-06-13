//
//  MainViewCollectionViewCell.swift
//  WhiteAndFluffy
//
//  Created by Nikita on 11.06.23.
//

import UIKit
import SDWebImage

class MainViewCollectionViewCell: UICollectionViewCell {
    static let id = String(describing: MainViewCollectionViewCell.self)
    
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
          super.init(frame: frame)
        imageView = UIImageView(frame: self.bounds)
        imageView.image = UIImage(systemName: "person.fill")
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
      }

      required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
          imageView = UIImageView(frame: self.bounds)
          imageView.image = UIImage(systemName: "person.fill")
          addSubview(imageView)
      }

    
    
    func set(url: URL) {
        self.imageView.sd_setImage(with: url)
    }
    
    
}
