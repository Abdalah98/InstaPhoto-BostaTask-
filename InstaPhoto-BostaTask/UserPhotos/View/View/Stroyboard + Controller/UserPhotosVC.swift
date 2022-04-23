//
//  UserPhotosVC.swift
//  InstaPhoto-BostaTask
//
//  Created by Abdallah on 4/19/22.
//

import UIKit
import RxSwift
import RxCocoa
class UserPhotosVC: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var userPhotoCollectionView: UICollectionView!
    @IBOutlet weak var photosView: UIView!
    
    let searchController = UISearchController()
    let disposeBag = DisposeBag()
    let userPhotoViewModel = UserPhotoViewModel()
    var albumTitle: String?
    var userId =  String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = albumTitle
        userPhotoViewModel.PickedAlbumId.accept(userId)
        setupCollectionView()
        subscribeToLoading()
        subscribeToShowAlert()
        subscribeToResponseAlbum()
        subscribeToPhotoSelection()
        configureSearch()
        //searchBar
        bindToSearchValue()
        NotificationCenter.default.addObserver(self,selector: #selector(statusManager),name: .flagsChanged,object: nil)
        userPhotoViewModel.updateUserInterface()
    }

    // Update User Interface if has connection or not has connection networking
    // - Parameter notification: notification center
    @objc func statusManager(_ notification: Notification) {
        userPhotoViewModel.updateUserInterface()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindToHiddenCollectionView()
        getAlbum()
    }
    
    // add search in  navigationItem
    fileprivate func configureSearch() {
        searchController.searchBar.placeholder = "Search Here"
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
    }
    func bindToSearchValue() {
        searchController.searchBar.rx.text
            .distinctUntilChanged()
            .bind(to:userPhotoViewModel.searchValueObserver)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { () in
            })
            .disposed(by: self.disposeBag)

        searchController.searchBar.rx.textDidEndEditing
            .subscribe(onNext: { () in
            })
            .disposed(by: self.disposeBag)

    }
    
    //CollectionViewCell 
    func setupCollectionView() {
        userPhotoCollectionView.delegate = self
        userPhotoCollectionView.register(UINib(nibName:  Cell.photosCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Cell.photosCollectionViewCell)
    }
    // if no there data the CollectionView  hidden
    func bindToHiddenCollectionView() {
        userPhotoViewModel.isCollectionHiddenObservable.bind(to: self.photosView.rx.isHidden).disposed(by: disposeBag)
    }
    // Show Activity Loading
    func subscribeToLoading() {
        userPhotoViewModel.loadingObserver.subscribe(onNext: { (isLoading) in
           if isLoading {
               self.showLoadingView()
           } else {
               self.dismissLoadingView()
           }}).disposed(by: disposeBag)
    }
    
    // Show Alert Massege
    func subscribeToShowAlert() {
        userPhotoViewModel.showAlertObserver.subscribe(onNext: { (title) in
            self.view.makeToast(title)
        }).disposed(by: disposeBag)
    }
    
    // fetch data
    func getAlbum() {
        userPhotoViewModel.fetchPhotos()
    }
    
    // MARK: UICollectionView
    func subscribeToResponseAlbum() {
        self.userPhotoViewModel.userPhotoModelObservable.bind(to: self.userPhotoCollectionView.rx.items(cellIdentifier:  Cell.photosCollectionViewCell,  cellType:  PhotosCollectionViewCell.self)) { row, photo, cell in
            cell.set(photo: photo)
        }.disposed(by: disposeBag)
    }
    
    // when i itemSelected in  CollectionView pass data
    func subscribeToPhotoSelection() {
        Observable
            .zip(userPhotoCollectionView.rx.itemSelected, userPhotoCollectionView.rx.modelSelected(Photos.self))
            .bind { [weak self] selectedIndex, photo in
                guard let self = self else{return}
                let storyBoard : UIStoryboard = UIStoryboard(name: StoryBoard.photoDetails, bundle:nil)
                let resultViewController = storyBoard.instantiateViewController(withIdentifier: StoryBoard.photoDetailsVC) as! PhotoDetailsVC
                resultViewController.photoSelect = photo.url
                self.navigationController?.pushViewController(resultViewController, animated: true)
            }.disposed(by: disposeBag)
    }
}

extension UserPhotosVC:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let sizeCell  = collectionView.frame.width / 3
        return CGSize(width: sizeCell , height:sizeCell)
    }
    
  
}
