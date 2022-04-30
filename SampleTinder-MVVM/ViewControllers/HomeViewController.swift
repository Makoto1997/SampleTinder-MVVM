//
//  ViewController.swift
//  SampleTinder-MVVM
//
//  Created by Makoto on 2022/04/10.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD

final class HomeViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private var user: User?
    private var users = [User]()
    private var isCardAnimating = false
    let topControlView = TopControlView()
    let cardView = UIView()
    let bottomControlView = BottomControlView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchUsers()
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
        let stackView = UIStackView(arrangedSubviews: [topControlView, cardView, bottomControlView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        self.view.addSubview(stackView)
        [
            topControlView.heightAnchor.constraint(equalToConstant: 100),
            bottomControlView.heightAnchor.constraint(equalToConstant: 100),
            
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ].forEach { $0.isActive = true }
    }
    
    private func fetchUsers() {
        
        HUD.show(.progress)
        self.users = []
        FirebaseManager.fetchUserFromFireStore { [weak self] result in
            
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.user = user
            case .failure:
                return
            }
        }
        
        FirebaseManager.fetchUsersFromFireStore { [weak self] result in
            
            HUD.hide()
            guard let self = self else { return }
            switch result {
            case .success(let users):
                self.users = users
                self.users.forEach { user in
                    
                    let card = CardView(user: user)
                    self.cardView.addSubview(card)
                    card.anchor(top: self.cardView.topAnchor, bottom: self.cardView.bottomAnchor, left: self.cardView.leftAnchor, right: self.cardView.rightAnchor)
                }
            case .failure:
                return
            }
        }
    }
    
    
    
    private func setupBindings() {
        
        topControlView.profileButton.rx.tap.asDriver().drive { [weak self] _ in
            
            guard let self = self else { return }
            let profile = ProfileViewController()
            profile.user = self.user
            profile.presentationController?.delegate = self
            self.present(profile, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        bottomControlView.reloadView.button?.rx.tap.asDriver().drive { [weak self] _ in
            
            guard let self = self else { return }
            self.fetchUsers()
        }.disposed(by: disposeBag)
        
        bottomControlView.nopeView.button?.rx.tap.asDriver().drive { [weak self] _ in
            
            guard let self = self else { return }
            if !self.isCardAnimating {
                self.isCardAnimating = true
                self.cardView.subviews.last?.removeCardViewAnimation(x: -600, completion: {
                    self.isCardAnimating = false
                })
            }
        }.disposed(by: disposeBag)
        
        bottomControlView.likeView.button?.rx.tap.asDriver().drive { [weak self] _ in
            
            guard let self = self else { return }
            if !self.isCardAnimating {
                self.isCardAnimating = true
                self.cardView.subviews.last?.removeCardViewAnimation(x: 600, completion: {
                    self.isCardAnimating = false
                })
            }
        }.disposed(by: disposeBag)
    }
}

extension HomeViewController: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        
        if user == nil {
            users = []
            let registerViewController = RegisterViewController()
            let nav = UINavigationController(rootViewController: registerViewController)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
}
