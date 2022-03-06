//
//  CardBooksBuilder.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs

protocol CardBooksDependency: Dependency {
}

final class CardBooksComponent: Component<CardBooksDependency> {
    var cardBookRepository: CardBookRepository
    
    init(
        dependency: CardBooksDependency,
        cardBookRepository: CardBookRepository = YourNameCardBookRepository(network: Environment(network: NetworkService()).network)
    ) {
        self.cardBookRepository = cardBookRepository
        super.init(dependency: dependency)
    }
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
        let viewController = CardBooksViewController.instantiate()
        let interactor = CardBooksInteractor(
            presenter: viewController,
            cardBookRepository: component.cardBookRepository
        )
        interactor.listener = listener
        return CardBooksRouter(interactor: interactor, viewController: viewController)
    }
}
