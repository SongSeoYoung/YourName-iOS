//
//  CardMoreViewController.swift
//  MEETU
//
//  Created by Seori on 2022/02/17.
//

import RIBs
import RxSwift
import UIKit

protocol CardMorePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class CardMoreViewController: UIViewController, CardMorePresentable, CardMoreViewControllable {

    weak var listener: CardMorePresentableListener?
}
