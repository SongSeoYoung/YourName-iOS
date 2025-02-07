//
//  SignInViewModel.swift
//  YourName
//
//  Created by 송서영 on 2021/09/18.
//

import Foundation
import RxSwift
import RxRelay

final class WelcomeViewModel {
    
    private let authenticationRepository: AuthenticationRepository
    private let oauthRepository: OAuthRepository
    private let localStorage: LocalStorage
    private let disposeBag = DisposeBag()
    
    init(authenticationRepository: AuthenticationRepository,
         oauthRepository: OAuthRepository,
         localStorage: LocalStorage) {
        self.authenticationRepository = authenticationRepository
        self.oauthRepository = oauthRepository
        self.localStorage = localStorage
    }
    
    deinit {
        print("💀 \(String(describing: self)) deinit")
    }
    
    func signIn(with provider: Provider) {
        self.oauthRepository.authorize(provider: provider)
            .flatMapLatest { [weak self] response -> Observable<(accessToken: Secret, refreshToken: Secret)> in
                guard let self = self else { return .empty() }
                return self.authenticationRepository
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
                self.localStorage.write(.accessToken, value: authentication.accessToken)
                    .subscribe(onNext: { _ in })
                    .disposed(by: self.disposeBag)
                self.localStorage.write(.refreshToken, value: authentication.refreshToken)
                    .subscribe(onNext: { _ in })
                    .disposed(by: self.disposeBag)
//                self.delegate.signIn(accessToken: authentication.accessToken, refreshToken: authentication.refreshToken)
            })
            .disposed(by: self.disposeBag)
    }
}
