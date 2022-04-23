//
//   Helper+Ext.swift
//  InstaPhoto-BostaTask
//
//  Created by Abdallah on 4/20/22.
//

import Foundation
import UIKit
extension  UIViewController {
    func showLoadingView(){DispatchQueue.main.async {self.view.makeToastActivity(.center)}}
    func dismissLoadingView(){DispatchQueue.main.async {self.view.hideToastActivity()}}
}
