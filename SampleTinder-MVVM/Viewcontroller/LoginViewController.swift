//
//  LoginViewController.swift
//  SampleTinder-MVVM
//
//  Created by Makoto on 2022/04/24.
//

import UIKit
import RxSwift

final class LoginViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    // MARK: UIViews
    private let titleLabel = RegisterTitleLabel(text: "Login")
    private let emailTextField = RegisterTextField(placeHolder: "email")
    private let passwordTextField = RegisterTextField(placeHolder: "password")
    private let loginButton = RegisterButton(text: "ログイン")
    private let dontHaveAccountButton = UIButton(type: .system).createAboutAccountButton(text: "アカウントをお持ちでない方はこちら")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        setupLayout()
        setupBindings()
    }
    
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
        let baseStackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        baseStackView.axis = .vertical
        baseStackView.distribution = .fillEqually
        baseStackView.spacing = 20
        view.addSubview(titleLabel)
        view.addSubview(baseStackView)
        view.addSubview(dontHaveAccountButton)
        
        emailTextField.anchor(height: 45)
        titleLabel.anchor(bottom: baseStackView.topAnchor, centerX: view.centerXAnchor, bottomPadding: 20)
        baseStackView.anchor(left: view.leftAnchor, right: view.rightAnchor, centerY: view.centerYAnchor, leftPadding: 40, rightPadding: 40)
        dontHaveAccountButton.anchor(top: baseStackView.bottomAnchor, centerX: view.centerXAnchor, topPadding: 20)
    }
    
    private func setupBindings() {
        
        dontHaveAccountButton.rx.tap.asDriver().drive { [weak self] _ in
            
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        loginButton.rx.tap.asDriver().drive { [weak self] _ in
            
            guard let self = self else { return }
            guard let email = self.emailTextField.text else { return }
            guard let password = self.passwordTextField.text else { return }
            FirebaseManager.loginWithFireAuth(email: email, password: password) { err in
                
                if err != nil {
                    return
                }
                self.dismiss(animated: true)
            }
        }.disposed(by: disposeBag)
    }
    
}
