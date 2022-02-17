//
//  CardMoreBuilder.swift
//  MEETU
//
//  Created by Seori on 2022/02/17.
//

import RIBs

protocol CardMoreDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class CardMoreComponent: Component<CardMoreDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol CardMoreBuildable: Buildable {
    func build(withListener listener: CardMoreListener) -> CardMoreRouting
}

final class CardMoreBuilder: Builder<CardMoreDependency>, CardMoreBuildable {

    override init(dependency: CardMoreDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CardMoreListener) -> CardMoreRouting {
        let component = CardMoreComponent(dependency: dependency)
        let viewController = CardMoreViewController()
        let interactor = CardMoreInteractor(presenter: viewController)
        interactor.listener = listener
        return CardMoreRouter(interactor: interactor, viewController: viewController)
    }
}
