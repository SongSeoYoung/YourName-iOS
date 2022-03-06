//
//  SplashDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/10/03.
//

import Foundation

final class SplashDependencyContainer {
    
//    let rootViewModel: RootViewModel
    let authenticationRepository: AuthenticationRepository
    
    init() {
//        self.rootViewModel = rootDependencyContainer.rootViewModel
        self.authenticationRepository = YourNameAuthenticationRepository(localStorage: UserDefaults.standard, network: Environment(network: NetworkService()).network)
    }
    
    func createSplashViewController() -> SplashViewController1 {
        let viewController = SplashViewController1.instantiate()
        viewController.viewModel = createSplashViewModel()
        return viewController
    }
    
    private func createSplashViewModel() -> SplashViewModel {
        let viewModel = SplashViewModel(
            authenticationRepository: authenticationRepository
        )
        return viewModel
    }
    
}
