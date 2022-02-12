//
//  SplashBuilder.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs

protocol SplashDependency: Dependency {
    var localStorage: LocalStorage { get }
    var network: NetworkServing { get }
}

final class SplashComponent: Component<SplashDependency> {
    fileprivate var localStorage: LocalStorage { dependency.localStorage }
    fileprivate var network: NetworkServing { dependency.network }
    fileprivate var authRepository: AuthenticationRepository {
        YourNameAuthenticationRepository(localStorage: localStorage, network: network)
    }
}

// MARK: - Builder

protocol SplashBuildable: Buildable {
    func build(withListener listener: SplashListener) -> SplashRouting
}

final class SplashBuilder: Builder<SplashDependency>, SplashBuildable {

    override init(dependency: SplashDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SplashListener) -> SplashRouting {
        let component = SplashComponent(dependency: dependency)
        let viewController = SplashViewController.instantiate()
       
        let interactor = SplashInteractor(
            presenter: viewController,
            authRepository: component.authRepository
        )
        interactor.listener = listener
        return SplashRouter(interactor: interactor, viewController: viewController)
    }
}
