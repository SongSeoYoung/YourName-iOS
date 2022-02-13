//
//  MyCardListInteractor.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs
import RxSwift
import RxRelay

protocol MyCardListRouting: ViewableRouting {
    func attachMyCardDetail(cardCode: UniqueCode)
    func detachMyCardDetail()
    func attachCardCreation()
    func detachCardCreation()
}

protocol MyCardListPresentable: Presentable {
    var listener: MyCardListPresentableListener? { get set }
    var myCards: BehaviorRelay<[MyCardCellViewModel]> { get }
}

protocol MyCardListListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class MyCardListInteractor: PresentableInteractor<MyCardListPresentable>, MyCardListInteractable, MyCardListPresentableListener {

    weak var router: MyCardListRouting?
    weak var listener: MyCardListListener?
    private let myCardRepository: MyCardRepository
    private let questRepository: QuestRepository
    private let disposeBag: DisposeBag

    init(
        presenter: MyCardListPresentable,
        myCardRepository: MyCardRepository,
        questRepository: QuestRepository
    ) {
        self.myCardRepository = myCardRepository
        self.questRepository = questRepository
        self.disposeBag = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        print(" 👶 \(String(describing: self)): \(#function)")
//        self.checkOnboarding()
        self.fetchMyCards()
    }

    override func willResignActive() {
        super.willResignActive()
        print(" ☠️ \(String(describing: self)): \(#function)")
    }
    
    func didTapCardCreate() {
        self.router?.attachCardCreation()
    }
    func didTapMyCard(at indexPath: IndexPath) {
        guard let code = self.presenter.myCards.value[safe: indexPath.item]?.uniqueCode else {
            fatalError("cannot find card unique code at \(indexPath.item)")
        }
        self.router?.attachMyCardDetail(cardCode: code)
    }
    
    private func checkOnboarding() {
//        self.questRepository.fetchAll()
//            .compactMap { quests -> AlertViewController? in
//                let index = quests.firstIndex(where: { quest in
//                    return quest.meta == .makeFirstNameCard
//                }) ?? 0
//                guard let quest = quests[safe: index] else { return nil }
//                if quest.status == .notAchieved {
//
//                    let controller = AlertViewController.instantiate()
//                    let confirmAction: () -> Void = { [weak self] in
//                        controller.dismiss()
//                        self?.navigation.accept(.present(MyCardListDestination.quest))
//                    }
//                    controller.configure(item: .init(title: "미츄를 만들어봐츄!",
//                                                     messages: "미츄와 함께 퀘스트를 클리어하고,\n유니크 컬러를 획득하츄!",
//                                                     image: UIImage(named: "icon_onboardingMeetU")!,
//                                                     emphasisAction: .init(title: "퀘스트 확인하기",
//                                                                           action: confirmAction),
//                                                     defaultAction: .init(title: "건너뛰기",
//                                                                          action: { controller.dismiss() })))
//
//                    return controller
//                }
//                return nil
//            }
//            .bind(to: self.alertViewController)
//            .disposed(by: self.disposeBag)
    }
    
    private func fetchMyCards() {
        self.myCardRepository.fetchMyCards()
            .catchError { error in
                print(error)
                return .empty()
            }
            .compactMap { [weak self] cards -> [MyCardCellViewModel]? in
                guard let self = self else { return nil }
                return self.myCardCellViewModel(cards)
            }
            .bind(onNext: { [weak self] in
                self?.presenter.myCards.accept($0)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func myCardCellViewModel(_ cards: [Entity.NameCard]) -> [MyCardCellViewModel] {
        return cards.compactMap { card -> MyCardCellViewModel? in
            guard let personalSkills = card.personalSkills,
                  let bgColors = card.bgColor?.value,
                  let colorSource = ColorSource.from(bgColors)
            else { return nil }
            let skills = personalSkills.map { MySkillProgressView.Item(title: $0.name, level: $0.level ?? 0) }
            return MyCardCellViewModel(id: card.id ?? .empty,
                                       uniqueCode: card.uniqueCode ?? .empty,
                                       image: card.imgUrl ?? .empty,
                                       name: card.name ?? .empty,
                                       role: card.role ?? .empty,
                                       skills: skills,
                                       backgroundColor: colorSource)
        }
    }
}
