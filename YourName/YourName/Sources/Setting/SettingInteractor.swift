//
//  SettingInteractor.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs
import RxSwift

protocol SettingRouting: ViewableRouting {
    func attachOnboardingQuest()
    func attachNotice()
    func attachProducer()
}

protocol SettingPresentable: Presentable {
    var listener: SettingPresentableListener? { get set }
}

protocol SettingListener: AnyObject {
    func detachAllChildren()
}

final class SettingInteractor: PresentableInteractor<SettingPresentable>,
                               SettingInteractable {
    
    weak var router: SettingRouting?
    weak var listener: SettingListener?
    
    private let disposeBag: DisposeBag
    private let authenticationRepository: AuthenticationRepository

    init(presenter: SettingPresentable,
         authenticationRepository: AuthenticationRepository) {
        self.authenticationRepository = authenticationRepository
        self.disposeBag = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        print(" 👶 \(String(describing: self)): \(#function)")
    }

    override func willResignActive() {
        super.willResignActive()
        print(" ☠️ \(String(describing: self)): \(#function)")
    }
}

extension SettingInteractor: SettingPresentableListener {
    func didTapNotice() {
        self.router?.attachNotice()
    }
    func didTapLogout() {
        self.authenticationRepository.logout()
            .catchError { error in
                print(error)
                return .empty()
            }
            .bind(onNext: { [weak self] in
                self?.listener?.detachAllChildren()
            })
            .disposed(by: self.disposeBag)
    }
    func didTapWithdraw() {
        // alert
    }
    func didTapOnboardingQuest() {
        self.router?.attachOnboardingQuest()
    }
    func didtapProducer() {
        self.router?.attachProducer()
    }
}
