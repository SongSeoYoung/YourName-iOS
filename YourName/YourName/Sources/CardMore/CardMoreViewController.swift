//
//  CardMoreViewController.swift
//  MEETU
//
//  Created by Seori on 2022/02/17.
//

import RIBs
import RxSwift
import UIKit


typealias CardMorePageSheetController = PageSheetController<CardMoreContentView>

final class CardMoreViewController: UIViewController, CardMorePresentable, CardMoreViewControllable {

    weak var listener: CardMorePresentableListener?
}
