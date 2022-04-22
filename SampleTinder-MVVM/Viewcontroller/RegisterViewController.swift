//
//  RegisterViewController.swift
//  SampleTinder-MVVM
//
//  Created by Makoto on 2022/04/20.
//

import UIKit
import RxSwift

final class RegisterViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    // MARK: UIViews
    private let titleLabel = RegisterTitleLabel()
    private let nameTextField = RegisterTextField(placeHolder: "名前")
    private let emailTextField = RegisterTextField(placeHolder: "email")
    private let passwordTextField = RegisterTextField(placeHolder: "password")
    private let registerButton = RegisterButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Methods
    private func setupGradientLayer() {
        
        let layer = CAGradientLayer()
        let startColor = UIColor.rgb(red: 227, green: 48, blue: 78).cgColor
        let endColor = UIColor.rgb(red: 245, green: 208, blue: 108).cgColor
        layer.colors = [startColor, endColor]
        layer.locations = [0.0, 1.3]
        layer.frame = view.bounds
        view.layer.addSublayer(layer)
    }
    
    private func setupLayout() {
        
        passwordTextField.isSecureTextEntry = true
        let baseStackView = UIStackView(arrangedSubviews: [nameTextField, emailTextField, passwordTextField, registerButton])
        baseStackView.axis = .vertical
        baseStackView.distribution = .fillEqually
        baseStackView.spacing = 20
        view.addSubview(titleLabel)
        view.addSubview(baseStackView)
        
        titleLabel.anchor(bottom: baseStackView.topAnchor, centerX: view.centerXAnchor, bottomPadding: 20)
        nameTextField.anchor(height: 45)
        baseStackView.anchor(left: view.leftAnchor, right: view.rightAnchor, centerY: view.centerYAnchor, leftPadding: 40, rightPadding: 40)
    }
    
    private func setupBindings() {
        
        nameTextField.rx.text.asDriver().drive { [weak self] text in
            
        }.disposed(by: disposeBag)
        
        emailTextField.rx.text.asDriver().drive { [weak self] text in
            
        }.disposed(by: disposeBag)
        
        passwordTextField.rx.text.asDriver().drive { [weak self] text in
            
        }.disposed(by: disposeBag)
        
        registerButton.rx.tap.asDriver().drive { [weak self] _ in
            
            guard let self = self else { return }
            guard let name = self.nameTextField.text else { return }
            guard let email = self.emailTextField.text else { return }
            guard let password = self.passwordTextField.text else { return }
            FirebaseManager.createUserToFireAuth(name: name, email: email, password: password) { [weak self] result in
                
                guard self == self else { return }
                switch result {
                case .success(let uid):
                    FirebaseManager.setUserDataToFireStore(name: name, email: email, uid: uid) { result in
                        
                        switch result {
                        case .success:
                            return
                        case .failure:
                            return
                        }
                    }
                case .failure:
                    return
                }
            }
        }.disposed(by: disposeBag)
    }
}
