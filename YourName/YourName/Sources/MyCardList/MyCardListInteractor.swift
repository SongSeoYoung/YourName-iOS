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
    func attachAlert()
    func detachAlert()
    func attachQuest()
    func detachQuest()
}

protocol MyCardListPresentable: Presentable {
    var listener: MyCardListPresentableListener? { get set }
    var myCards: BehaviorRelay<[MyCardCellViewModel]> { get }
    func reloadCollectionView()
    func setupMyCards(count: Int)
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
    private let alert: BehaviorRelay<AlertModel1?>

    init(
        presenter: MyCardListPresentable,
        myCardRepository: MyCardRepository,
        questRepository: QuestRepository,
        alert: BehaviorRelay<AlertModel1?>
    ) {
        self.myCardRepository = myCardRepository
        self.questRepository = questRepository
        self.alert = alert
        self.disposeBag = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        print(" 👶 \(String(describing: self)): \(#function)")
        self.checkOnboarding()
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
        self.questRepository.fetchAll()
//            .filter { quests in
//                let index = quests.firstIndex(where: { quest in
//                    return quest.meta == .makeFirstNameCard
//                }) ?? 0
//                guard let quest = quests[safe: index] else { return false }
//                return quest.status == .notAchieved
//            }
            .bind(onNext: { [weak self] _ in
                let okAction = { [weak self] in
                    guard let self = self else { return }
                    self.router?.detachAlert()
                    self.router?.attachQuest()
                }
                let cancelAction = { [weak self] in
                    guard let self = self else { return }
                    self.router?.detachAlert()
                }
                self?.router?.attachAlert()
                self?.alert.accept(AlertModel1(alertTitle: "미츄를 만들어봐츄!",
                                               alertDesc: "미츄와 함께 퀘스트를 클리어하고,\n유니크 컬러를 획득하츄!",
                                               alertImage: "icon_onboardingMeetU",
                                               okActionTitle: "퀘스트 확인하기",
                                               okAction: okAction,
                                               cancelActionTitle: "건너뛰기",
                                               cancelAction: cancelAction))
               
            })
            .disposed(by: self.disposeBag)
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
                self?.presenter.reloadCollectionView()
                self?.presenter.setupMyCards(count: $0.count)
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
