//
//  CardDetailBuilder.swift
//  MEETU
//
//  Created by Seori on 2022/02/14.
//

import RIBs
import RxRelay

protocol CardDetailDependency: Dependency {
    var uniqueCode: BehaviorRelay<UniqueCode> { get }
    var cardId: BehaviorRelay<Identifier> { get }
}

final class CardDetailComponent: Component<CardDetailDependency> {

    var uniqueCode: BehaviorRelay<UniqueCode> { dependency.uniqueCode }
    var cardId: BehaviorRelay<Identifier> { dependency.cardId }
    fileprivate var cardRepository: CardRepository
    
    init(
        dependency: CardDetailDependency,
        cardRepository: CardRepository
    ) {
        self.cardRepository = cardRepository
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol CardDetailBuildable: Buildable {
    func build(withListener listener: CardDetailListener) -> CardDetailRouting
}

final class CardDetailBuilder: Builder<CardDetailDependency>, CardDetailBuildable {

    override init(dependency: CardDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CardDetailListener) -> CardDetailRouting {
        let cardRepository = YourNameCardRepository()
        let component = CardDetailComponent(
            dependency: dependency,
            cardRepository: cardRepository
        )
        let viewController = CardDetailViewController.instantiate()
        let interactor = CardDetailInteractor(
            presenter: viewController,
            cardRepository: component.cardRepository,
            uniqueCode: component.uniqueCode,
            cardId: component.cardId
        )
        interactor.listener = listener
        return CardDetailRouter(
            interactor: interactor,
            viewController: viewController
        )
    }
}
