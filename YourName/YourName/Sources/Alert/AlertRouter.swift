//
//  AlertRouter.swift
//  MEETU
//
//  Created by Seori on 2022/02/13.
//

import RIBs

protocol AlertInteractable: Interactable {
    var router: AlertRouting? { get set }
    var listener: AlertListener? { get set }
}

protocol AlertViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AlertRouter: ViewableRouter<AlertInteractable, AlertViewControllable>, AlertRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AlertInteractable, viewController: AlertViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
