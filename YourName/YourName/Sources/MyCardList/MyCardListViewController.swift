//
//  MyCardListViewController.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs
import RxSwift
import UIKit
import RxRelay

protocol MyCardListPresentableListener: AnyObject {
    func didTapCardCreate()
    func didTapMyCard(at indexPath: IndexPath)
}

final class MyCardListViewController: UIViewController, MyCardListPresentable, MyCardListViewControllable, Storyboarded {

    @IBOutlet private weak var addMeetuButton: UIButton!
    @IBOutlet private weak var myCardListTitleLabel: UILabel!
    @IBOutlet private weak var myCardCollectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    weak var listener: MyCardListPresentableListener?
    var myCards = BehaviorRelay<[MyCardCellViewModel]>(value: [])
    private var collectionViewWidth: CGFloat { (312 * myCardCollectionView.bounds.height ) / 512 }
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure(self.myCardCollectionView)
        self.bind()
    }
    
    private func configure(_ collectionView: UICollectionView) {
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = false
        collectionView.registerWithNib(MyCardListEmptyCollectionViewCell.self)
        collectionView.registerWithNib(MyCardListCollectionViewCell.self)
    }
    private func bind() {
        self.addMeetuButton.rx.throttleTap
            .bind(onNext: { [weak self] _ in
                self?.listener?.didTapCardCreate()
            })
            .disposed(by: self.disposeBag)
        
        self.myCardCollectionView.rx.itemSelected
            .bind(onNext: { [weak self] in
                self?.listener?.didTapMyCard(at: $0)
            })
            .disposed(by: self.disposeBag)
    }
    
    // MyCardListPresentable
    func reloadCollectionView() {
        self.myCardCollectionView.reloadData()
      
    }
    func setupMyCards(count: Int) {
        self.myCardListTitleLabel.text = "나의 미츄 (\(count))"
        self.pageControl.numberOfPages = count
    }
}

extension MyCardListViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        self.myCards.value.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if self.myCards.value.isEmpty {
            guard let emptyCell = collectionView.dequeueReusableCell(
                MyCardListEmptyCollectionViewCell.self,
                for: indexPath
            ) else {
                fatalError("cannot dequeue reusable MyCardListEmptyCollectionViewCell at \(indexPath)")
            }
            let didSelect: (() -> Void) = { [weak self] in
                self?.listener?.didTapCardCreate()
            }
            emptyCell.didSelect = didSelect
            return emptyCell
        }
        
        guard let cell = collectionView.dequeueReusableCell(
            MyCardListCollectionViewCell.self,
            for: indexPath
        ) else {
         fatalError("cannot dequeue reusable MyCardListCollectionViewCell at \(indexPath)")
        }
        if let myCardView = cell.contentView as? CardFrontView,
           let item = self.myCards.value[safe: indexPath.item] {
            myCardView.configure(item: item)
        }
        return cell
    }
}

extension MyCardListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (312 * collectionView.bounds.height) / 512,
                      height: collectionView.bounds.height)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MyCardListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if self.myCards.value.isEmpty {
            let edges = UIScreen.main.bounds.width - collectionViewWidth
            return UIEdgeInsets(top: 0, left: edges / 2, bottom: 0, right: edges / 2)
        } else {
            return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension MyCardListViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        guard let layout = self.myCardCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        // cell width + item사이거리
        let cellWidthIncludingSpacing = self.collectionViewWidth + layout.minimumInteritemSpacing
        let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing

        let index: Int
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex))
        } else if velocity.x < 0 {
            index = Int(floor(estimatedIndex))
        } else {
            index = Int(round(estimatedIndex))
        }
        self.pageControl.currentPage = index
        
        targetContentOffset.pointee = CGPoint(x: CGFloat(index) * self.collectionViewWidth, y: 0)
    }
}
