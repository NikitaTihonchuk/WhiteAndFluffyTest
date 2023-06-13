//
//  ProfileViewTableViewCell.swift
//  WhiteAndFluffy
//
//  Created by Nikita on 12.06.23.
//

import UIKit
import SDWebImage

class ProfileViewTableViewCell: UITableViewCell {
    static let id = String(describing: ProfileViewTableViewCell.self)

       var authorLabel: UILabel!
       var favouriteImageView: UIImageView!
       
       override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           
           authorLabel = UILabel(frame: CGRect.zero)
           authorLabel.text = "Author"
           authorLabel.font = .boldSystemFont(ofSize: 16)
           authorLabel.textColor = .black
           authorLabel.translatesAutoresizingMaskIntoConstraints = false

           
           favouriteImageView = UIImageView(frame: CGRect.zero)
           favouriteImageView.image = UIImage(systemName: "person.fill")
           favouriteImageView.translatesAutoresizingMaskIntoConstraints = false
           
           
           contentView.addSubview(favouriteImageView)
           contentView.addSubview(authorLabel)
           
           
           NSLayoutConstraint.activate([
            favouriteImageView.heightAnchor.constraint(equalToConstant: 100),
            favouriteImageView.widthAnchor.constraint(equalToConstant:100),
            favouriteImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            favouriteImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            favouriteImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),

            
            contentView.heightAnchor.constraint(equalTo: favouriteImageView.heightAnchor, multiplier: 1),
            
            
            authorLabel.leftAnchor.constraint(equalTo: favouriteImageView.rightAnchor, constant: 50),
            authorLabel.centerYAnchor.constraint(equalTo: favouriteImageView.centerYAnchor)
           ])
           
        
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
       }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.favouriteImageView.image = UIImage(systemName: "person.fill")
    }
    
    
    func set(url: URL, author: String) {
        self.authorLabel.text = author
        self.favouriteImageView.sd_setImage(with: url)
    }
    
}
