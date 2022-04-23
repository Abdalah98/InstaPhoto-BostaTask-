//
//  ViewController.swift
//  InstaPhoto-BostaTask
//
//  Created by Abdallah on 4/19/22.
//

import UIKit
import RxCocoa
import RxSwift
class ProfileVc: UIViewController {
    
    @IBOutlet weak var nameUserLabel: UILabel!
    @IBOutlet weak var addressUserlabel: UILabel!
    @IBOutlet weak var albumTableView: UITableView!
    @IBOutlet weak var albumsView: UIView!
    
    let disposeBag       = DisposeBag()
    let profileViewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindLabelToViewModel()
        subscribeToLoading()
        subscribeToShowAlert()
        subscribeToResponseAlbum()
        subscribeToAlbumSelection()
        bindToHiddenTable()
        NotificationCenter.default.addObserver(self,selector: #selector(statusManager),name: .flagsChanged,object: nil)
        profileViewModel.updateUserInterface()
    }

    // Update User Interface if has connection or not has connection networking
    // - Parameter notification: notification center
    @objc func statusManager(_ notification: Notification) {
      profileViewModel.updateUserInterface()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    // bind data with Label
    func bindLabelToViewModel() {
        profileViewModel.nameUserBehavior.asObservable().map{ $0}.bind(to: self.nameUserLabel.rx.text).disposed(by: disposeBag)
        profileViewModel.addressUserBehavior.asObservable().map{ $0}.bind(to: self.addressUserlabel.rx.text).disposed(by: disposeBag)
    }
    // TableViewCell
    func setupTableView() {
        albumTableView.delegate = self
        albumTableView.register(UINib(nibName: Cell.albumTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.albumTableViewCell)
    }
    // if no there data the table view hidden
    func bindToHiddenTable() {
        profileViewModel.isTableHiddenObservable.bind(to: self.albumsView.rx.isHidden).disposed(by: disposeBag)
    }
    // Show Activity Loading
    func subscribeToLoading() {
        profileViewModel.loadingObserver.subscribe(onNext: { (isLoading) in
            if isLoading {
                self.showLoadingView()
            } else {
                self.dismissLoadingView()
            }
        }).disposed(by: disposeBag)
    }
    
    // Show Alert Massege
    func subscribeToShowAlert() {
        profileViewModel.showAlertObserver.subscribe(onNext: { (title) in
            self.view.makeToast(title)
        }).disposed(by: disposeBag)
    }
    // fetch User data
    func getUserData() {
        profileViewModel.fetchUserData()
    }
    // MARK: UITableView
    func subscribeToResponseAlbum() {
        self.profileViewModel.albumModelObservable.bind(to: self.albumTableView.rx.items(cellIdentifier:  Cell.albumTableViewCell,
         cellType:  AlbumTableViewCell.self)) { row, album, cell in
            cell.albumNameLabel.text = album.title
        }.disposed(by: disposeBag)
    }
    // when i itemSelected in  TableView pass data
    func subscribeToAlbumSelection() {
        Observable
            .zip(albumTableView.rx.itemSelected, albumTableView.rx.modelSelected(Albums.self))
            .bind { [weak self] selectedIndex, album in
                guard let self = self else{return}
                let storyBoard : UIStoryboard = UIStoryboard(name: StoryBoard.photo, bundle:nil)
                let resultViewController = storyBoard.instantiateViewController(withIdentifier: StoryBoard.userPhotosVC) as! UserPhotosVC
                resultViewController.albumTitle = album.title
                resultViewController.userId = String(album.userID)
                self.navigationController?.pushViewController(resultViewController, animated: true)
            }.disposed(by: disposeBag)
    }
}

extension ProfileVc: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }
}
