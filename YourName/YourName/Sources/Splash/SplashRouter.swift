//
//  SplashRouter.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs

protocol SplashInteractable: Interactable {
    var router: SplashRouting? { get set }
    var listener: SplashListener? { get set }
}

protocol SplashViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SplashRouter: ViewableRouter<SplashInteractable, SplashViewControllable>, SplashRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SplashInteractable, viewController: SplashViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachLoggedIn(accessToken: Secret, refreshToken: Secret) {
        print(#function)
    }
    
    func attachLoggedOut() {
        print(#function)
    }
    
    func detachLoggedIn() {
        print(#function)
    }
    
    func detachLoggedOut() {
        print(#function)
    }
}
