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
    fileprivate var authRepository: AuthenticationRepository {
        YourNameAuthenticationRepository(localStorage: localStorage, network: network)
    }
    fileprivate let oauthRepository: OAuthRepository
    
    init(oauthRepository: OAuthRepository,
         dependency: LoggedOutDependency) {
        self.oauthRepository = oauthRepository
        super.init(dependency: dependency)
    }
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
        let component = LoggedOutComponent(
            oauthRepository: YourNameOAuthRepository(),
            dependency: dependency
        )
        let viewController = LoggedOutViewController.instantiate()
        
        let interactor = LoggedOutInteractor(
            presenter: viewController,
            oauthRepository: component.oauthRepository,
            authRepository: component.authRepository,
            localStorage: component.localStorage
        )
        interactor.listener = listener
        return LoggedOutRouter(interactor: interactor, viewController: viewController)
    }
}
