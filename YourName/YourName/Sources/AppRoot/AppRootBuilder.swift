//
//  AppRootBuilder.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs

final class AppRootComponent: Component<EmptyDependency>, SplashDependency, LoggedOutDependency, MyCardListDependency, CardBooksDependency, SettingDependency {
    var localStorage: LocalStorage
    var network: NetworkServing
    
    init() {
        self.localStorage = UserDefaults.standard
        self.network = Environment.current.network
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
        
        // child buidler
        let spalshBuilder = SplashBuilder(dependency: component)
        let loggedOutBuilder = LoggedOutBuilder(dependency: component)
        let myCardListBuilder = MyCardListBuilder(dependency: component)
        let cardBooksBuilder = CardBooksBuilder(dependency: component)
        let settingBuilder = SettingBuilder(dependency: component)
        
        return AppRootRouter(
            interactor: interactor,
            viewController: viewController,
            splashBuilder: spalshBuilder,
            loggedOutBuilder: loggedOutBuilder,
            myCardListBuilder: myCardListBuilder,
            cardBooksBuilder: cardBooksBuilder,
            settingBuilder: settingBuilder
        )
    }
}
