//
//  AppRootBuilder.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs

final class AppRootComponent: Component<EmptyDependency>, SplashDependency, LoggedOutDependency {
    // app root는 상위 DI받을 것이 없어 EmptyDependency로 정의한다.
    init() {
        super.init(dependency: EmptyComponent())
    }
}

// MARK: - Builder

protocol AppRootBuildable: Buildable {
    func build() -> LaunchRouting
}

final class AppRootBuilder: Builder<EmptyDependency>, AppRootBuildable {

    override init(dependency: EmptyDependency) {
        super.init(dependency: dependency)
    }

    func build() -> LaunchRouting {
        let component = AppRootComponent()
        let viewController = AppRootViewController()
        let interactor = AppRootInteractor(presenter: viewController)
        let spalshBuilder = SplashBuilder(dependency: component)
        let loggedOutBuilder = LoggedOutBuilder(dependency: component)
        
        return AppRootRouter(
            interactor: interactor,
            viewController: viewController,
            splashBuilder: spalshBuilder,
            loggedOutBuilder: loggedOutBuilder
        )
    }
}
