//
//  AppRootRouter.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs

protocol AppRootInteractable: Interactable, SplashListener, LoggedOutListener {
    var router: AppRootRouting? { get set }
    var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {    

    private let splashBuilder: SplashBuildable
    private var splashRouter: SplashRouting?
    private let loggedOutBuilder: LoggedOutBuildable
    private var loggedOutRouter: LoggedOutRouting?
    
    init(interactor: AppRootInteractor,
         viewController: AppRootViewControllable,
         splashBuilder: SplashBuildable,
         loggedOutBuilder: LoggedOutBuildable) {
        self.splashBuilder = splashBuilder
        self.loggedOutBuilder = loggedOutBuilder
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
        self.viewControllable.present(router.viewControllable, animated: false)
    }
    
    func detachSplash() {
        if let router = self.splashRouter {
            self.viewControllable.dismiss(animated: false, compleition: nil)
            self.detachChild(router)
            self.splashRouter = nil
        }
    }
    
    func attachLoggedIn() {
        print(#function)
    }
    
    func detachLoggedIn() {
        print(#function)
    }
    
    func attachLoggedOut() {
        if self.loggedOutRouter != nil { return }
        let router = self.loggedOutBuilder.build(withListener: self.interactor)
        self.loggedOutRouter = router
        self.attachChild(router)
        self.viewControllable.present(router.viewControllable, animated: true)
    }
    
    func detachLoggedOut() {
        print(#function)
    }
}
