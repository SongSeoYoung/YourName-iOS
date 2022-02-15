//
//  MyCardListRouter.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs

protocol MyCardListInteractable: Interactable, AlertListener, CardDetailListener {
    var router: MyCardListRouting? { get set }
    var listener: MyCardListListener? { get set }
}

protocol MyCardListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MyCardListRouter: ViewableRouter<MyCardListInteractable, MyCardListViewControllable>, MyCardListRouting {
    
    private let alertBuildable: AlertBuildable
    private var alertRouting: AlertRouting?
    
    private let cardDetailBuildable: CardDetailBuildable
    private var cardDetailRouting: CardDetailRouting?
    
    init(
        interactor: MyCardListInteractable,
        viewController: MyCardListViewControllable,
        alertBuildable: AlertBuildable,
        cardDetailBuildable: CardDetailBuildable
    ) {
        self.alertBuildable = alertBuildable
        self.cardDetailBuildable = cardDetailBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    
    func attachCardCreation() {
        print(#function)
    }
    func detachCardCreation() {
        print(#function)
    }
    
    func attachMyCardDetail() {
        if self.cardDetailRouting != nil { return }
        
        let router = self.cardDetailBuildable.build(withListener: self.interactor)
        self.attachChild(router)
        self.cardDetailRouting = router
        self.viewControllable.push(viewController: router.viewControllable, animated: true)

    }
    func detachMyCardDetail() {
        if let router = self.cardDetailRouting {
            self.viewControllable.pop(animated: true)
            self.detachChild(router)
            self.cardDetailRouting = nil
        }
    }
    
    func attachQuest() {
        print(#function)
    }
    
    func detachAlert() {
        print(#function)
    }
    
    func detachQuest() {
        print(#function)
    }
    
    func attachAlert() {
        if self.alertRouting != nil { return }
        let router = self.alertBuildable.build(withListener: self.interactor)
        self.attachChild(router)
        self.alertRouting = router
        self.viewControllable.present(
            router.viewControllable,
            modalPresentationStyle: .overFullScreen,
            animated: true
        )
    }
}
