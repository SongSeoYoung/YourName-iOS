//
//  CardBooksBuilder.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs

protocol CardBooksDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class CardBooksComponent: Component<CardBooksDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol CardBooksBuildable: Buildable {
    func build(withListener listener: CardBooksListener) -> CardBooksRouting
}

final class CardBooksBuilder: Builder<CardBooksDependency>, CardBooksBuildable {

    override init(dependency: CardBooksDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CardBooksListener) -> CardBooksRouting {
        let component = CardBooksComponent(dependency: dependency)
        let viewController = CardBooksViewController()
        let interactor = CardBooksInteractor(presenter: viewController)
        interactor.listener = listener
        return CardBooksRouter(interactor: interactor, viewController: viewController)
    }
}
