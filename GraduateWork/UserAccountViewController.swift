//
//  UserAccountViewController.swift
//  GraduateWork
//
//  Created by Matvey Semenov on 29.04.23.
//

import UIKit

class UserAccountViewController: UIViewController {

    var personImage : UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    let personLoginLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "Имя пользователя"
        return label
    }()
    var exitButton : UIButton = {
        var button = UIButton()
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.setTitle("Выйти", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Account"
        view.backgroundColor = .white
        
        view.addSubview(personImage)
        view.addSubview(personLoginLabel)
        view.addSubview(exitButton)
        
        personImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            personImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            personImage.widthAnchor.constraint(equalToConstant: 100),
            personImage.heightAnchor.constraint(equalToConstant: 100),
            personImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -250),
            personImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
        
        personLoginLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            personLoginLabel.topAnchor.constraint(equalTo: personImage.bottomAnchor, constant: 30),
            personLoginLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 125),
            personLoginLabel.widthAnchor.constraint(equalToConstant: 250),
            personLoginLabel.heightAnchor.constraint(equalToConstant: 34),
        ])
        
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: personLoginLabel.bottomAnchor, constant: 30),
            exitButton.heightAnchor.constraint(equalToConstant: 30),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            exitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50)
        ])
        
        let image = UIImage(systemName: "person.crop.square")
        personImage.image = image
        
        exitButton.addTarget(self, action: #selector(exitButtonPressed), for: .touchUpInside)
    }
    @objc func exitButtonPressed() {
        let controller = LoginViewController()
//        navigationController?.pushViewController(controller, animated: true)
        navigationController?.setViewControllers([controller], animated: true)
    }

}
