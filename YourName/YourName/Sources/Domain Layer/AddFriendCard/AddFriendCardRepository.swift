//
//  AddFriendCardRepository.swift
//  MEETU
//
//  Created by seori on 2021/11/27.
//

import Foundation
import RxSwift

protocol AddFriendCardRepository {
    func addFriendCard(uniqueCode: UniqueCode) -> Observable<Entity.Empty>
}

final class YourNameAddFriendCardRepository: AddFriendCardRepository {
    
    private let network: NetworkServing
    
    init(network: NetworkServing) {
        self.network = network
    }
    
    func addFriendCard(uniqueCode: UniqueCode) -> Observable<Entity.Empty> {
        return network.request(AddFriendCardAPI(uniqueCode: uniqueCode))
    }
}
