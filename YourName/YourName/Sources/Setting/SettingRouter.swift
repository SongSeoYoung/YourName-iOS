//
//  SettingRouter.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs

protocol SettingInteractable: Interactable {
    var router: SettingRouting? { get set }
    var listener: SettingListener? { get set }
}

protocol SettingViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SettingRouter: ViewableRouter<SettingInteractable, SettingViewControllable>, SettingRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SettingInteractable, viewController: SettingViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
