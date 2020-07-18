//
//  ViewController.swift
//  CombineLatest
//
//  Created by Zafar on 7/15/20.
//  Copyright © 2020 Zafar. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        Observable
            .combineLatest(
                usernameTextField.rx.text.orEmpty,
                passwordTextField.rx.text.orEmpty
            )
            .map { username, password -> Bool in
                print(username, password)
                return username.count > 4 && password.count > 7
            }
            .bind(to: isButtonEnabled)
            .disposed(by: disposeBag)
        
        isButtonEnabled
            .do(onNext: { [unowned self] (isEnabled) in
                self.signInButton.backgroundColor = isEnabled ? .systemOrange : .lightGray
                self.signInButton.isEnabled = isEnabled
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let isButtonEnabled = BehaviorRelay<Bool>(value: false)
    
    // MARK: - UI Elements
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Username",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.textAlignment = .center
        textField.textColor = .black
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Password",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.textAlignment = .center
        textField.textColor = .black
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var signInButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .lightGray
        button.setTitle("Sign In", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK:- UI Setup
    private func setupUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(usernameTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(signInButton)
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
            usernameTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            usernameTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: self.usernameTextField.bottomAnchor, constant: 20),
            passwordTextField.leftAnchor.constraint(equalTo: self.usernameTextField.leftAnchor),
            passwordTextField.rightAnchor.constraint(equalTo: self.usernameTextField.rightAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            signInButton.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            signInButton.leftAnchor.constraint(equalTo: self.passwordTextField.leftAnchor),
            signInButton.rightAnchor.constraint(equalTo: self.passwordTextField.rightAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}
