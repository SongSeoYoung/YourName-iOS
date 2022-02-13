//
//  AlertViewController.swift
//  MEETU
//
//  Created by Seori on 2022/02/13.
//

import RIBs
import RxSwift
import RxCocoa
import UIKit

protocol AlertPresentableListener: AnyObject {
    func viewdidLoad()
}

final class AlertViewController: UIViewController, AlertPresentable, AlertViewControllable, Storyboarded {

    @IBOutlet private weak var alertTitleLabel: UILabel!
    @IBOutlet private weak var alertDescLabel: UILabel!
    @IBOutlet private weak var alertImage: UIImageView!
    @IBOutlet private weak var okActionButton: UIButton!
    @IBOutlet private weak var cancelActionButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private var okAction: (() -> Void)!
    private var cancelAction: (() -> Void)!
    weak var listener: AlertPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listener?.viewdidLoad()
        self.bind()
    }
    
    func setup(alert: AlertModel1) {
        self.alertTitleLabel.text = alert.alertTitle
        self.alertDescLabel.text = alert.alertDesc
        self.alertImage.image = UIImage(named: alert.alertImage)
        self.okActionButton.setTitle(alert.okActionTitle, for: .normal)
        self.cancelActionButton.setTitle(alert.cancelActionTitle, for: .normal)
        self.okAction = alert.okAction
        self.cancelAction = alert.cancelAction
    }
    
    func bind() {
        self.okActionButton.rx.throttleTap
            .bind(onNext: { [weak self] in
                self?.okAction()
            })
            .disposed(by: self.disposeBag)
        
        self.cancelActionButton.rx.throttleTap
            .bind(onNext: { [weak self] in
                self?.cancelAction()
            })
            .disposed(by: self.disposeBag)
    }
}
