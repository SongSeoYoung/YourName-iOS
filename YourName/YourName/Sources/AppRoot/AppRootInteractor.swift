//
//  AppRootInteractor.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs
import RxSwift

protocol AppRootRouting: ViewableRouting {
    func attachSplash()
    func detachSplash()
    func attachLoggedIn(accessToken: Secret, refreshToken: Secret)
    func detachLoggedIn()
    func attachLoggedOut()
    func detachLoggedOut()
}

protocol AppRootPresentable: Presentable {
    var listener: AppRootPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AppRootListener: AnyObject { }

final class AppRootInteractor: PresentableInteractor<AppRootPresentable>, AppRootInteractable, AppRootPresentableListener {
    
    weak var router: AppRootRouting?
    weak var listener: AppRootListener?
    private let network: NetworkServing
    
    init(presenter: AppRootPresentable,
         network: NetworkServing) {
        self.network = network
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        print(" 👶 \(String(describing: self)): \(#function)")
        self.router?.attachSplash()
    }
    
    override func willResignActive() {
        super.willResignActive()
        print(" ☠️ \(String(describing: self)): \(#function)")
    }
    
    
    // MARK: - SplashListener
    func attachLoggedIn(accessToken: Secret, refreshToken: Secret) {
        self.router?.detachSplash()
        self.setupAuth(accessToken: accessToken, refreshToken: refreshToken)
        self.router?.attachLoggedIn(accessToken: accessToken, refreshToken: refreshToken)
    }
    
    func attachLoggedOut() {
        self.router?.detachSplash()
        self.router?.attachLoggedOut()
    }
    
    func detachLoggedIn() {
        self.router?.detachLoggedOut()
    }
    
    func detachLoggedOut() {
        self.router?.detachLoggedOut()
    }
    
    
    // MARK: - LoggedOutListener
    
    func successLoggedIn(accessToken: Secret, refreshToken: Secret) {
        self.router?.detachLoggedOut()
        self.setupAuth(accessToken: accessToken, refreshToken: refreshToken)
        self.router?.attachLoggedIn(accessToken: accessToken, refreshToken: refreshToken)
    }
    
}

extension AppRootInteractor {
    func setupAuth(accessToken: Secret, refreshToken: Secret) {
        self.network.setupAuthentication(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
