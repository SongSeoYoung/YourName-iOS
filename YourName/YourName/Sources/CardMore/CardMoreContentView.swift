//
//  CardMoreContentView.swift
//  MEETU
//
//  Created by Seori on 2022/02/17.
//

import UIKit
import RxSwift
import RxCocoa

protocol CardMorePresentableListener: AnyObject {
    func didTapSaveImage()
    func didTapEidt()
    func didTapDelete()
}

final class CardMoreContentView: UIView,
                                 PageSheetContentView,
                                 CardMorePresentable,
                                 NibLoadable,
                                 CardMoreViewControllable {
    var uiviewController: UIViewController {
        UIViewController()  // fix
    }
    
    
    // page sheet content view
    var parent: ViewController?   // RIB작업 후 지운다.
    var title: String { "" }
    var isModal: Bool { true }
    var onComplete: (() -> Void)? = nil
    
    weak var listener: CardMorePresentableListener?
    
    @IBOutlet private weak var imageSaveView: UIView!
    @IBOutlet private weak var editView: UIView!
    @IBOutlet private weak var deleteView: UIView!
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupFromNib()
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupFromNib()
        self.bind()
    }
    
    private func configureUI() {
        [self.editView, self.imageSaveView, self.deleteView].forEach { $0.layer.cornerRadius = 12 }
        self.editView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.deleteView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    private func bind() {
        
        self.imageSaveView.rx.tapWhenRecognized
            .bind(onNext: { [weak self] in
                self?.listener?.didTapSaveImage()
            })
            .disposed(by: disposeBag)
        
        self.deleteView.rx.tapWhenRecognized
            .bind(onNext: { [weak self] in
                self?.listener?.didTapDelete()
            })
            .disposed(by: self.disposeBag)
        
        self.editView.rx.tapWhenRecognized
            .bind(onNext: { [weak self] in
                self?.listener?.didTapEidt()
            })
            .disposed(by: self.disposeBag)
    }
}
