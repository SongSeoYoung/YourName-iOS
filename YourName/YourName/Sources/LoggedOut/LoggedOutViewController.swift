//
//  LoggedOutViewController.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs
import RxSwift
import UIKit

protocol LoggedOutPresentableListener: AnyObject {
    func loggedIn(with provider: Provider)
}

final class LoggedOutViewController: UIViewController, LoggedOutPresentable, LoggedOutViewControllable, Storyboarded {

    @IBOutlet private weak var loggedInWithKakao: UIButton!
    @IBOutlet private weak var loggedInWithApple: UIButton!
    private let disposeBag = DisposeBag()
    
    weak var listener: LoggedOutPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
    }
    
    private func bind() {
        Observable.merge(
            self.loggedInWithApple.rx.throttleTap.map { _ in return Provider.apple },
            self.loggedInWithKakao.rx.throttleTap.map { _ in return Provider.kakao }
            )
            .bind(onNext: { [weak self] provider in
                self?.listener?.loggedIn(with: provider)
            })
            .disposed(by: self.disposeBag)
    }
}
