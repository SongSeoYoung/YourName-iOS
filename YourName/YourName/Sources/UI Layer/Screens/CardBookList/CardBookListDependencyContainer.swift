//
//  CardBookDependencyContainer.swift
//  MEETU
//
//  Created by USER on 2021/10/28.
//

import UIKit

final class CardBookListDependencyContainer {
    
    init(signedInDependencyContainer: SignedInDependencyContainer) {
        
    }
    
    func createCardBookListViewController() -> UIViewController {
        let viewController = CardBookListViewController.instantiate()
        viewController.viewModel = createCardBookListViewModel()
        viewController.cardBookDetailFactory = { id, title in
            let dependencyContainer = self.createCardDetailDependencyContainer()
            return dependencyContainer.createCardBookDetailViewController(cardBookID: id, cardBookTitle: title)
        }
        
        viewController.addFriendFactory = {
            let dependencyContainer = self.createAddFriendCardDependencyContainer()
            return dependencyContainer.createAddFriendCardViewController()
        }
        let naviController = UINavigationController(rootViewController: viewController)
        naviController.navigationBar.isHidden = true
        return naviController
    }
    
    private func createAddFriendCardDependencyContainer() -> AddFriendCardDependencyContainer {
        return AddFriendCardDependencyContainer(network: Environment(network: NetworkService()).network)
    }
    
    private func createCardBookListViewModel() -> CardBookListViewModel {
        let cardBookRepository = createCardBookRepository()
        return CardBookListViewModel(cardBookRepository: cardBookRepository)
    }
    
    private func createCardBookRepository() -> CardBookRepository {
        return YourNameCardBookRepository(network: Environment(network: NetworkService()).network)
    }
    
    private func createCardDetailDependencyContainer() -> CardBookDetailDependencyContainer {
        return CardBookDetailDependencyContainer(cardBookListDependencyContainer: self)
    }
}
