//
//  APIService.swift
//  InstaPhoto-BostaTask
//
//  Created by Abdallah on 4/21/22.
//

import Foundation
import Moya

enum APIService {
    case getUser
    case getAlbums(userId: String)
    case getPhotos(albumId: String)
}

extension APIService: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Urls.baseURL) else { fatalError(ResoneError.invaldURL.rawValue) }
        return url
    }
    
    var path: String {
        switch self {
        case .getUser:
            return "/6"
        case .getAlbums(let userId):
            return "/\(userId)/albums"
        case .getPhotos(let albumId):
            return "/\(albumId)/photos"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
}
