//
//  MyCardListRouter.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs

protocol MyCardListInteractable: Interactable, AlertListener {
    var router: MyCardListRouting? { get set }
    var listener: MyCardListListener? { get set }
}

protocol MyCardListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MyCardListRouter: ViewableRouter<MyCardListInteractable, MyCardListViewControllable>, MyCardListRouting {
    
    private let alertBuildable: AlertBuildable
    private var alertRouting: AlertRouting?
    
    init(
        interactor: MyCardListInteractable,
        viewController: MyCardListViewControllable,
        alertBuildable: AlertBuildable
    ) {
        self.alertBuildable = alertBuildable
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
