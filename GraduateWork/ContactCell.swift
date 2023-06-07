//
//  ContactCell.swift
//  GraduateWork
//
//  Created by Matvey Semenov on 2.04.23.
//

import UIKit

class StorageCell: UITableViewCell {

    let avatar = UIImageView()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .darkGray
        return label
    }()
    let descriptionButton : UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        return button
    }()
    var tapAction : (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        [avatar, nameLabel, descriptionLabel,descriptionButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatar.heightAnchor.constraint(equalToConstant: 32),
            avatar.widthAnchor.constraint(equalToConstant: 32),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -55),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            descriptionButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            descriptionButton.widthAnchor.constraint(equalToConstant: 40),
            descriptionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            descriptionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        descriptionButton.addTarget(self, action: #selector(descriptionButtonPressed), for: .touchUpInside)
        
    }
    @objc func descriptionButtonPressed() {
        tapAction?()
    }
    
    
    func configure(contact: Storage) {
        avatar.image = contact.image
        nameLabel.text = contact.name
        descriptionLabel.text = contact.description
    }
}
