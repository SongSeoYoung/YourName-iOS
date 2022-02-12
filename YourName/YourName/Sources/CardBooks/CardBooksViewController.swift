//
//  CardBooksViewController.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs
import RxSwift
import UIKit

protocol CardBooksPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class CardBooksViewController: UIViewController, CardBooksPresentable, CardBooksViewControllable {

    weak var listener: CardBooksPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
    }
}
