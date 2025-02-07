//
//  CardBookCollectionViewCell.swift
//  YourName
//
//  Created by seori on 2021/10/03.
//

import UIKit
import Then

protocol FriendCardCollectionViewCellDelegate: AnyObject {
    func friendCardCollectionViewCell(didTapCheck id: NameCardID)
}

struct FriendCardCellViewModel: Equatable, Then {
    let id: NameCardID?
    let name: String?
    let role: String?
    let bgColor: ColorSource?
    let profileURL: URL?
    var isEditing: Bool
    var isChecked: Bool
}

final class FriendCardCollectionViewCell: UICollectionViewCell {

    weak var delegate: FriendCardCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkBoxDidTap))
        self.checkBoxView?.addGestureRecognizer(tapGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.clipsToBounds = true
        self.borderWidth = 3
        self.checkBoxView?.clipsToBounds = true
        self.checkBoxView?.borderWidth = 3
        self.roleBackgroundView?.alpha = 0.6
    }
    
    func configure(with viewModel: FriendCardCellViewModel) {
        self.cardID = viewModel.id
        self.nameLabel?.text = viewModel.name
        self.roleLabel?.text = viewModel.role
        self.checkBoxView?.isHidden = viewModel.isEditing == false
        self.checkBoxView?.backgroundColor = viewModel.isChecked ? .black : .white
        if let url = viewModel.profileURL {
            self.profileImageView?.setImageSource(.url(url))
        }
        if let colorSource = viewModel.bgColor {
            self.updateBackgroundColor(colorSource: colorSource)
        }
        self.borderColor = viewModel.isChecked ? .black : .clear
    }
    
    private func updateBackgroundColor(colorSource: ColorSource) {
        switch colorSource {
        case .monotone(let color):
            self.contentView.updateGradientLayer(colors: [color])
            
        case .gradient(let colors):
            self.contentView.updateGradientLayer(colors: colors)
        }
    }
    
    @objc
    private func checkBoxDidTap() {
        guard let cardID = self.cardID else { return }
        
        self.delegate?.friendCardCollectionViewCell(didTapCheck: cardID)
    }
    
    private var cardID: NameCardID? = nil
    
    @IBOutlet private weak var profileImageView: UIImageView?
    @IBOutlet private weak var roleLabel: UILabel?
    @IBOutlet private weak var nameLabel: UILabel?

    @IBOutlet private weak var roleBackgroundView: UIView?
    @IBOutlet private weak var checkBoxView: UIImageView?
    
}
