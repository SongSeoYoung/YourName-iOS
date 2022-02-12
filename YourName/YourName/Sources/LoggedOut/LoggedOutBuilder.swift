//
//  LoggedOutBuilder.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs

protocol LoggedOutDependency: Dependency {
    var localStorage: LocalStorage { get }
    var network: NetworkServing { get }
}

final class LoggedOutComponent: Component<LoggedOutDependency> {
    fileprivate var localStorage: LocalStorage { dependency.localStorage }
    fileprivate var network: NetworkServing { dependency.network }
}

// MARK: - Builder

protocol LoggedOutBuildable: Buildable {
    func build(withListener listener: LoggedOutListener) -> LoggedOutRouting
}

final class LoggedOutBuilder: Builder<LoggedOutDependency>, LoggedOutBuildable {

    override init(dependency: LoggedOutDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: LoggedOutListener) -> LoggedOutRouting {
        let component = LoggedOutComponent(dependency: dependency)
        let viewController = LoggedOutViewController.instantiate()
        
        let oauthRepository = YourNameOAuthRepository()
        let authRepository = YourNameAuthenticationRepository(
            localStorage: dependency.localStorage,
            network: dependency.network)
        
        let interactor = LoggedOutInteractor(
            presenter: viewController,
            oauthRepository: oauthRepository,
            authRepository: authRepository,
            localStorage: component.localStorage
        )
        interactor.listener = listener
        return LoggedOutRouter(interactor: interactor, viewController: viewController)
    }
}
