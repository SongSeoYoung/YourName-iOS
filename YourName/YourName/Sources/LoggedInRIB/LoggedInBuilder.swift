//
//  LoggedInBuilder.swift
//  MEETU
//
//  Created by Seori on 2022/03/06.
//

import RIBs

protocol LoggedInDependency: Dependency {
    var loggedInViewController: LoggedInViewControllable { get }
    var network: NetworkServing { get }
    var localStorage: LocalStorage { get }
}

final class LoggedInComponent: Component<LoggedInDependency>,
                               MyCardListDependency,
                               CardBooksDependency,
                               SettingDependency {
    
    fileprivate var loggedInViewController: LoggedInViewControllable {
        return dependency.loggedInViewController
    }
    var network: NetworkServing { dependency.network }
    var localStorage: LocalStorage { dependency.localStorage }
}

// MARK: - Builder

protocol LoggedInBuildable: Buildable {
    func build(withListener listener: LoggedInListener) -> LoggedInRouting
}

final class LoggedInBuilder: Builder<LoggedInDependency>, LoggedInBuildable {

    override init(dependency: LoggedInDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: LoggedInListener) -> LoggedInRouting {
        let component = LoggedInComponent(dependency: dependency)
        let interactor = LoggedInInteractor()
        interactor.listener = listener
        
        // child builder
        let myCardListBuilder = MyCardListBuilder(dependency: component)
        let cardBooksBuilder = CardBooksBuilder(dependency: component)
        let settingBuilder = SettingBuilder(dependency: component)
        
        return LoggedInRouter(
            interactor: interactor,
            viewController: component.loggedInViewController
        )
    }
}
