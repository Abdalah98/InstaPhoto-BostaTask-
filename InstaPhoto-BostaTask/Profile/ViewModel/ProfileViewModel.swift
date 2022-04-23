//
//  ProfileViewModel.swift
//  InstaPhoto-BostaTask
//
//  Created by Abdallah on 4/20/22.
//

import Foundation
import RxCocoa
import RxSwift
class ProfileViewModel {
    
    var nameUserBehavior              = BehaviorRelay<String>(value: "")
    var addressUserBehavior           = BehaviorRelay<String>(value: "")
    private  var showAlertBehavior    = BehaviorRelay<String>(value: "")
    private  var loadingBehavior      = BehaviorRelay<Bool>(value: false)
    private  var isTableHidden        = BehaviorRelay<Bool>(value: false)

    private  var albumModelSubject     = PublishSubject<[Albums]>()
    private  var userModleSubject      = PublishSubject<User>()

    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    var albumModelObservable: Observable<[Albums]> {return albumModelSubject}
    var userModelObservable: Observable<User> {return userModleSubject}
    var loadingObserver: Observable<Bool>{return loadingBehavior.asObservable()}
    var showAlertObserver: Observable<String>{return showAlertBehavior.asObservable()}
    var isTableHiddenObservable: Observable<Bool> {return isTableHidden.asObservable()}
    
    func fetchUserData(){
        // to show Activity
        // fetch data and call api
        loadingBehavior.accept(true)
        networkManager.getUser( completion: { [weak self] result in
            guard let self = self else { return }
            self.loadingBehavior.accept(false)
            switch result {
            case .success(let user):
                self.nameUserBehavior.accept(user.name)
                let address = user.address.street + user.address.city + user.address.zipcode
                self.addressUserBehavior.accept(address)
                self.fetchUserAlbums(userId: String(user.id))
            case .failure(let error):
                self.showAlertBehavior.accept(error.rawValue)
                self.isTableHidden.accept(true)
            }
        })
    }
    
    func fetchUserAlbums(userId: String) {
        // to show Activity
        // fetch data and call api
        loadingBehavior.accept(true)
        networkManager.fetchUserAlbums(userId: userId, completion: { [weak self] result in
            guard let self = self else { return }
            self.loadingBehavior.accept(false)
            switch result {
            case .success(let albums):
                if  albums.count > 0 {
                    self.albumModelSubject.onNext(albums)
                    self.isTableHidden.accept(false)
                }else{
                    self.isTableHidden.accept(true)
                }
            case .failure(let error):
                self.showAlertBehavior.accept(error.rawValue)
                self.isTableHidden.accept(true)

            }
        })
    }
    // check Network connection
    // check network connection and get data
    // case unreachable that mean no internet connection
    // case wwan that mean via a cellular connection
    // case wwan that mean via a wifi connection
        func updateUserInterface() {
            switch Network.reachability.status {
            case .unreachable:
               fetchUserData()
            case .wwan:
                fetchUserData()
            case .wifi:
                fetchUserData()
            }
        }
}
