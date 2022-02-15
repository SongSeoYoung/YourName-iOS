//
//  CardDetailViewController.swift
//  MEETU
//
//  Created by Seori on 2022/02/14.
//

import RIBs
import RxSwift
import UIKit

protocol CardDetailPresentableListener: AnyObject {
    func detachCardDetail()
    func attachCardMore()
    func detachCardMore()
    func didTapCardFront()
    func didTapCardBack()
    func fetch()
    func didTapUniqueCode(_ code: UniqueCode)
}

final class CardDetailViewController: UIViewController,
                                      CardDetailPresentable,
                                      CardDetailViewControllable,
                                      Storyboarded{
    
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var moreButton: UIButton!
    @IBOutlet private weak var frontViewButton: UIButton!
    @IBOutlet private weak var backViewButton: UIButton!
    @IBOutlet private weak var underLineView: UIView!
    @IBOutlet private weak var cardBackView: BackCardDetailView!
    @IBOutlet private weak var cardFrontView: FrontCardDetailView!
    @IBOutlet weak var underLineLeading: NSLayoutConstraint!
    @IBOutlet weak var underLineTrailing: NSLayoutConstraint!
    
    private let disposeBag = DisposeBag()
    
    override var hidesBottomBarWhenPushed: Bool {
        get  { self.navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }
    
    weak var listener: CardDetailPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listener?.fetch()
        self.bind()
        self.configure()
    }
    
    // MARK: Presentable
    func setup(_ bgColor: ColorSource) {
        self.view.layoutIfNeeded()
        self.view.setColorSource(bgColor)
    }
    
    func setup(_ card: CardState) {
        switch card {
        case .front(let viewModel):
            self.cardFrontView?.isHidden = false
            self.cardBackView?.isHidden = true
            self.view.layoutIfNeeded()
            self.cardFrontView?.configure(with: viewModel)
            if let frontCardButton = self.frontViewButton { self.highlight(frontCardButton) }
        case .back(let viewModel):
            self.cardFrontView?.isHidden = true
            self.cardBackView?.isHidden = false
            self.view.layoutIfNeeded()
            self.cardBackView?.configure(with: viewModel)
            if let backCardButton = self.backViewButton { self.highlight(backCardButton) }
        }
    }
    
    func toast(_ view: ToastView) {
        self.view.showToast(view)
    }
    
    
    // MARK: Private
    
    private func configure() {
        self.cardFrontView.delegate = self
    }
    
    private func bind() {
        self.highlight(frontViewButton)
        
        self.backButton.rx.throttleTap
            .bind(onNext: { [weak self] in
                self?.listener?.detachCardDetail()
            })
            .disposed(by: self.disposeBag)
        
        self.moreButton.rx.throttleTap
            .bind(onNext: { [weak self] in
                self?.listener?.attachCardMore()
            })
            .disposed(by: self.disposeBag)
        
        self.frontViewButton.rx.throttleTap
            .bind(onNext: { [weak self] _ in
                self?.listener?.didTapCardFront()
            })
            .disposed(by: self.disposeBag)
        
        self.backViewButton.rx.throttleTap
            .bind(onNext: { [weak self] _ in
                self?.listener?.didTapCardBack()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func highlight(_ view: UIView) {
        self.underLineLeading?.isActive  = false
        self.underLineTrailing?.isActive = false
        
        self.underLineLeading  = nil
        self.underLineTrailing = nil
        
        self.underLineLeading = underLineView?.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        self.underLineTrailing = underLineView?.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        
        self.underLineLeading?.isActive  = true
        self.underLineTrailing?.isActive = true
    }
}

// MARK: - FrontCardDetailViewDelegate

extension CardDetailViewController: FrontCardDetailViewDelegate {
    func frontCardDetailView(_ frontCardDetailView: FrontCardDetailView,
                             didTapCopy id: Identifier) {
        self.listener?.didTapUniqueCode(id)
    }
}
