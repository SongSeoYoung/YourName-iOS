//
//  AppRootViewController.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs
import RxSwift
import UIKit

protocol AppRootPresentableListener: AnyObject {
}

final class AppRootViewController: UITabBarController, AppRootPresentable, AppRootViewControllable, Storyboarded {
    
    weak var listener: AppRootPresentableListener?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    func setupViewControllers(_ viewControllers: (vc: ViewControllable, type: HomeTab)...) {
        super.setViewControllers(viewControllers.map(\.vc.uiviewController), animated: true)
        viewControllers.forEach { vc, type in
            vc.uiviewController.tabBarItem = UITabBarItem(
                title: type.description,
                image: type.icon,
                selectedImage: type.activeIcon
            )
        }
        self.tabBar.backgroundColor = .white
    }
}
