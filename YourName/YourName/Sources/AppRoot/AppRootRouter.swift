//
//  AppRootRouter.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs

protocol AppRootInteractable: Interactable, SplashListener, LoggedOutListener, MyCardListListener, CardBooksListener, SettingListener {
    var router: AppRootRouting? { get set }
    var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
    func setupViewControllers(_ viewControllers: (vc: ViewControllable, type: HomeTab)...)
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {    

    private let splashBuilder: SplashBuildable
    private var splashRouter: SplashRouting?
    
    private let loggedOutBuilder: LoggedOutBuildable
    private var loggedOutRouter: LoggedOutRouting?
    
    private let myCardListBuilder: MyCardListBuildable
    private var myCardListRouter: MyCardListRouting?
    
    private let cardBooksBuilder: CardBooksBuildable
    private var cardBooksRouter: CardBooksRouting?
    
    private let settingBuildable: SettingBuildable
    private var settingRouter: SettingRouting?
    
    init(interactor: AppRootInteractor,
         viewController: AppRootViewControllable,
         splashBuilder: SplashBuildable,
         loggedOutBuilder: LoggedOutBuildable,
         myCardListBuilder: MyCardListBuildable,
         cardBooksBuilder: CardBooksBuildable,
         settingBuilder: SettingBuildable) {
        self.splashBuilder = splashBuilder
        self.loggedOutBuilder = loggedOutBuilder
        self.myCardListBuilder = myCardListBuilder
        self.cardBooksBuilder = cardBooksBuilder
        self.settingBuildable = settingBuilder
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
        print(#function)
        guard let myCardListRouter = self.setupMyCardListRouter(),
           let cardBooksRouter = self.setupCardBooksRouter(),
           let settingRouter = self.setupSettingRouter() else { return }
        
        self.viewController.setupViewControllers(
            (vc: myCardListRouter.viewControllable, type: .myCardList),
            (vc: cardBooksRouter.viewControllable, type: .cardBooks),
            (vc: settingRouter.viewControllable, type: .setting)
        )
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
        if let router = self.loggedOutRouter {
            self.viewControllable.dismiss(animated: false, compleition: nil)
            self.detachChild(router)
            self.loggedOutRouter = nil
        }
    }
}

extension AppRootRouter {
    private func setupMyCardListRouter() -> MyCardListRouting? {
        if self.myCardListRouter != nil { return nil }
        let router = self.myCardListBuilder.build(withListener: self.interactor)
        self.myCardListRouter = router
        self.attachChild(router)
        return router
    }
    private func setupCardBooksRouter() -> CardBooksRouting? {
        if self.cardBooksRouter != nil { return nil }
        let router = self.cardBooksBuilder.build(withListener: self.interactor)
        self.cardBooksRouter = router
        self.attachChild(router)
        return router
    }
    private func setupSettingRouter() -> SettingRouting? {
        if self.settingRouter != nil { return nil }
        let router = self.settingBuildable.build(withListener: self.interactor)
        self.settingRouter = router
        self.attachChild(router)
        return router
    }
}
