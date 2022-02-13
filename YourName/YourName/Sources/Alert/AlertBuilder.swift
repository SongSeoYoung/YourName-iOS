//
//  AlertBuilder.swift
//  MEETU
//
//  Created by Seori on 2022/02/13.
//

import RIBs
import RxRelay

struct AlertModel1 {
    var alertTitle: String
    var alertDesc: String
    var alertImage: String
    var okActionTitle: String
    var okAction: (() -> Void)
    var cancelActionTitle: String
    var cancelAction: (() -> Void)
}

protocol AlertDependency: Dependency {
    var alertModel: BehaviorRelay<AlertModel1?> { get }
}

final class AlertComponent: Component<AlertDependency> {
    fileprivate var alertModel: BehaviorRelay<AlertModel1?> { dependency.alertModel }
}

// MARK: - Builder

protocol AlertBuildable: Buildable {
    func build(withListener listener: AlertListener) -> AlertRouting
}

final class AlertBuilder: Builder<AlertDependency>, AlertBuildable {

    override init(dependency: AlertDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AlertListener) -> AlertRouting {
        let component = AlertComponent(dependency: dependency)
        let viewController = AlertViewController.instantiate()
        let interactor = AlertInteractor(
            presenter: viewController,
            alertModel: component.alertModel
        )
        interactor.listener = listener
        return AlertRouter(interactor: interactor, viewController: viewController)
    }
}
