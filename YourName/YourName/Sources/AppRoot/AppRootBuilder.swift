//
//  AppRootBuilder.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs
import UIKit

final class AppRootComponent: Component<EmptyDependency>,
                              SplashDependency,
                              LoggedOutDependency,
                              LoggedInDependency {
    
    var localStorage: LocalStorage
    var loggedInViewController: LoggedInViewControllable
    var network: NetworkServing
    
    init(network: NetworkServing,
         rootViewController: LoggedInViewControllable,
         localStorage: LocalStorage) {
        self.network = network
        self.loggedInViewController = rootViewController
        self.localStorage = localStorage
        super.init(dependency: EmptyComponent())
    }
}

// MARK: - Builder

protocol AppRootBuildable: Buildable {
    func build(with network: NetworkServing,
               localStorage: LocalStorage) -> LaunchRouting
}

final class AppRootBuilder: Builder<EmptyDependency>, AppRootBuildable {

    override init(dependency: EmptyDependency) {
        super.init(dependency: dependency)
    }

    func build(with network: NetworkServing,
               localStorage: LocalStorage) -> LaunchRouting {
        let viewController = AppRootViewController()
        let component = AppRootComponent(network: network,
                                         rootViewController: viewController,
                                         localStorage: localStorage)
        
        let interactor = AppRootInteractor(presenter: viewController,
                                           network: component.network)
        
        // child buidler
        let spalshBuilder = SplashBuilder(dependency: component)
        let loggedOutBuilder = LoggedOutBuilder(dependency: component)
        let loggedInBuilder = LoggedInBuilder(dependency: component)
        
        return AppRootRouter(
            interactor: interactor,
            viewController: viewController,
            splashBuilder: spalshBuilder,
            loggedOutBuilder: loggedOutBuilder,
            loggedInBuilder: loggedInBuilder
        )
    }
}
