//
//  PhotoDetailsVC.swift
//  InstaPhoto-BostaTask
//
//  Created by Abdallah on 4/19/22.
//

import UIKit
import RxCocoa
import RxSwift
class PhotoDetailsVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    
    var photoSelect: String?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScrollView()
        fetchUrl()
        subscribeToSharenButton()
    }
    // download image form Url and cached Image it
    func fetchUrl(){
        self.imageView.loadImageUsingCacheWithURLString(photoSelect ?? "", placeHolder: UIImage(named: "no_image_placeholder"))}
    // action button in RXswift  to shareing image
    func subscribeToSharenButton() {
        shareButton.rx.tap
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self](_) in
            guard let self = self else { return }
            self.fetchUrl(url: self.photoSelect ?? "")}).disposed(by: disposeBag)
    }
    // convert url to imageView to  shareing 
    func fetchUrl(url:String){
        guard let url = URL(string:url) else { fatalError(ResoneError.invaldURL.rawValue) }
        if let imageData = NSData(contentsOf: url) {
            let image = UIImage(data: imageData as Data)
            let activityVC = UIActivityViewController(activityItems: [image ?? UIImage()], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}
