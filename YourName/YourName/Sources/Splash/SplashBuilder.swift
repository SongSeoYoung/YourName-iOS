//
//  SplashBuilder.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs

protocol SplashDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SplashComponent: Component<SplashDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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
        let authRepository = YourNameAuthenticationRepository(
            localStorage: UserDefaults.standard,
            network: Environment.current.network
        )
        let interactor = SplashInteractor(
            presenter: viewController,
            authRepository: authRepository
        )
        interactor.listener = listener
        return SplashRouter(interactor: interactor, viewController: viewController)
    }
}
