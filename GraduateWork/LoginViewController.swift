//
//  LoginViewController.swift
//  GraduateWork
//
//  Created by Matvey Semenov on 29.03.23.
//

import UIKit

class LoginViewController: UIViewController {

    
    var login: UITextField = {
        
        let textField = UITextField()
        
        textField.borderStyle = .roundedRect
        textField.placeholder = "login"
        textField.keyboardType = .default
        textField.keyboardAppearance = .dark
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.enablesReturnKeyAutomatically = true
        textField.autocorrectionType = .no
        textField.smartInsertDeleteType = .no
        
        return textField
    }()
    
    var password : UITextField = {
       
        let textField = UITextField()
        
        textField.borderStyle = .roundedRect
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.keyboardType = .default
        textField.keyboardAppearance = .dark
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.enablesReturnKeyAutomatically = true
        
        return textField
    }()
    
    let authorizationButton : UIButton = {
        
       let button = UIButton()
        
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    var validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(login)
        view.addSubview(password)
        view.addSubview(authorizationButton)
        
        login.delegate = self
        login.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            login.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            login.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            login.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        password.delegate = self
        password.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            password.topAnchor.constraint(equalTo: login.bottomAnchor, constant: 30),
            password.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            password.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authorizationButton.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 30),
            authorizationButton.heightAnchor.constraint(equalToConstant: 30),
            authorizationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            authorizationButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50)
        ])

        authorizationButton.addTarget(self, action: #selector(pushButtonAction), for: .touchUpInside)
    }
    
    @objc func pushButtonAction() {
        let controller = TableViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == login {
            password.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case login:
            break
        case password:
           return validator.hasNumbers(text: string)
        default: break
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField.isEditing {
            return true
        }
        return textField.isEditing
    }
    
}

struct Validator {
    let numbers = "0123456789"
    
    func hasNumbers(text: String) -> Bool{
        for number in numbers {
            if text.contains(number) { return true }
        }
        return false
    }
}
