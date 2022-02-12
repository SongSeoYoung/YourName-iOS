//
//  SplashInteractor.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs
import RxSwift

protocol SplashRouting: ViewableRouting {
    
}

protocol SplashPresentable: Presentable {
    var listener: SplashPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SplashListener: AnyObject {
    func attachLoggedIn(accessToken: Secret, refreshToken: Secret)
    func attachLoggedOut()
    func detachLoggedIn()
    func detachLoggedOut()
}

final class SplashInteractor: PresentableInteractor<SplashPresentable>, SplashInteractable, SplashPresentableListener {

    weak var router: SplashRouting?
    weak var listener: SplashListener?
    private let authRepository: AuthenticationRepository
    private let disposeBag: DisposeBag

    init(presenter: SplashPresentable,
         authRepository: AuthenticationRepository) {
        self.authRepository = authRepository
        self.disposeBag = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        print(" 👶 \(String(describing: self)): \(#function)")
        self.checkLoggedIn()
    }

    override func willResignActive() {
        super.willResignActive()
        print(" ☠️ \(String(describing: self)): \(#function)")
    }
    
    private func checkLoggedIn() {
        self.authRepository.fetch(option: [.accessToken, .refreshToken])
            .subscribe(onNext: { [weak self] authentication in
                if let accessToken = authentication?.accessToken,
                   let refreshToken = authentication?.refreshToken {
                    self?.listener?.attachLoggedIn(accessToken: accessToken, refreshToken: refreshToken)
                } else {
                    self?.listener?.attachLoggedOut()
                }
            })
            .disposed(by: self.disposeBag)
    }
}
