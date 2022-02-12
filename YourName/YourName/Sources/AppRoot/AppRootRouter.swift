//
//  AppRootRouter.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs

protocol AppRootInteractable: Interactable, SplashListener {
    var router: AppRootRouting? { get set }
    var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {    

    private let splashBuilder: SplashBuildable
    private var splashRouter: SplashRouting?
    
    init(interactor: AppRootInteractor,
         viewController: AppRootViewControllable,
         splashBuilder: SplashBuildable) {
        self.splashBuilder = splashBuilder
        super.init(interactor: interactor,
                   viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    func attachSplash() {
        if self.splashRouter != nil { return }
        let router = self.splashBuilder.build(withListener: self.interactor)
        self.splashRouter = router
        self.attachChild(router)
        self.viewControllable.present(router.viewControllable, animated: true)
    }
    
    func detachSplash() {
        if let router = self.splashRouter {
            self.viewControllable.dismiss(animated: true, compleition: nil)
            self.detachChild(router)
            self.splashRouter = nil
        }
    }
    
    func attachTabViewControllers() {
        print(#function)
    }
    
    func detachTabViewControllers() {
        print(#function)
    }
    
    func attachLoggedOut() {
        print(#function)
    }
    
    func detachLoggedOut() {
        print(#function)
    }
}
