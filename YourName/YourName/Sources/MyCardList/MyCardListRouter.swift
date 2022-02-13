//
//  MyCardListRouter.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs

protocol MyCardListInteractable: Interactable {
    var router: MyCardListRouting? { get set }
    var listener: MyCardListListener? { get set }
}

protocol MyCardListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MyCardListRouter: ViewableRouter<MyCardListInteractable, MyCardListViewControllable>, MyCardListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(
        interactor: MyCardListInteractable,
        viewController: MyCardListViewControllable
    ) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    
    func attachCardCreation() {
        print(#function)
    }
    func detachCardCreation() {
        print(#function)
    }
    
    func attachMyCardDetail(cardCode: UniqueCode) {
        print(#function)
    }
    func detachMyCardDetail() {
        print(#function)
    }
}
