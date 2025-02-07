//
//  CardBookDependencyContainer.swift
//  YourName
//
//  Created by seori on 2021/10/04.
//

import UIKit

final class CardBookDetailDependencyContainer {
    
    init(cardBookListDependencyContainer: CardBookListDependencyContainer) {
        
    }
    
    func createCardBookDetailViewController(cardBookID: CardBookID?, cardBookTitle: String?) -> UIViewController {
        let viewController = CardBookDetailViewController.instantiate()
        let viewModel = createCardBookDetailViewModel(cardBookID: cardBookID, cardBookTitle: cardBookTitle)
        viewController.viewModel = viewModel
        viewController.nameCardDetailViewControllerFactory = { cardId, uniqueCode in
            let dependencyContainer = self.createCardDetailDependencyContainer(cardId: cardId, uniqueCode: uniqueCode)
            return dependencyContainer.createNameCardDetailViewController()
        }
        return viewController
    }
    
    private func createCardBookDetailViewModel(cardBookID: CardBookID?,
                                               cardBookTitle: String?) -> CardBookDetailViewModel {
        let cardRepository = createCardRepository()
        return CardBookDetailViewModel(cardBookID: cardBookID,
                                       cardBookTitle: cardBookTitle,
                                       cardRepository: cardRepository)
    }
    
    private func createCardRepository() -> CardRepository {
        return YourNameCardRepository(network: Environment(network: NetworkService()).network)
    }
    
    private func createCardDetailDependencyContainer(cardId: Identifier, uniqueCode: UniqueCode) -> NameCardDetailDependencyContainer {
        return NameCardDetailDependencyContainer(cardId: cardId, uniqueCode: uniqueCode, cardBookDetailDependencyContainer: self)
    }
}
