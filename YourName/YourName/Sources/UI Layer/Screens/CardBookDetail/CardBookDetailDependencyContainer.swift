//
//  CardBookDependencyContainer.swift
//  YourName
//
//  Created by seori on 2021/10/04.
//

import Foundation
import UIKit

final class CardBookDetailDependencyContainer {
    
    init(cardBookListDependencyContainer: CardBookListDependencyContainer) {
        
    }
    
    func createCardBookDetailViewController(cardBookID: String) -> UIViewController {
        let viewController = CardBookDetailViewController.instantiate()
        let viewModel = createCardBookDetailViewModel(cardBookID: cardBookID)
        viewController.viewModel = viewModel
        return viewController
    }
    
    private func createCardBookDetailViewModel(cardBookID: String) -> CardBookDetailViewModel {
        let cardRepository = MockCardRepository()
        return CardBookDetailViewModel(cardBookID: cardBookID, cardRepository: cardRepository)
    }
}
