//
//  ViewController.swift
//  SampleTinder-MVVM
//
//  Created by Makoto on 2022/04/10.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private var user: User?
    
    let logoutButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("ログアウト", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FirebaseManager.fetchUserFromFireStore { [weak self] result in
            
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.user = user
            case .failure:
                return
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let auth = FirebaseManager.authenticationStatusCheck()
        if !auth {
            let registerViewController = RegisterViewController()
            let nav = UINavigationController(rootViewController: registerViewController)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
    private func setupLayout() {
        
        view.backgroundColor = .white
        let topControlView = TopControlView()
        let cardView = CardView()
        let bottomControlView = BottomControlView()
        let stackView = UIStackView(arrangedSubviews: [topControlView, cardView, bottomControlView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        self.view.addSubview(stackView)
        self.view.addSubview(logoutButton)
        [
            topControlView.heightAnchor.constraint(equalToConstant: 100),
            bottomControlView.heightAnchor.constraint(equalToConstant: 100),
            
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ].forEach { $0.isActive = true }
        
        logoutButton.anchor(bottom: view.bottomAnchor, left: view.leftAnchor, bottomPadding: 10, leftPadding: 10)
        logoutButton.addTarget(self, action: #selector(tappedLogoutButton), for: .touchUpInside)
    }
    
    @objc private func tappedLogoutButton() {
        
        FirebaseManager.logout() { err in
            if err != nil {
                return
            }
            
            let registerViewController = RegisterViewController()
            let nav = UINavigationController(rootViewController: registerViewController)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
}
