//
//  MyCardListBuilder.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs

protocol MyCardListDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MyCardListComponent: Component<MyCardListDependency> {
    fileprivate let myCardRepository: MyCardRepository
    fileprivate let questRepository: QuestRepository
    
    init(
        dependency: MyCardListDependency,
        myCardRepository: MyCardRepository,
         questRepository: QuestRepository
    ) {
        self.myCardRepository = myCardRepository
        self.questRepository = questRepository
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
        let component = MyCardListComponent(
            dependency: dependency,
            myCardRepository: myCardRepository,
            questRepository: questRepository
        )
        let viewController = MyCardListViewController.instantiate()
        let interactor = MyCardListInteractor(
            presenter: viewController,
            myCardRepository: component.myCardRepository,
            questRepository: component.questRepository
        )
        interactor.listener = listener
        return MyCardListRouter(interactor: interactor, viewController: viewController)
    }
}
