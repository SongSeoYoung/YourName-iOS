//
//  TMISettingView.swift
//  YourName
//
//  Created by Booung on 2021/10/04.
//

import UIKit
import RxSwift
import RxCocoa

typealias TMISettingViewController = PageSheetController<TMISettingView>

enum TMISection: Int, CaseIterable {
    case interest
    case personality
    
    var title: String {
        switch self {
        case .interest: return "취미 / 관심사"
        case .personality: return "성격"
        }
    }
}

final class TMISettingView: UIView, NibLoadable {
    
    var viewModel: TMISettingViewModel! {
        didSet { bind(to: viewModel) }
    }
    var parent: ViewController?
    var onComplete: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupFromNib()
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupFromNib()
        self.setupUI()
    }
    
    private func setupUI() {
        self.tmiCollectionView?.registerSectionHeaderNib(TMISectionHeaderView.self)
        self.tmiCollectionView?.registerWithNib(TMIContentCollectionViewCell.self)
        
        let leftAlignLayout = LeftAlignCollectionViewLayout()
        leftAlignLayout.delegate = self
        self.tmiCollectionView?.collectionViewLayout = leftAlignLayout
        self.tmiCollectionView?.dataSource = self
        self.tmiCollectionView?.delegate = self
    }
    
    private func bind(to viewModel: TMISettingViewModel) {
        self.dispatch(to: viewModel)
        self.render(viewModel)
        
        onComplete = { [weak viewModel] in viewModel?.tapComplete() }
        tmiCollectionView?.rx.observe(CGSize.self, "contentSize")
            .distinctUntilChanged()
            .filterNil()
            .subscribe(onNext: { [weak self] contentSize in
                self?.tmiCollectionViewHeight?.constant = contentSize.height
            })
            .disposed(by: disposeBag)
    }
    
    private func dispatch(to viewModel: TMISettingViewModel) {
        viewModel.didLoad()
        
    }
    
    private func render(_ viewModel: TMISettingViewModel) {
        viewModel.interestsForDisplay.distinctUntilChanged()
            .subscribe(onNext: { [weak self] list in
                self?.interestes = list
                self?.tmiCollectionView?.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.strongPointsForDisplay.distinctUntilChanged()
            .subscribe(onNext: { [weak self] list in
                self?.personalities = list
                self?.tmiCollectionView?.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    
    private var interestes: [TMIContentCellViewModel] = []
    private var personalities: [TMIContentCellViewModel] = []
    
    @IBOutlet private weak var tmiCollectionView: UICollectionView?
    @IBOutlet private weak var tmiCollectionViewHeight: NSLayoutConstraint?
    
}
extension TMISettingView: PageSheetContentView {
    var title: String { "나의 TMI 입력하기" }
    var isModal: Bool { true }
}
extension TMISettingView: UICollectionViewDataSource {
    
    // Section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return TMISection.allCases.count
    }
   
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView(frame: .zero) }
        guard let section = TMISection(rawValue: indexPath.section) else { return UICollectionReusableView(frame: .zero) }
        guard let headerView = collectionView.dequeueSectionHeader(TMISectionHeaderView.self, for: indexPath) else { return UICollectionReusableView(frame: .zero) }
        headerView.configure(title: section.title)
        return headerView
    }
    
    // Item
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = TMISection(rawValue: section) else { return 0 }
        
        switch section {
        case .interest:     return interestes.count
        case .personality:  return personalities.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = TMISection(rawValue: indexPath.section) else { return UICollectionViewCell() }
        
        switch section {
        case .interest:     return interestCell(at: indexPath)
        case .personality:  return personalityCell(at: indexPath)
        }
    }
    
    private func interestCell(at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = tmiCollectionView?.dequeueReusableCell(TMIContentCollectionViewCell.self, for: indexPath) else { return UICollectionViewCell() }
        guard let interest = interestes[safe: indexPath.item] else { return cell }
        
        cell.configure(with: interest)
        return cell
    }
    
    private func personalityCell(at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = tmiCollectionView?.dequeueReusableCell(TMIContentCollectionViewCell.self, for: indexPath) else { return UICollectionViewCell() }
        guard let personality = personalities[safe: indexPath.item] else { return cell }
        
        cell.configure(with: personality)
        return cell
    }
    
}

extension TMISettingView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = TMISection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .interest:     viewModel.tapInterest(at: indexPath.item)
        case .personality:  viewModel.tapStrongPoint(at: indexPath.item)
        }
    }
}

extension TMISettingView: LeftAlignCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let section = TMISection(rawValue: indexPath.section) else { return .zero }
        
        switch section {
        case .interest:
            guard let interest = interestes[safe: indexPath.item] else { return .zero }
            return TMIContentCollectionViewCell.cellSize(with: interest)
        case .personality:
            guard let personality = personalities[safe: indexPath.item] else { return .zero }
            return TMIContentCollectionViewCell.cellSize(with: personality)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 24, bottom: 80, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, lineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, interitemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
}
