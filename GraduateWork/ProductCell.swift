//
//  ProductCell.swift
//  GraduateWork
//
//  Created by Matvey Semenov on 11.04.23.
//

import UIKit

class ProductCell: UITableViewCell {

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
    let transportButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
        return button
    }()
    let countLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    var tapAction : (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupProductCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupProductCell() {
        [avatar, nameLabel, descriptionLabel, transportButton, countLabel].forEach {
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
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -80),
            
            countLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            countLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 5),
            countLabel.trailingAnchor.constraint(equalTo: transportButton.leadingAnchor, constant: 20),
            
            transportButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            transportButton.widthAnchor.constraint(equalToConstant: 30),
            transportButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor
                                                                  , constant: -10),

            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        transportButton.addTarget(self, action: #selector(transportButtonPressed), for: .touchUpInside)
    }
    
    @objc func transportButtonPressed() {
        tapAction?()
    }
    
    func configure(product: ProductList) {
        avatar.image = product.image
        nameLabel.text = product.name
        descriptionLabel.text = product.descriptionCategory
        countLabel.text = "\(product.count) шт"
    }
}
