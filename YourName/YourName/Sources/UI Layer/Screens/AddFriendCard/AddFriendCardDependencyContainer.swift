//
//  AddFriendCardDependencyContainer.swift
//  MEETU
//
//  Created by seori on 2021/11/27.
//

import UIKit

final class AddFriendCardDependencyContainer {
    
    private let addFriendCardRepository: AddFriendCardRepository
    private let cardRepository: CardRepository
    
    init(network: NetworkServing) {
        self.addFriendCardRepository = YourNameAddFriendCardRepository(network: Environment(network: NetworkService()).network)
        self.cardRepository = YourNameCardRepository(network: network)
    }
    
    deinit {
        print(" 💀 \(String(describing: self)) deinit")
    }
    
    func createAddFriendCardViewController() -> AddFriendCardViewController {
        let viewController = AddFriendCardViewController.instantiate()
        
        let cardDetailVieWControllerFactory: (UniqueCode, Identifier) -> NameCardDetailViewController = { uniqueCode, nameCardId  in
            let dependencyContainer = self.createNameCardDetailDependencyContainer(cardId: nameCardId, uniqueCode: uniqueCode)
            return dependencyContainer.createNameCardDetailViewController()
        }
        viewController.viewModel = AddFriendCardViewModel(addFriendCardRepository: self.addFriendCardRepository,
                                                          cardRepository: self.cardRepository,
                                                          questRepository: YourNameQuestRepository(network: Environment(network: NetworkService()).network))
        viewController.cardDetailViewControllerFactory = cardDetailVieWControllerFactory
        
        return viewController
    }
    
    private func createNameCardDetailDependencyContainer(cardId: Identifier, uniqueCode: UniqueCode) -> NameCardDetailDependencyContainer {
        NameCardDetailDependencyContainer(cardId: cardId, uniqueCode: uniqueCode, addFriendCardDependencyContainer: self)
    }
}
