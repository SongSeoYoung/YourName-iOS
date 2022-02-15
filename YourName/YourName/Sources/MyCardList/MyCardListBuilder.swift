//
//  MyCardListBuilder.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs
import RxRelay

protocol MyCardListDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MyCardListComponent: Component<MyCardListDependency>, AlertDependency, CardDetailDependency {
    
    
    fileprivate let myCardRepository: MyCardRepository
    fileprivate let questRepository: QuestRepository
    var alertModel: BehaviorRelay<AlertModel1?>
    var uniqueCode: BehaviorRelay<UniqueCode>
    var cardId: BehaviorRelay<Identifier>
    
    init(
        dependency: MyCardListDependency,
        myCardRepository: MyCardRepository,
        questRepository: QuestRepository,
        alertModel: BehaviorRelay<AlertModel1?>,
        uniqueCode: BehaviorRelay<UniqueCode>,
        cardId: BehaviorRelay<Identifier>
    ) {
        self.myCardRepository = myCardRepository
        self.questRepository = questRepository
        self.alertModel = alertModel
        self.cardId = cardId
        self.uniqueCode = uniqueCode
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol MyCardListBuildable: Buildable {
    func build(withListener listener: MyCardListListener) -> MyCardListRouting
}

final class MyCardListBuilder: Builder<MyCardListDependency>, MyCardListBuildable {

    override init(dependency: MyCardListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MyCardListListener) -> MyCardListRouting {
        let myCardRepository = YourNameMyCardRepository()
        let questRepository = YourNameQuestRepository()
        let alert = BehaviorRelay<AlertModel1?>(value: nil)
        let uniqueCode = BehaviorRelay<UniqueCode>(value: "")
        let cardId = BehaviorRelay<Identifier>(value: "")
        let component = MyCardListComponent(
            dependency: dependency,
            myCardRepository: myCardRepository,
            questRepository: questRepository,
            alertModel: alert,
            uniqueCode: uniqueCode,
            cardId: cardId
        )
        let viewController = MyCardListViewController.instantiate()
        let interactor = MyCardListInteractor(
            presenter: viewController,
            myCardRepository: component.myCardRepository,
            questRepository: component.questRepository,
            alert: alert,
            uniqueCode: uniqueCode,
            cardId: cardId
        )
        interactor.listener = listener
        
        // child builder
        let alertBuildable = AlertBuilder(dependency: component)
        let cardDetailBuildable = CardDetailBuilder(dependency: component)
        
        return MyCardListRouter(
            interactor: interactor,
            viewController: viewController,
            alertBuildable: alertBuildable,
            cardDetailBuildable: cardDetailBuildable
        )
    }
}
