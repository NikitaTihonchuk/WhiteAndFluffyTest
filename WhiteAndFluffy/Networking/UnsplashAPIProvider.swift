//
//  UnsplashAPIProvider.swift
//  WhiteAndFluffy
//
//  Created by Nikita on 11.06.23.
//

import Foundation
import Moya

//MARK: - Protocols
protocol PhotoGetter {
    func getRandomPhoto(completion: @escaping ( Result<[RandomPhotoModel], UnsplashAPIProvider.Error>) -> Void)
    func getSearchedPhoto(query: String, completion: @escaping (Result<SearchPhotoModel, UnsplashAPIProvider.Error>) -> Void)
    func getPhotoByID(id: String, completion: @escaping ( Result<RandomPhotoModel, UnsplashAPIProvider.Error>) -> Void)
}
//MARK: - PhotoManager
final class PhotoManager: PhotoGetter {
    let moyaGetter: PhotoGetter
    
    init(moyaGetter: PhotoGetter) {
        self.moyaGetter = moyaGetter
    }
    
    func getRandomPhoto(completion: @escaping (Result<[RandomPhotoModel], UnsplashAPIProvider.Error>) -> Void) {
        moyaGetter.getRandomPhoto(completion: completion)
    }
    
    func getSearchedPhoto(query: String, completion: @escaping (Result<SearchPhotoModel, UnsplashAPIProvider.Error>) -> Void) {
        moyaGetter.getSearchedPhoto(query: query, completion: completion)
    }
    
    func getPhotoByID(id: String, completion: @escaping (Result<RandomPhotoModel, UnsplashAPIProvider.Error>) -> Void) {
        moyaGetter.getPhotoByID(id: id, completion: completion)
    }
}
//MARK: - UnsplashAPIProvider

final class UnsplashAPIProvider: PhotoGetter {
    
    
    enum Error: LocalizedError {
        case invalidParse
        case noInternetConnection
        case timeOut
        case unknownError
        case serverNotAvalable
        
        var errorDescription: String? {
            switch self {
                case .invalidParse:
                    return "Cant parse repositories"
                case .noInternetConnection:
                    return "Check your Internet connetcion"
                case .timeOut:
                    return "Request limit exceeded"
                case .unknownError:
                    return "Something went wrong"
                case .serverNotAvalable:
                    return "Server not avalable"
            }
        }
    }
    
    private func createCustomError(error: MoyaError) -> UnsplashAPIProvider.Error {
        switch error.errorCode {
            case 500...510:
                return .serverNotAvalable
            case 401:
                return .noInternetConnection
            case 403:
                return .timeOut
            default:
                return .unknownError
        }
    }
    
    
    private let provider = MoyaProvider<UnsplashAPI>(plugins: [NetworkLoggerPlugin()])
    
    func getRandomPhoto(completion: @escaping (Result<[RandomPhotoModel], UnsplashAPIProvider.Error>) -> Void) {
        provider.request(.getRandomImage) { result in
            switch result {
            case .success(let responce):
                do {
                    let result = try JSONDecoder().decode([RandomPhotoModel].self, from: responce.data)
                    completion(.success(result))
                } catch {
                    completion(.failure(.invalidParse))
                }
            case .failure(let error):
                let customError = self.createCustomError(error: error)
                completion(.failure(customError))
            }
        }
    }
    
    
    func getSearchedPhoto(query: String, completion: @escaping (Result<SearchPhotoModel, Error>) -> Void) {
        provider.request(.searchPhotos(query: query)) { result in
            switch result {
            case .success(let responce):
                do {
                    let result = try JSONDecoder().decode(SearchPhotoModel.self, from: responce.data)
                    completion(.success(result))
                } catch {
                    completion(.failure(.invalidParse))
                }
            case .failure(let error):
                let customError = self.createCustomError(error: error)
                completion(.failure(customError))
            }
        }
    }
    
    func getPhotoByID(id: String, completion: @escaping (Result<RandomPhotoModel, Error>) -> Void) {
        provider.request(.getPhoto(id: id)) { result in
            switch result {
            case .success(let responce):
                do {
                    let result = try JSONDecoder().decode(RandomPhotoModel.self, from: responce.data)
                    completion(.success(result))
                } catch {
                    completion(.failure(.invalidParse))
                }
            case .failure(let error):
                let customError = self.createCustomError(error: error)
                completion(.failure(customError))
            }
        }
    }

}

