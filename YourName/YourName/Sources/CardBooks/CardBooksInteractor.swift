//
//  CardBooksInteractor.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs
import RxSwift
import RxRelay

protocol CardBooksRouting: ViewableRouting {
    func attachAddFriendCard()
    func attachCardBookDetail(cardBookID: Identifier, cardBookTitle: String)
}

protocol CardBooksPresentable: Presentable {
    var listener: CardBooksPresentableListener? { get set }
    func reloadData()
}

protocol CardBooksListener: AnyObject {
}

final class CardBooksInteractor: PresentableInteractor<CardBooksPresentable>, CardBooksInteractable, CardBooksPresentableListener {

    weak var router: CardBooksRouting?
    weak var listener: CardBooksListener?
    private let cardBookRepository: CardBookRepository
    private let dispoesBag: DisposeBag
    private var cardBooks: BehaviorRelay<[CardBook]>

    init(
        presenter: CardBooksPresentable,
        cardBookRepository: CardBookRepository
    ) {
        self.cardBookRepository = cardBookRepository
        self.dispoesBag = .init()
        self.cardBooks = .init(value: [])
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.fetchCardBooks(self.cardBookRepository)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func fetchCardBooks(_ repository: CardBookRepository) {
        repository.fetchAll()
            .bind(onNext: { [weak self] cardBooks in
                self?.cardBooks.accept(cardBooks)
                self?.presenter.reloadData()
            })
            .disposed(by: self.dispoesBag)
    }
}

// MARK: - CardBooksPresentableListener

extension CardBooksInteractor: CardBooksPresentableListener {
    func numberOfRows(in section: Int) {
        self.cardBooks.value.count
    }
    func cellForRow(at indexPath: IndexPath) -> CardBook? {
        self.cardBooks.value[safe: indexPath.item]
    }
    func didSelectRow(at indexPath: IndexPath) {
        guard let cardBook = self.cellForRow(at: indexPath) else { return }
        self.router?.attachCardBookDetail(
            cardBookID: cardBook.id,
            cardBookTitle: cardBook.title
        )
    }
    func didTapAddFriendCard() {
        self.router?.attachAddFriendCard()
    }
}
