//
//  LoginViewController.swift
//  GraduateWork
//
//  Created by Matvey Semenov on 29.03.23.
//

import UIKit

class LoginViewController: UIViewController {

    var login = UITextField()
    var password = UITextField()
    let authorizationButton = UIButton()
    var valodator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(login)
        login.delegate = self
        login.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            login.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            login.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            login.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        login.borderStyle = .roundedRect
        login.placeholder = "login"
        login.keyboardType = .default
        login.keyboardAppearance = .dark
        login.clearButtonMode = .whileEditing
        login.returnKeyType = .done
        login.enablesReturnKeyAutomatically = true
        login.autocorrectionType = .no
        login.smartInsertDeleteType = .no
        
        view.addSubview(password)
        password.delegate = self
        password.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            password.topAnchor.constraint(equalTo: login.bottomAnchor, constant: 30),
            password.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            password.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        password.borderStyle = .roundedRect
        password.placeholder = "Password"
        password.isSecureTextEntry = true
        password.keyboardType = .default
        password.keyboardAppearance = .dark
        password.clearButtonMode = .whileEditing
        password.returnKeyType = .done
        password.enablesReturnKeyAutomatically = true
        
        view.addSubview(authorizationButton)
        
        authorizationButton.layer.borderColor = UIColor.darkGray.cgColor
        authorizationButton.layer.borderWidth = 1
        authorizationButton.layer.cornerRadius = 10
        
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authorizationButton.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 30),
            authorizationButton.heightAnchor.constraint(equalToConstant: 30),
            authorizationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            authorizationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50)
        ])
        
        authorizationButton.setTitle("Войти", for: .normal)
        authorizationButton.setTitleColor(.black, for: .normal)
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
           return valodator.hasNumbers(text: string)
        default: break
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField.isEditing {
            return true
        }
        return false
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
