//
//  MyCardListViewController.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs
import RxSwift
import UIKit

protocol MyCardListPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class MyCardListViewController: UIViewController, MyCardListPresentable, MyCardListViewControllable {

    weak var listener: MyCardListPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orange
    }
}
