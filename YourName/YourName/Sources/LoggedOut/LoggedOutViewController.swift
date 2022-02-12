//
//  LoggedOutViewController.swift
//  MEETU
//
//  Created by Seori on 2022/02/12.
//

import RIBs
import RxSwift
import UIKit

protocol LoggedOutPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class LoggedOutViewController: UIViewController, LoggedOutPresentable, LoggedOutViewControllable, Storyboarded {

    @IBOutlet private weak var loggedInWithKakao: UIButton!
    @IBOutlet private weak var loggedInWithApple: UIButton!
    
    weak var listener: LoggedOutPresentableListener?
}
