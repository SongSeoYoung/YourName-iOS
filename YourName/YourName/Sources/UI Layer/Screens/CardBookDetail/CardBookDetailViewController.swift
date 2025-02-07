//
//  CardBookViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/17.
//

import UIKit
import RxSwift
import RxCocoa
 
final class CardBookDetailViewController: ViewController, Storyboarded {
   
    private enum Constant {
        static let collectionViewSectionInset = 24
        static let collectionViewCellSpacing = 19
    }
    
    var viewModel: CardBookDetailViewModel!
    var addFriendCardViewControllerFactory: (() -> AddFriendCardViewController)!
    var nameCardDetailViewControllerFactory: ((Identifier, UniqueCode) -> NameCardDetailViewController)!
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = true
        super.viewDidLoad()
        configureCollectionView()
        bind()
    }
    
    private func bind() {
        dispatch(to: viewModel)
        render(viewModel)
        
        NotificationCenter.default.addObserver(forName: .friendCardDidDelete, object: nil, queue: nil) { [weak self] _ in
            self?.viewModel.didLoad()
        }
    }
    
    private func dispatch(to viewModel: CardBookDetailViewModel) {
        self.viewModel.didLoad()
        
//        self.rx.viewDidAppear
//            .flatMapFirst { _ in self.viewModel.navigation }
//            .subscribe(onNext: { [weak self] action in
//                guard let self = self else { return }
//                self.navigate(action)
//            }).disposed(by: disposeBag)
        
        self.backButton?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.tapBack()
            })
            .disposed(by: self.disposeBag)
        
        self.moreButton?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.tapEdit()
            })
            .disposed(by: self.disposeBag)
        
        self.removeButton?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.tapRemove()
            })
            .disposed(by: self.disposeBag)
        
        self.bottomRemoveButton?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.tapRemove()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func render(_ viewModel: CardBookDetailViewModel) {
        self.viewModel.cardBookTitle.distinctUntilChanged()
            .subscribe(onNext: { [weak self] cardBookTitle in
                self?.cardBookTitleLabel?.text = cardBookTitle
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.isLoading.distinctUntilChanged()
            .bind(to: self.isLoading)
            .disposed(by: self.disposeBag)
        
        self.viewModel.friendCardsForDisplay.distinctUntilChanged()
            .subscribe(onNext: { [weak self] cellViewModels in
                self?.cellViewModels = cellViewModels
                self?.friendCardCollectionView?.reloadData()
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.isEditing.distinctUntilChanged()
            .subscribe(onNext: { [weak self] isEditing in
                self?.moreButton?.isHidden = isEditing
                self?.removeButton?.isHidden = isEditing == false
                self?.bottomBarView?.isHidden = isEditing == false
                self?.bottomRemoveButton?.isHidden = isEditing == false
                self?.isCardEditing = isEditing
            })
            .disposed(by: self.disposeBag)
        
        
        Observable.combineLatest(self.viewModel.isEditing, self.viewModel.isEmpty)
            .subscribe(onNext: { [weak self] isEditing, isEmpty in
                self?.moreButton?.isHidden = isEmpty || isEditing
                self?.removeButton?.isHidden = isEmpty || !isEditing
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.isAllCardBook.distinctUntilChanged()
            .map { $0 ? UIImage(named: "ic_delete") : UIImage(named: "btn_more") }
            .subscribe(onNext: { [weak self] icon in
                self?.moreButton?.setImage(icon, for: .normal)
            })
            .disposed(by: self.disposeBag)
                
        self.viewModel.shouldShowRemoveReconfirmAlert
            .subscribe(onNext: {
                let alertController = AlertViewController1.instantiate()
                let okAction = { [weak self] in
                    guard let self = self else { return }
                    alertController.dismiss()
                    self.viewModel.tapRemoveConfirm()
                }
                let cancelAction = { [weak self] in
                    guard let self = self else { return }
                    alertController.dismiss()
                    self.viewModel.tapRemoveCancel()
                }
                alertController.configure(item: AlertItem(title: "정말 삭제하시겠츄?",
                                                          messages: "삭제한 미츄와 도감은 복구할 수 없어요.",
                                                          image: UIImage(named: "meetu_delete")!,
                                                          emphasisAction: .init(title: "삭제하기", action: okAction),
                                                          defaultAction: .init(title: "삭제안할래요", action: cancelAction)))
                self.present(alertController, animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.shouldClose
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func navigate(_ navigation: CardBookDetailNavigation) {
        let viewController = createViewController(navigation.destination)
        navigate(viewController, action: navigation.action)
    }
    
    private func createViewController(_ next: CardBookDetailDestination) -> UIViewController {
        switch next {
        case .cardDetail(let cardId, let uniqueCode): return self.nameCardDetailViewControllerFactory(cardId, uniqueCode)
        }
    }
    
    private func configureCollectionView() {
        friendCardCollectionView?.registerWithNib(FriendCardCollectionViewCell.self)
        friendCardCollectionView?.registerWithNib(FriendCardEmptyCollectionViewCell.self)
        friendCardCollectionView?.dataSource = self
        friendCardCollectionView?.delegate = self
    }
    
    private let disposeBag = DisposeBag()
    
    private var isCardEditing = false
    private var cellViewModels: [FriendCardCellViewModel] = []
    
    @IBOutlet private weak var backButton: UIButton?
    @IBOutlet private weak var moreButton: UIButton?
    @IBOutlet private weak var removeButton: UIButton?
    @IBOutlet private weak var cardBookTitleLabel: UILabel?
    @IBOutlet private weak var friendCardCollectionView: UICollectionView?
    @IBOutlet private weak var bottomRemoveButton: UIButton?
    @IBOutlet private weak var bottomBarView: UIView?

}

// TODO: rx datasource로 추후 교체예정
extension CardBookDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.cellViewModels.isNotEmpty {
            return self.cellViewModels.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.cellViewModels.isNotEmpty {
            return friendCardCell(indexPath: indexPath)
        } else {
            return emptyCell(indexPath: indexPath)
        }
    }
    
    private func friendCardCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.friendCardCollectionView?.dequeueReusableCell(FriendCardCollectionViewCell.self, for: indexPath) else {
            return UICollectionViewCell()
        }
        guard let cellViewModel = self.cellViewModels[safe: indexPath.row] else { return cell }
        cell.configure(with: cellViewModel)
        return cell
    }
    
    private func emptyCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.friendCardCollectionView?.dequeueReusableCell(FriendCardEmptyCollectionViewCell.self, for: indexPath) else {
            return UICollectionViewCell()
        }
        return cell
    }
    
}

extension CardBookDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard self.cellViewModels.isNotEmpty else { return }
        if isCardEditing { self.viewModel.tapCheck(at: indexPath.item) }
        else             { self.viewModel.tapCard(at: indexPath.item)  }
    }
    
}

extension CardBookDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // width 154 height 241
        let width = Int(UIScreen.main.bounds.width) - (Constant.collectionViewSectionInset * 2) - Constant.collectionViewCellSpacing
        return CGSize(width: width / 2,
                      height: (241 * (width / 2)) / 154)
    }
}
