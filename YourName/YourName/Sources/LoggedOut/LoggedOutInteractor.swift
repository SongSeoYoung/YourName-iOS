//
//  LoggedOutInteractor.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs
import RxSwift
import RxRelay

protocol LoggedOutRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol LoggedOutPresentable: Presentable {
    var listener: LoggedOutPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol LoggedOutListener: AnyObject {
    func successLoggedIn(accessToken: Secret, refreshToken: Secret)
}

final class LoggedOutInteractor: PresentableInteractor<LoggedOutPresentable>, LoggedOutInteractable, LoggedOutPresentableListener {

    weak var router: LoggedOutRouting?
    weak var listener: LoggedOutListener?
    
    private let oauthRepository: OAuthRepository
    private let authRepository: AuthenticationRepository
    private let localStorage: LocalStorage
    private let disposeBag: DisposeBag
    
    private let localStorageWrite: PublishRelay<(key: PersistanceKey, value: Secret)>

    init(
        presenter: LoggedOutPresentable,
        oauthRepository: OAuthRepository,
        authRepository: AuthenticationRepository,
        localStorage: LocalStorage
    ) {
        self.oauthRepository = oauthRepository
        self.authRepository = authRepository
        self.localStorage = localStorage
        self.disposeBag = .init()
        self.localStorageWrite = .init()
        
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        print(" 👶 \(String(describing: self)): \(#function)")
        self.bind()
    }

    override func willResignActive() {
        super.willResignActive()
        print(" ☠️ \(String(describing: self)): \(#function)")
    }
    
    func loggedIn(with provider: Provider) {
        self.oauthRepository.authorize(provider: provider)
            .flatMapLatest { [weak self] response -> Observable<(accessToken: Secret, refreshToken: Secret)> in
                guard let self = self else { return .empty() }
                return self.authRepository
                    .fetch(withProviderToken: response.accessToken, provider: response.provider)
                    .compactMap { authentication in
                        guard let accessToken = authentication.accessToken,
                              let refreshToken = authentication.refreshToken else { return nil }
                        return (accessToken, refreshToken)
                    }
                    .compactMap { $0 }
            }
            .catchError({ error in
                //TODO: error handling
                print(error)
                return .empty()
            })
            .bind(onNext: { [weak self] authentication in
                guard let self = self else { return }
                
                self.localStorageWrite.accept((key: .accessToken, value: authentication.accessToken))
                self.localStorageWrite.accept((key: .refreshToken, value: authentication.refreshToken))
                self.listener?.successLoggedIn(
                    accessToken: authentication.accessToken,
                    refreshToken: authentication.refreshToken
                )
            })
            .disposed(by: self.disposeBag)
    }
    
    private func bind() {
        self.localStorageWrite
            .flatMap({ [weak self] persistanceKey, value -> Observable<Void> in
                guard let self = self else { return .empty() }
                return self.localStorage.write(persistanceKey, value: value)
                    .mapToVoid()
            })
            .subscribe()
            .disposed(by: self.disposeBag)
    }
}
