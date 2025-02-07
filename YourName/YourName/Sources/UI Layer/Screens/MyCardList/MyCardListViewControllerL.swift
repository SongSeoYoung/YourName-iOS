//
//  MyCardListViewControllerL.swift
//  YourName
//
//  Created by Booung on 2021/09/17.
//

import RxOptional
import RxSwift
import RxCocoa
import UIKit

final class MyCardListViewControllerL: ViewController, Storyboarded {
    
    // MARK: - UIComponents
    
    @IBOutlet private unowned var userNameLabel: UILabel!
    @IBOutlet private unowned var myCardListCollectionView: UICollectionView!
    @IBOutlet private unowned var pageControl: UIPageControl!
    @IBOutlet private unowned var addCardButton: UIButton!
    
    // MARK: - Properties
    
    var newCardCreationViewControllerFactory: (() -> CardInfoInputViewController)!
    var cardDetailViewControllerFactory: ((UniqueCode) -> NameCardDetailViewController)!
    var questViewControllerFactory: (() -> QuestViewController)!
    var viewModel: MyCardListViewModel!
    
    private var myCardList: [MyCardCellViewModel] = []
    private let disposeBag = DisposeBag()
    private lazy var collectionViewWidth = ( 312 * self.myCardListCollectionView.bounds.height ) / 512
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind()
        self.configure(collectionView: myCardListCollectionView)
        self.dispatch(to: viewModel)
        self.render(viewModel)
        self.navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - Methods
extension MyCardListViewControllerL {
    
    private func configure(collectionView: UICollectionView) {
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = false
        collectionView.registerWithNib(MyCardListEmptyCollectionViewCell.self)
        collectionView.registerWithNib(MyCardListCollectionViewCell.self)
    }
    
    private func render(_ viewModel: MyCardListViewModel) {
        self.viewModel.checkQuest()
        self.viewModel.load()
        
        viewModel.isLoading.distinctUntilChanged()
            .bind(to: self.isLoading)
            .disposed(by: disposeBag)
  
        viewModel.myCardViewModels
            .bind(onNext: { [weak self] myCardList in
                guard let self = self else { return }
                self.myCardList = myCardList
                self.myCardListCollectionView.reloadData()
                self.userNameLabel.text = "나의 미츄 (\(myCardList.count))"
                self.pageControl.numberOfPages = myCardList.count
            })
            .disposed(by: disposeBag)
        
        viewModel.alertViewController
            .bind(onNext: { [weak self] in
                self?.present($0, animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func dispatch(to viewModel: MyCardListViewModel) {
      
//        self.rx.viewDidAppear.flatMapFirst { _ in self.viewModel.navigation }
//        .bind(onNext: { [weak self] action in
//            guard let self = self else { return }
//            self.navigate(action)
//        }).disposed(by: disposeBag)
        
        self.addCardButton.rx.throttleTap
            .bind(onNext: { [weak self] _ in
                self?.viewModel.tapCardCreation()
            })
            .disposed(by: disposeBag)
        
        self.myCardListCollectionView.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                self?.viewModel.tapCard(at: indexPath.item)
            })
            .disposed(by: disposeBag)
    }
    
    private func navigate(_ navigation: MyCardListNavigation) {
        let viewController = createViewController(navigation.destination)
        navigate(viewController, action: navigation.action)
    }
    
    private func createViewController(_ next: MyCardListDestination) -> UIViewController {
        switch next {
        case .cardDetail(let uniqueCode):
            return cardDetailViewControllerFactory(uniqueCode)
        case .cardCreation:
            return newCardCreationViewControllerFactory()
        case .quest:
            return questViewControllerFactory()
        }
    }
    
    private func bind() {
        NotificationCenter.default.addObserver(forName: .myCardsDidChange, object: nil, queue: nil) { [weak self] _ in
            self?.viewModel.load()
        }
        NotificationCenter.default.addObserver(forName: .myCardDidDelete, object: nil, queue: nil) { [weak self] _ in
            self?.viewModel.load()
        }
    }
}

//MARK: - UICollectionViewDataSource

extension MyCardListViewControllerL: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.myCardList.isNotEmpty ? self.myCardList.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.myCardList.isEmpty {
            guard let cell = collectionView.dequeueReusableCell(MyCardListEmptyCollectionViewCell.self,
                                                                for: indexPath)
            else { return .init() }
            
            let didSelect: (() -> Void) = { [weak self] in
                self?.viewModel.tapCardCreation()
            }
            cell.didSelect = didSelect
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(MyCardListCollectionViewCell.self,
                                                                for: indexPath),
                  let myCardView = cell.contentView as? CardFrontView,
                  let item = myCardList[safe: indexPath.item] else { return .init() }
            
            myCardView.configure(item: item)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension MyCardListViewControllerL: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (312 * collectionView.bounds.height) / 512,
                      height: collectionView.bounds.height)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MyCardListViewControllerL: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if self.myCardList.isEmpty {
            let edges = UIScreen.main.bounds.width - collectionViewWidth
            return UIEdgeInsets(top: 0, left: edges / 2, bottom: 0, right: edges / 2)
        } else {
            return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension MyCardListViewControllerL: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        guard let layout = self.myCardListCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
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
