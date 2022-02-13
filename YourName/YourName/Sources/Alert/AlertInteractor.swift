//
//  AlertInteractor.swift
//  MEETU
//
//  Created by Seori on 2022/02/13.
//

import RIBs
import RxSwift
import RxRelay

protocol AlertRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AlertPresentable: Presentable {
    var listener: AlertPresentableListener? { get set }
    func setup(alert: AlertModel1)
}

protocol AlertListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class AlertInteractor: PresentableInteractor<AlertPresentable>, AlertInteractable, AlertPresentableListener {

    weak var router: AlertRouting?
    weak var listener: AlertListener?
    
    private let alertModel: BehaviorRelay<AlertModel1?>
    private let disposeBag: DisposeBag

    init(
        presenter: AlertPresentable,
        alertModel: BehaviorRelay<AlertModel1?>
    ) {
        self.alertModel = alertModel
        self.disposeBag = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        print(" 👶 \(String(describing: self)): \(#function)")
    }
    
    func viewdidLoad() {
        self.bind()
    }

    override func willResignActive() {
        super.willResignActive()
        print(" ☠️ \(String(describing: self)): \(#function)")
    }
    
    private func bind() {
        self.alertModel
            .compactMap { $0 }
            .bind(onNext: { [weak self] in
                self?.presenter.setup(alert: $0)
            })
            .disposed(by: self.disposeBag)
    }
}
