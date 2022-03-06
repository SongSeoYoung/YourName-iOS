//
//  AppRootRouter.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs

protocol AppRootInteractable: Interactable, SplashListener, LoggedOutListener, LoggedInListener {
    var router: AppRootRouting? { get set }
    var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
//    func setupViewControllers(_ viewControllers: (vc: ViewControllable, type: HomeTab)...)
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {    

    private let splashBuilder: SplashBuildable
    private var splashRouter: SplashRouting?
    
    private let loggedOutBuilder: LoggedOutBuildable
    private var loggedOutRouter: LoggedOutRouting?
    
    private let loggedInBuilder: LoggedInBuildable
    private var loggedInRouter: LoggedInRouting?
    
    init(interactor: AppRootInteractor,
         viewController: AppRootViewControllable,
         splashBuilder: SplashBuildable,
         loggedOutBuilder: LoggedOutBuildable,
         loggedInBuilder: LoggedInBuildable) {
        self.splashBuilder = splashBuilder
        self.loggedOutBuilder = loggedOutBuilder
        self.loggedInBuilder = loggedInBuilder
        super.init(interactor: interactor,
                   viewController: viewController)
        interactor.router = self
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
    
    func attachLoggedIn(accessToken: Secret, refreshToken: Secret) {
//        guard let myCardListRouter = self.setupMyCardListRouter(),
//           let cardBooksRouter = self.setupCardBooksRouter(),
//           let settingRouter = self.setupSettingRouter() else { return }
//
//        self.viewController.setupViewControllers(
//            (vc: myCardListRouter.viewControllable, type: .myCardList),
//            (vc: cardBooksRouter.viewControllable, type: .cardBooks),
//            (vc: settingRouter.viewControllable, type: .setting)
//        )
        if self.loggedInRouter != nil { return }
        let router = self.loggedInBuilder.build(withListener: self.interactor)
        self.loggedInRouter = router
        self.attachChild(router)
    }
    
    func detachLoggedIn() {
        if let router = self.loggedInRouter {
            self.detachChild(router)
            self.loggedInRouter = nil
        }
    }
    
    func attachLoggedOut() {
        if self.loggedOutRouter != nil { return }
        let router = self.loggedOutBuilder.build(withListener: self.interactor)
        self.loggedOutRouter = router
        self.attachChild(router)
        self.viewControllable.present(router.viewControllable, animated: true)
    }
    
    func detachLoggedOut() {
        if let router = self.loggedOutRouter {
            self.viewControllable.dismiss(animated: false, compleition: nil)
            self.detachChild(router)
            self.loggedOutRouter = nil
        }
    }
}

extension AppRootRouter {
//    private func setupMyCardListRouter() -> MyCardListRouting? {
//        if self.myCardListRouter != nil { return nil }
//        let router = self.myCardListBuilder.build(withListener: self.interactor)
//        self.myCardListRouter = router
//        self.attachChild(router)
//        return router
//    }
//    private func setupCardBooksRouter() -> CardBooksRouting? {
//        if self.cardBooksRouter != nil { return nil }
//        let router = self.cardBooksBuilder.build(withListener: self.interactor)
//        self.cardBooksRouter = router
//        self.attachChild(router)
//        return router
//    }
//    private func setupSettingRouter() -> SettingRouting? {
//        if self.settingRouter != nil { return nil }
//        let router = self.settingBuildable.build(withListener: self.interactor)
//        self.settingRouter = router
//        self.attachChild(router)
//        return router
//    }
}
