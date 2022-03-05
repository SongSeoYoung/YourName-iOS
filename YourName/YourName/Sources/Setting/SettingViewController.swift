//
//  SettingViewController.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs
import RxSwift
import UIKit

protocol SettingPresentableListener: AnyObject {
    func didTapOnboardingQuest()
    func didTapNotice()
    func didtapProducer()
    func didTapLogout()
    func didTapWithdraw()
}

final class SettingViewController: UIViewController, SettingPresentable, SettingViewControllable {

    @IBOutlet private weak var onboardingView: UIView!
    @IBOutlet private weak var noticeView: UIView!
    @IBOutlet private weak var producerView: UIView!
    @IBOutlet private weak var logoutButton: UIButton!
    @IBOutlet private weak var withdrawButton: UIButton!
    
    weak var listener: SettingPresentableListener?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bind()
    }
    
    private func configureUI() {
        self.navigationController?.navigationBar.isHidden = true
        self.noticeView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.producerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    private func bind() {
        self.onboardingView.rx.tapWhenRecognized
            .bind(onNext: { [weak self] in
                self?.listener?.didTapOnboardingQuest()
            })
            .disposed(by: self.disposeBag)
        
        self.noticeView.rx.tapWhenRecognized
            .bind(onNext: { [weak self] in
                self?.listener?.didTapNotice()
            })
            .disposed(by: self.disposeBag)
        
        self.producerView.rx.tapWhenRecognized
            .bind(onNext: { [weak self] in
                self?.listener?.didtapProducer()
            })
            .disposed(by: self.disposeBag)
        
        self.logoutButton.rx.tapWhenRecognized
            .bind(onNext: { [weak self] in
                self?.listener?.didTapLogout()
            })
            .disposed(by: self.disposeBag)
        
        self.withdrawButton.rx.tapWhenRecognized
            .bind(onNext: { [weak self] in
                self?.listener?.didTapWithdraw()
            })
            .disposed(by: self.disposeBag)
    }
}
