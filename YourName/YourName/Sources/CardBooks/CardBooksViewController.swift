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
    func numberOfRows(in section: Int) -> Int
    func cellForRow(at indexPath: IndexPath) -> CardBook?
    func didSelectRow(at indexPath: IndexPath)
    func didTapAddFriendCard()
    func viewDidLoad()
}

final class CardBooksViewController: UIViewController, CardBooksViewControllable, Storyboarded {

    @IBOutlet private weak var cardBooksTableView: UITableView!
    @IBOutlet private weak var addFriendCardButton: UIButton!
    weak var listener: CardBooksPresentableListener?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bind()
        self.listener?.viewDidLoad()
    }
    
    private func setupUI() {
        self.cardBooksTableView.delegate = self
        self.cardBooksTableView.dataSource = self
    }
    
    private func bind() {
        self.addFriendCardButton.rx.throttleTap
            .bind(onNext: { [weak self] in
                self?.listener?.didTapAddFriendCard()
            })
            .disposed(by: self.disposeBag)
    }
}

// MARK: - CardBooksPresentable

extension CardBooksViewController: CardBooksPresentable {
    func reloadData() {
        self.cardBooksTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension CardBooksViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        self.listener?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        if self.listener?.numberOfRows(in: indexPath.section) ?? 0 == 0 {
            return self.emptyCell(at: indexPath)
        }
        return self.cardBookCell(at: indexPath)
    }
    
    private func cardBookCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.cardBooksTableView?.dequeueReusableCell(CardBookCoverTableViewCell.self, for: indexPath) else { return UITableViewCell() }
        guard let cardBook = self.listener?.cellForRow(at: indexPath) else { return cell }
        
        cell.configure(with: cardBook)
        return cell
    }
    
    private func emptyCell(at indexPath: IndexPath) -> UITableViewCell {
        return self.cardBooksTableView?.dequeueReusableCell(withIdentifier: "CardBookEmptyTableViewCell", for: indexPath) ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate

extension CardBooksViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.listener?.didSelectRow(at: indexPath)
    }
}
