//
//  CardRepository.swift
//  MEETU
//
//  Created by Booung on 2021/11/13.
//

import Foundation
import RxSwift

protocol CardRepository {
    func fetchAll() -> Observable<[NameCard]>
    func fetchCards(cardBookID: CardBookID) -> Observable<[NameCard]>
    func remove(cardIDs: [NameCardID], on cardBookID: CardBookID) -> Observable<Void>
    func fetchCard(uniqueCode: UniqueCode) -> Observable<Entity.FriendCard>
}

final class YourNameCardRepository: CardRepository {
    
    init(network: NetworkServing) {
        self.network = network
    }
    
    func fetchAll() -> Observable<[NameCard]> {
        return network.request(AllFriendCardAPI())
            .compactMap { response in response.list?.compactMap { $0.nameCard } }
            .compactMap { [weak self] list in return list.compactMap { self?.translate(fromEntity: $0) } }
    }
    
    func fetchCards(cardBookID: CardBookID) -> Observable<[NameCard]> {
        return network.request(FriendCardsAPI(cardBookID: cardBookID))
            .compactMap { response in response.list?.compactMap { $0.nameCard } }
            .compactMap { [weak self] list in return list.compactMap { self?.translate(fromEntity: $0) } }
    }
    
    func fetchCard(uniqueCode: UniqueCode) -> Observable<Entity.FriendCard> {
        return self.network.request(FriendCardAPI(uniqueCode: uniqueCode))
    }
    
    func remove(cardIDs: [NameCardID], on cardBookID: CardBookID) -> Observable<Void> {
        return network.request(DeleteCardsAPI(cardBookID: cardBookID, cardIDs: cardIDs)).mapToVoid()
    }
    
    private func translate(fromEntity entity: Entity.NameCard) -> NameCard {
        return NameCard(id: entity.id, uniqueCode: entity.uniqueCode, name: entity.name, role: entity.role, introduce: entity.introduce, bgColors: entity.bgColor?.value, profileURL: entity.imgUrl, idForDelete: entity.id)
    }
    
    private let network: NetworkServing
    
}
