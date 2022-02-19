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

final class CardDetailComponent: Component<CardDetailDependency>, CardMoreDependency {

    var uniqueCode: BehaviorRelay<UniqueCode> { dependency.uniqueCode }
    var cardId: BehaviorRelay<Identifier> { dependency.cardId }
    fileprivate var cardRepository: CardRepository
    fileprivate var clipboardService: ClipboardService
    
    init(
        dependency: CardDetailDependency,
        cardRepository: CardRepository = YourNameCardRepository(),
        clipboardService: ClipboardService = YourNameClipboardService()
    ) {
        self.cardRepository = cardRepository
        self.clipboardService = clipboardService
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
        let component = CardDetailComponent(dependency: dependency)
        let viewController = CardDetailViewController.instantiate()
        let interactor = CardDetailInteractor(
            presenter: viewController,
            cardRepository: component.cardRepository,
            uniqueCode: component.uniqueCode,
            cardId: component.cardId,
            clipboardService: component.clipboardService
        )
        interactor.listener = listener
        
        
        // child builder
        let cardMoreBuilder = CardMoreBuilder(dependency: component)
        return CardDetailRouter(
            interactor: interactor,
            viewController: viewController,
            cardMoreBuildable: cardMoreBuilder
        )
    }
}
