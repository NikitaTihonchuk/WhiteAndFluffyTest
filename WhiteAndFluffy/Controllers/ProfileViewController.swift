//
//  ProfileViewController.swift
//  WhiteAndFluffy
//
//  Created by Nikita on 11.06.23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private var tableView: UITableView!
    
    var favouritePhotos = [RealmPhotoModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    

    override func viewDidLoad() {
        self.title = "Favourites"
        super.viewDidLoad()
        self.view.backgroundColor = .white
        prepareTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favouritePhotos = RealmManager<RealmPhotoModel>().read()
    }
    
    //MARK: - Prepare UI
    
    private func prepareTableView() {
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ProfileViewTableViewCell.self, forCellReuseIdentifier: ProfileViewTableViewCell.id)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    

    

}
//MARK: - Extension UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouritePhotos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let photo = favouritePhotos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileViewTableViewCell.id, for: indexPath)
        guard let favouriteImageCell = cell as? ProfileViewTableViewCell else { return cell }
        if let url = URL(string: photo.photo) {
            favouriteImageCell.set(url: url, author: photo.author)
        }
        return favouriteImageCell
    }
    
    
}

//MARK: - Extension UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photoInfo = favouritePhotos[indexPath.row]
        let decriptionVC = DescriptionViewController(model: PhotoModel(image: photoInfo.photo, location: photoInfo.location, authorName: photoInfo.author, downloadCount: String(photoInfo.downloads), dateAdded: photoInfo.created_at, description: photoInfo.description, id: photoInfo.id))
 
        navigationController?.pushViewController(decriptionVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let photo = favouritePhotos[indexPath.row]
            RealmManager<RealmPhotoModel>().delete(object: photo)
            favouritePhotos = RealmManager<RealmPhotoModel>().read()

            tableView.reloadData()
        
    }
}
