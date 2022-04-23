//
//  NetworkManger.swift
//  InstaPhoto-BostaTask
//
//  Created by Abdallah on 4/21/22.
//

import Foundation
import Moya

protocol Networkable {
    var provider: MoyaProvider<APIService> { get }

    func getUser(completion: @escaping (Result<User, ResoneError>) -> ())
    func fetchUserAlbums(userId: String, completion: @escaping (Result<[Albums], ResoneError>) -> ())
    func fetchPhotos(albumId: String, completion: @escaping (Result<[Photos], ResoneError>) -> ())
}

class NetworkManager: Networkable {
    
    var provider = MoyaProvider<APIService>(plugins: [NetworkLoggerPlugin()])

    func getUser(completion: @escaping (Result<User, ResoneError>) -> ()) {
        request(target: .getUser, completion: completion)
    }
    
    func fetchUserAlbums( userId: String, completion: @escaping (Result<[Albums], ResoneError>) -> ()) {
        request(target: .getAlbums(userId: userId), completion: completion)
    }
    
    func fetchPhotos(albumId: String, completion: @escaping (Result<[Photos], ResoneError>) -> ()) {
        request(target: .getPhotos(albumId: albumId), completion: completion)
    }
}

private extension NetworkManager {
    private func request<T: Decodable>(target: APIService, completion: @escaping (Result<T, ResoneError>) -> ()) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch  {
                    completion(.failure(.invalidData))
                }
            case .failure(_):
                completion(.failure(.invalidData))
            }
        }
    }
}
