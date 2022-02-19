//
//  CardMoreInteractor.swift
//  MEETU
//
//  Created by Seori on 2022/02/17.
//

import RIBs
import RxSwift

protocol CardMoreRouting: ViewableRouting {
}

protocol CardMorePresentable: Presentable {
    var listener: CardMorePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol CardMoreListener: AnyObject {
    func detachCardMore()
    func didTapDelete()
    func didTapEdit()
    func didTapSaveImage()
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
        print(" 👶 \(String(describing: self)): didBecomeActive()")
    }

    override func willResignActive() {
        super.willResignActive()
        print(" ☠️ \(String(describing: self)): willResignActive()")
    }
    
    func didTapSaveImage() {
        self.listener?.detachCardMore()
        self.listener?.didTapSaveImage()
    }
    
    func didTapDelete() {
        self.listener?.detachCardMore()
        self.listener?.didTapDelete()
    }
    
    func didTapEidt() {
        self.listener?.detachCardMore()
        self.listener?.didTapEdit()
    }
}
