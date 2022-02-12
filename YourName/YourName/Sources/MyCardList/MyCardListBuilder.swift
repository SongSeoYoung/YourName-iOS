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

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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
        let component = MyCardListComponent(dependency: dependency)
        let viewController = MyCardListViewController()
        let interactor = MyCardListInteractor(presenter: viewController)
        interactor.listener = listener
        return MyCardListRouter(interactor: interactor, viewController: viewController)
    }
}
