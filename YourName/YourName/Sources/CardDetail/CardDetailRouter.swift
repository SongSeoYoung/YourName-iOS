//
//  CardDetailRouter.swift
//  MEETU
//
//  Created by Seori on 2022/02/14.
//

import RIBs

protocol CardDetailInteractable: Interactable {
    var router: CardDetailRouting? { get set }
    var listener: CardDetailListener? { get set }
}

protocol CardDetailViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CardDetailRouter: ViewableRouter<CardDetailInteractable, CardDetailViewControllable>, CardDetailRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CardDetailInteractable, viewController: CardDetailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachCardMore() {
        print(#function)
    }
    func detachCardMore() {
        print(#function)
    }
}
