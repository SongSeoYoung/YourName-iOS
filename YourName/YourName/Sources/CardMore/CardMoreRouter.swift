//
//  CardMoreRouter.swift
//  MEETU
//
//  Created by Seori on 2022/02/17.
//

import RIBs

protocol CardMoreInteractable: Interactable {
    var router: CardMoreRouting? { get set }
    var listener: CardMoreListener? { get set }
}

protocol CardMoreViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CardMoreRouter: ViewableRouter<CardMoreInteractable, CardMoreViewControllable>, CardMoreRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CardMoreInteractable, viewController: CardMoreViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
