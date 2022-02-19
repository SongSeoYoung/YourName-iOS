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
    func attachCardMore()
    func detachCardMore()
}

protocol CardDetailPresentable: Presentable {
    typealias CardState = CardDetailInteractor.State
    
    var listener: CardDetailPresentableListener? { get set }
    func setup(_ bgColor: ColorSource)
    func setup(_ card: CardState)
    func toast(_ view: ToastView)
}

protocol CardDetailListener: AnyObject {
    func detachMyCardDetail()
}

final class CardDetailInteractor: PresentableInteractor<CardDetailPresentable>, CardDetailInteractable, CardDetailPresentableListener {
    
    // card more listener
    func didTapDelete() {
        print(#function)
        // alert rib붙이기
    }
    
    func didTapEdit() {
        print(#function)
        // card creation으로 가야됨
    }
    
    func didTapSaveImage() {
        print(#function)
        // activity controller RIB
    }
    
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
    private let uniqueCode: BehaviorRelay<UniqueCode>
    private let cardId: BehaviorRelay<Identifier>
    private let disposeBag: DisposeBag
    private let bgColor: BehaviorRelay<ColorSource?>
    private let card: BehaviorRelay<Entity.NameCard?>
    private let clipboardService: ClipboardService
    
    init(
        presenter: CardDetailPresentable,
        cardRepository: CardRepository,
        uniqueCode: BehaviorRelay<UniqueCode>,
        cardId: BehaviorRelay<Identifier>,
        clipboardService: ClipboardService
    ) {
        self.cardId = cardId
        self.uniqueCode = uniqueCode
        self.cardRepository = cardRepository
        self.clipboardService = clipboardService
        self.disposeBag = DisposeBag()
        self.bgColor = .init(value: nil)
        self.card = .init(value: nil)
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        print(" 👶 \(String(describing: self)): \(#function)")
    }

    override func willResignActive() {
        super.willResignActive()
        print(" ☠️ \(String(describing: self)): \(#function)")
    }
    
    func detachCardDetail() {
        self.listener?.detachMyCardDetail()
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
    
    func didTapUniqueCode(_ code: UniqueCode) {
        self.clipboardService.copy(code)
        self.presenter.toast(ToastView(text: "코드명이 복사되었츄!"))
    }
    
    func fetch() {
        self.cardRepository.fetchCard(uniqueCode: self.uniqueCode.value)
            .map { $0.nameCard }
            .filterNil()
            .bind(onNext: { [weak self] card in
                guard let bgColor = ColorSource.from(card.bgColor?.value ?? []) else { return }
                                                     
                self?.card.accept(card)
                self?.bgColor.accept(bgColor)
                self?.presenter.setup(bgColor)
                guard let state = self?.createFrontCardDetailViewModel(card) else { return }
                self?.presenter.setup(.front(state))
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
