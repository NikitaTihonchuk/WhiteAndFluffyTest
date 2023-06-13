//
//  UnsplashAPI.swift
//  WhiteAndFluffy
//
//  Created by Nikita on 11.06.23.
//

import Foundation
import Moya

//MARK: - UnsplashAPI
enum UnsplashAPI {
    case getRandomImage
    case searchPhotos(query: String)
    case getPhoto(id: String)

}
//MARK: - extension UnsplashAPI
extension UnsplashAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.unsplash.com/") else {
            fatalError("Invalid base URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getRandomImage:
            return "/photos/random"
        case .searchPhotos:
            return "/search/photos/"
        case .getPhoto(let id):
            return "/photos/\(id)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Moya.Task {
        switch self {
        case .getRandomImage:
            let parameters:[String: Any] = [
                "client_id": "B0tXv1CMiRGPo5D5VJ-gIisl7fTerdzykx4nIzr9kRA",
                "count" : 30
            ]
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .searchPhotos(let query):
            let parameters:[String: Any] = [
                "client_id": "B0tXv1CMiRGPo5D5VJ-gIisl7fTerdzykx4nIzr9kRA",
                "query" : query
            ]
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getPhoto:
            let parameters:[String: Any] = [
                "client_id": "B0tXv1CMiRGPo5D5VJ-gIisl7fTerdzykx4nIzr9kRA"
            ]
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)

        }
    }
    
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
