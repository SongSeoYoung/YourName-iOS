//
//  AppRootRouter.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs

protocol AppRootInteractable: Interactable, MyCardListListener {
    var router: AppRootRouting? { get set }
    var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
    func setViewControllers(_ viewControllers: ViewControllable...)
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {

    private let myCardListBuilder: MyCardListBuildable
    private var myCardListRouter: MyCardListRouting?
    init(interactor: AppRootInteractor,
         viewController: AppRootViewControllable,
         myCardListBuilder: MyCardListBuildable) {
        self.myCardListBuilder = myCardListBuilder
        super.init(interactor: interactor,
                   viewController: viewController)
        interactor.router = self
    }
    
    func attachTabViewControllers() {
        if self.myCardListRouter != nil { return }
        let myCardListRouter = myCardListBuilder.build(withListener: self.interactor)
        self.myCardListRouter = myCardListRouter
        
        self.attachChild(myCardListRouter)
        self.viewController.setViewControllers(myCardListRouter.viewControllable)
    }
}
