//
//  CardMoreInteractor.swift
//  MEETU
//
//  Created by Seori on 2022/02/17.
//

import RIBs
import RxSwift

protocol CardMoreRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardMorePresentable: Presentable {
    var listener: CardMorePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol CardMoreListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class CardMoreInteractor: PresentableInteractor<CardMorePresentable>, CardMoreInteractable, CardMorePresentableListener {

    weak var router: CardMoreRouting?
    weak var listener: CardMoreListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: CardMorePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
