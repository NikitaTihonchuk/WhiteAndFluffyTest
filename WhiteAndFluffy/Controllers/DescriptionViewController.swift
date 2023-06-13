//
//  DescriptionViewController.swift
//  WhiteAndFluffy
//
//  Created by Nikita on 11.06.23.
//

import UIKit

class DescriptionViewController: UIViewController {
    
    //MARK: - UIComponents
    var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    var photoDescriptionImage: UIImageView = {
        let photo = UIImageView()
        photo.contentMode = .scaleAspectFit
        photo.image = UIImage(systemName: "person.fill")
        return photo
    }()
    
    var locationPhotoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Location"
        return label
    }()
    
    var authorNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Author"
        return label
    }()
    
    
    var downloadCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Download"
        return label
    }()
    
    var createDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Date"
        return label
    }()
    
    var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
        button.backgroundColor = .green
        button.setTitle("Like", for: .normal)
        return button
    }()
    
    var photoModel: PhotoModel?
    var isThisPhotoInFavourite: Bool = false
    
    //MARK: - inits

    
    init(model: PhotoModel) {
          super.init(nibName: nil, bundle: nil)
            self.photoModel = model
    }
      
    required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
          
    }
    
    private func configureUI() {
        guard let model = photoModel else { return }
        
        if let url = URL(string: model.image) {
            self.photoDescriptionImage.sd_setImage(with: url)
        }
        
        locationPhotoLabel.text = "Location: \(model.location)"
        authorNameLabel.text = "Author: \(model.authorName)"
        downloadCountLabel.text = "Downloads: \(model.downloadCount)"
        createDateLabel.text = "Create date: \(model.dateAdded)"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        photoDescriptionImage.translatesAutoresizingMaskIntoConstraints = false
        locationPhotoLabel.translatesAutoresizingMaskIntoConstraints = false
        authorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        downloadCountLabel.translatesAutoresizingMaskIntoConstraints = false
        createDateLabel.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        if isThisPhotoInFavourite {
            likeButton.backgroundColor = .red
            likeButton.setTitle("Dislike", for: .normal)
        }
        
        configureUI()
        setupUI()
        makeConstraints()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let favourites = RealmManager<RealmPhotoModel>().read()
        guard let model = photoModel else { return }
        for favourite in favourites {
            if model.id == favourite.id {
                self.isThisPhotoInFavourite = true
                
            }
        }
        
        
        if isThisPhotoInFavourite {
            likeButton.backgroundColor = .red
            likeButton.setTitle("Dislike", for: .normal)
        } else {
            likeButton.backgroundColor = .green
            likeButton.setTitle("Like", for: .normal)
        }
    }
    
    //MARK: - Objc methods

    @objc private func likeAction() {
        isThisPhotoInFavourite = !isThisPhotoInFavourite
        
        guard let photoModel = photoModel else { return }
        
        if isThisPhotoInFavourite {
            let photo = RealmPhotoModel(photo: photoModel.image, author: photoModel.authorName, decription: photoModel.description, id: photoModel.id, created_at: photoModel.dateAdded, downloads: Int(photoModel.downloadCount)!, location: photoModel.location)
           
            RealmManager<RealmPhotoModel>().write(object: photo)
            likeButton.backgroundColor = .red
            likeButton.setTitle("Dislike", for: .normal)
        } else {
            let photo = RealmPhotoModel(photo: photoModel.image, author: photoModel.authorName, decription: photoModel.description, id: photoModel.id, created_at: photoModel.dateAdded, downloads: Int(photoModel.downloadCount)!, location: photoModel.location)
            
            var favPhoto = RealmManager<RealmPhotoModel>().read()
            var myPhoto = favPhoto.first(where: {$0.id == photo.id})
            if let photo = myPhoto {
                RealmManager<RealmPhotoModel>().delete(object: photo)
            }
            likeButton.backgroundColor = .green
            likeButton.setTitle("Like", for: .normal)
        }
        
    }
    
    //MARK: - setup UI

    private func setupUI() {
        self.view.addSubview(photoDescriptionImage)
        self.view.addSubview(likeButton)
        self.view.addSubview(mainStack)
        
        mainStack.addArrangedSubview(locationPhotoLabel)
        mainStack.addArrangedSubview(authorNameLabel)
        mainStack.addArrangedSubview(downloadCountLabel)
        mainStack.addArrangedSubview(createDateLabel)
    }
    
    //MARK: - Make Constraints

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            photoDescriptionImage.heightAnchor.constraint(equalToConstant: 200),
            photoDescriptionImage.widthAnchor.constraint(equalToConstant: 200),
            photoDescriptionImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            photoDescriptionImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            
            mainStack.centerYAnchor.constraint(equalTo: photoDescriptionImage.centerYAnchor),
            mainStack.leadingAnchor.constraint(equalTo: photoDescriptionImage.trailingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),

            
            likeButton.topAnchor.constraint(equalTo: photoDescriptionImage.bottomAnchor, constant: 15),
            likeButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            likeButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            likeButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    
    
    
    


}
