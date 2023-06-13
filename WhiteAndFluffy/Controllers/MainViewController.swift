//
//  MainViewController.swift
//  WhiteAndFluffy
//
//  Created by Nikita on 11.06.23.
//

import UIKit
import SDWebImage
import JGProgressHUD

class MainViewController: UIViewController {
    
    private let photoManager: PhotoManager
    private var searchBar: UISearchBar!
    private var collectionView: UICollectionView!
    private var randomPhotos = [RandomPhotoModel]()
    private var searchPhotos = [RandomPhotoModel]()
    private let spinner = JGProgressHUD(style: .dark)

    
    //MARK: - init
    init(photoManager: PhotoManager) {
        self.photoManager = photoManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        let moyaGetter = UnsplashAPIProvider()
        let photoManager = PhotoManager(moyaGetter: moyaGetter)
        self.photoManager = photoManager
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        prepareSearchBar()
        prepareCollectionView()
        getData()
    }
    
    //MARK: - GetDataFromNetwork
    private func getData(){
        photoManager.getRandomPhoto { [weak self] result in
            switch result {
            case .success(let photos):
                self?.randomPhotos = photos
                self?.collectionView.reloadData()
            case .failure(let failure):
                print(failure.localizedDescription)
                self?.showErrorAlert(with: failure.localizedDescription)
            }
        }
    }
    
    private func makeSearch(searchText: String) {
        photoManager.getSearchedPhoto(query: searchText) { [weak self] result in
            switch result {
            case .success(let success):
                let photo = success.results.first
                self?.photoManager.getPhotoByID(id: photo!.id, completion: { [weak self] result in
                    switch result {
                    case .success(let success):
                        self?.searchPhotos.append(success)
                    case .failure(let failure):
                        print(failure.localizedDescription)
                    }
                    self?.collectionView.reloadData()
                })
                
                self?.collectionView.reloadData()
            case .failure(let failure):
                print(failure.localizedDescription)
                self?.showErrorAlert(with: failure.localizedDescription)
            }
        }
    }
    //MARK: - Alert
    private func showErrorAlert(with error: String){
        let title = "Error"
        let message = error
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alertController, animated: false)
    }
    
    //MARK: - Prepare UI
    
    private func prepareSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Поиск..."
        navigationItem.titleView = searchBar
    }
    
    
    private func prepareCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        //collectionView.backgroundColor = .cyan
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MainViewCollectionViewCell.self, forCellWithReuseIdentifier: MainViewCollectionViewCell.id)
        
        collectionView.dataSource = self
        collectionView.delegate = self

        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
                  collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                  collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                  collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                  collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
   
}

//MARK: - UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    //Поиск по тексту
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        spinner.show(in: view)

        searchPhotos.removeAll()
        if searchBar.text != nil {
            if searchBar.text != " " {
                makeSearch(searchText: searchBar.text!)
            } else {
                searchPhotos.removeAll()
                collectionView.reloadData()
            }
            collectionView.reloadData()
            searchBar.resignFirstResponder() // Скрытие клавиатуры
        } else {
            searchPhotos.removeAll()
            collectionView.reloadData()
        }
        DispatchQueue.main.async {
            self.spinner.dismiss()
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchPhotos.removeAll()
            collectionView.reloadData()
        }
    }
  
    
    
}

//MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchPhotos.count == 0 {
            return randomPhotos.count
        } else {
            return searchPhotos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainViewCollectionViewCell.id, for: indexPath)
        guard let imageCell = cell as? MainViewCollectionViewCell else { return cell }
        if searchPhotos.count == 0 {
                if let url = URL(string: randomPhotos[indexPath.row].urls.small) {
                    imageCell.set(url: url)
                }
        } else {
                if let url = URL(string: searchPhotos[indexPath.row].urls.small) {
                    imageCell.set(url: url)
                }
        }
        
        return imageCell
        
    }
    
    
}

//MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if searchPhotos.count == 0 {
            let photoInfo = randomPhotos[indexPath.row]
            let decriptionVC = DescriptionViewController(model: PhotoModel(image: randomPhotos[indexPath.row].urls.regular, location: photoInfo.user?.location ?? "", authorName: photoInfo.user?.name ?? "", downloadCount: String(photoInfo.downloads), dateAdded: photoInfo.created_at, description: photoInfo.description ?? "", id: photoInfo.id))
            navigationController?.pushViewController(decriptionVC, animated: true)
        } else {
            let photoInfo = searchPhotos[indexPath.row]
            let decriptionVC = DescriptionViewController(model: PhotoModel(image: searchPhotos[indexPath.row].urls.regular, location: photoInfo.user?.location ?? "", authorName: photoInfo.user?.name ?? "", downloadCount: String(photoInfo.downloads), dateAdded: photoInfo.created_at, description: photoInfo.description ?? "", id: photoInfo.id))
            navigationController?.pushViewController(decriptionVC, animated: true)
        }
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: 80, height: 80)
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        return CGSize(width: collectionView.bounds.width / 2.0 , height: collectionView.bounds.height / 4.0)
    }
}
