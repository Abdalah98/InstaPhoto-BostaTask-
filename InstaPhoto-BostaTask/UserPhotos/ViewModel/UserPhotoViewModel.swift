//
//  UserPhotoViewModel.swift
//  InstaPhoto-BostaTask
//
//  Created by Abdallah on 4/21/22.
//

import Foundation
import RxCocoa
import RxSwift
class UserPhotoViewModel {
    
    var PickedAlbumId                 = BehaviorRelay<String>(value: "")
    private  var showAlertBehavior    = BehaviorRelay<String>(value: "")
    private  var loadingBehavior      = BehaviorRelay<Bool>(value: false)
    private  let searchValue          = BehaviorRelay<String>(value: "")
    private  var isCollectionHidden   = BehaviorRelay<Bool>(value: false)

    private  var userPhotoModelSubject = PublishSubject<[Photos]>()
    private  let networkManager        =  NetworkManager()
    
    let filterModelObservable: Observable<[Photos]>
    var searchValueObserver: AnyObserver<String?> { searchValueBehavior.asObserver() }
    private let searchValueBehavior = BehaviorSubject<String?>(value: "")
    var  userPhotoModelObservable: Observable<[Photos]> {return userPhotoModelSubject}
    var loadingObserver: Observable<Bool>{ return loadingBehavior.asObservable()}
    var showAlertObserver: Observable<String>{return showAlertBehavior.asObservable()}
    var showSearchValueObserver: Observable<String>{return searchValue.asObservable()}
    var isCollectionHiddenObservable: Observable<Bool> {return isCollectionHidden.asObservable()}
    
    //    init(networkManager: NetworkManager = NetworkManager()) {
    //        self.networkManager = networkManager
    //    }
    
    init() {
        filterModelObservable = Observable.combineLatest(
            searchValueBehavior
                .map { $0 ?? "" }
                .startWith("ds")
                .throttle(.milliseconds(500), scheduler: MainScheduler.instance),userPhotoModelSubject
        )
        .map { searchValue, photos in
            searchValue.isEmpty ? photos : photos.filter { $0.title.lowercased().contains(searchValue.lowercased()) }
        }
    }
    
    func fetchPhotos() {
        // to show Activity
        // fetch data and call api
        loadingBehavior.accept(true)
        networkManager.fetchPhotos(albumId: PickedAlbumId.value, completion: { [weak self] result in
            guard let self = self else { return }
            self.loadingBehavior.accept(false)
            switch result {
            case .success(let photos):
                if  photos.count  > 0 {
                    self.userPhotoModelSubject.onNext(photos)
                    self.isCollectionHidden.accept(false)
                }else{
                    self.isCollectionHidden.accept(true)
                }
            case .failure(let error):
                self.showAlertBehavior.accept(error.rawValue)
                self.isCollectionHidden.accept(true)
            }
        })
    }
    func updateUserInterface() {
        switch Network.reachability.status {
        case .unreachable:
            fetchPhotos()
        case .wwan:
            fetchPhotos()
        case .wifi:
            fetchPhotos()
        }
    }
}

