//
//  CardBooksRouter.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs

protocol CardBooksInteractable: Interactable {
    var router: CardBooksRouting? { get set }
    var listener: CardBooksListener? { get set }
}

protocol CardBooksViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CardBooksRouter: ViewableRouter<CardBooksInteractable, CardBooksViewControllable>, CardBooksRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CardBooksInteractable, viewController: CardBooksViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachAddFriendCard() {
        print(#function)
    }
    
    func attachCardBookDetail(cardBookID: Identifier, cardBookTitle: String) {
        print(#function)
    }
}
