//
//  CardDetailInteractor.swift
//  MEETU
//
//  Created by Seori on 2022/02/14.
//

import RIBs
import RxSwift
import RxRelay

protocol CardDetailRouting: ViewableRouting {
    func detachCardDetail()
    func attachCardMore()
    func detachCardMore()
}

protocol CardDetailPresentable: Presentable {
    typealias CardState = CardDetailInteractor.State
    
    var listener: CardDetailPresentableListener? { get set }
    func setup(_ bgColor: ColorSource)
    func setup(_ card: CardState)
}

protocol CardDetailListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class CardDetailInteractor: PresentableInteractor<CardDetailPresentable>, CardDetailInteractable, CardDetailPresentableListener {
    
    enum State {
        case front(FrontCardDetailViewModel)
        case back(BackCardDetailViewModel)
    }
    enum CardType {
        case myCard
        case friendCard
    }

    weak var router: CardDetailRouting?
    weak var listener: CardDetailListener?
    
    private let cardRepository: CardRepository
    private let uniqueCode: UniqueCode
    private let cardId: Identifier
    private let disposeBag: DisposeBag
    private let bgColor: BehaviorRelay<ColorSource?>
    private let card: BehaviorRelay<Entity.NameCard?>
    
    init(
        presenter: CardDetailPresentable,
        cardRepository: CardRepository,
        uniqueCode: UniqueCode,
        cardId: Identifier
    ) {
        self.cardId = cardId
        self.uniqueCode = uniqueCode
        self.cardRepository = cardRepository
        self.disposeBag = DisposeBag()
        self.bgColor = .init(value: nil)
        self.card = .init(value: nil)
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func detachCardDetail() {
        self.router?.detachCardDetail()
    }
    
    func attachCardMore() {
        self.router?.attachCardMore()
    }
    
    func detachCardMore() {
        self.router?.detachCardMore()
    }
    
    func didTapCardFront() {
        guard let card = self.card.value else { return }
        guard let frontCard = self.createFrontCardDetailViewModel(card) else { return }
        self.presenter.setup(.front(frontCard))
    }
    
    func didTapCardBack() {
        guard let card = self.card.value else { return }
        guard let backCard = self.createBackCardDetailViewModel(card) else { return }
        self.presenter.setup(.back(backCard))
    }
    
    func fetch() {
        self.cardRepository.fetchCard(uniqueCode: self.uniqueCode)
            .map { $0.nameCard }
            .filterNil()
            .bind(onNext: { [weak self] card in
                guard let bgColor = ColorSource.from(card.bgColor?.value ?? []),
                      let card = self?.createFrontCardDetailViewModel(card) else { return }
                self?.bgColor.accept(bgColor)
                self?.presenter.setup(bgColor)
                self?.presenter.setup(.front(card))
            })
            .disposed(by: self.disposeBag)
    }
    
    private func createFrontCardDetailViewModel(_ card: Entity.NameCard) -> FrontCardDetailViewModel? {
        guard let uniqueCode = card.uniqueCode else { return nil }
        guard let colorSource = self.bgColor.value else { return nil }
        
        let imageSource: ImageSource? = {
            guard let url = URL(string: card.imgUrl ?? .empty) else { return nil }
            return .url(url)
        }()
        let name = card.name
        let role = card.role
        let skills = card.personalSkills?.map { MySkillProgressView.Item(title: $0.name, level: $0.level ?? 0) } ?? []
        
        return FrontCardDetailViewModel(uniqueCode: uniqueCode,
                                        profileImageSource: imageSource,
                                        name: name,
                                        role: role,
                                        skills: skills,
                                        backgroundColor: colorSource)
    }
    private func createBackCardDetailViewModel(_ card: Entity.NameCard) -> BackCardDetailViewModel? {
        guard let colorSource = self.bgColor.value else { return nil }
        return BackCardDetailViewModel(personality: card.personality,
                                       contacts: card.contacts ?? [],
                                       tmis: card.tmis ?? [],
                                       aboutMe: card.introduce,
                                       backgroundColor: colorSource)
    }
}
