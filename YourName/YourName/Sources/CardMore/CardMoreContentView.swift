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
                                 NibLoadable {
    
    // page sheet content view
    var parent: ViewController?
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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupFromNib()
    }
    
    convenience init(
        parent: ViewController,
        onComplete: (() -> Void)? = nil
    ) {
        self.init(frame: .zero)
        self.parent = parent
        self.onComplete = onComplete
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
    private func render(_ viewModel: CardDetailMoreViewModel) {
        viewModel.dismiss
            .bind(onNext: { [weak self] in
                self?.parent?.dismiss(animated: true)
            })
            .disposed(by: self.disposeBag)
    }
}
