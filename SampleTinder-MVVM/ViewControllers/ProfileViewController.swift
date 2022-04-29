//
//  ProfileViewController.swift
//  SampleTinder-MVVM
//
//  Created by Makoto on 2022/04/28.
//

import UIKit
import RxSwift
import SDWebImage

final class ProfileViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    var user: User?
    private let cellId = "cellId"
    private var hasChangeImage = false
    private var name = ""
    private var age = ""
    private var email = ""
    private var residence = ""
    private var hobby = ""
    private var introduction = ""
    
    let saveButton = UIButton(type: .system).createProfileTopButton(title: "保存")
    let logoutButton = UIButton(type: .system).createProfileTopButton(title: "ログアウト")
    let nameLabel = ProfileLabel()
    let profileImageView = ProfileImageView()
    let profileEditButton = UIButton(type: .system).createProfileEditButton()
    
    lazy var infoCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBinding()
    }
    
    private func setupLayout() {
        
        view.backgroundColor = .white
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 90
        profileImageView.layer.masksToBounds = true
        // Viewの配置を設定
        view.addSubview(saveButton)
        view.addSubview(logoutButton)
        view.addSubview(nameLabel)
        view.addSubview(profileImageView)
        view.addSubview(profileEditButton)
        view.addSubview(infoCollectionView)
        
        saveButton.anchor(top: view.topAnchor, left: view.leftAnchor, topPadding: 20, leftPadding: 15)
        logoutButton.anchor(top: view.topAnchor, right: view.rightAnchor, topPadding: 20, rightPadding: 15)
        profileImageView.anchor(top: view.topAnchor, centerX: view.centerXAnchor, width: 180, height: 180, topPadding: 60)
        nameLabel.anchor(top: profileImageView.bottomAnchor, centerX: view.centerXAnchor, topPadding: 20)
        profileEditButton.anchor(top: profileImageView.topAnchor, right: profileImageView.rightAnchor, width: 60, height: 60)
        infoCollectionView.anchor(top: nameLabel.bottomAnchor, bottom: view.bottomAnchor,left: view.leftAnchor, right: view.rightAnchor, topPadding: 20)
        
        // ユーザー情報を反映
        nameLabel.text = user?.name
        if let url = URL(string: user?.profileImageUrl ?? "") {
            profileImageView.sd_setImage(with: url)
        }
    }
    
    private func setupBinding() {
        
        saveButton.rx.tap.asDriver().drive { [weak self] _ in
            
            guard let self = self else { return }
            let dic = ["name": self.name, "age": self.age, "email": self.email, "residence": self.residence, "hobby": self.hobby, "introduction": self.introduction]
            
            FirebaseManager.updateUserInfo(dic: dic) { err in
                
                if err != nil {
                    return
                }
                
                if self.hasChangeImage {
                    // 画像を保存する処理
                    guard let image = self.profileImageView.image else { return }
                    FirebaseManager.addProfileImageToStorage(image: image, dic: dic) { err in
                        
                        if err != nil {
                            return
                        }
                    }
                }
            }
        }.disposed(by: disposeBag)
        
        profileEditButton.rx.tap.asDriver().drive { [weak self] _ in
            
            guard let self = self else { return }
            let pickerView = UIImagePickerController()
            pickerView.delegate = self
            self.present(self, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        logoutButton.rx.tap.asDriver().drive { [weak self] _ in
            
            guard let self = self else { return }
            self.logout()
        }.disposed(by: disposeBag)
    }
    
    private func logout() {
        
        FirebaseManager.logout() { err in
            if err != nil {
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        
        guard let presentationController = presentationController else { return }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
    
    private func setupCellBinding(cell: InfoCollectionViewCell) {
        
        cell.nameTextField.rx.text.asDriver().drive { [weak self] text in
            
            guard let self = self else { return }
            self.name = text ?? ""
        }.disposed(by: disposeBag)
        
        cell.ageTextField.rx.text.asDriver().drive { [weak self] text in
            
            guard let self = self else { return }
            self.age = text ?? ""
        }.disposed(by: disposeBag)
        
        cell.emailTextField.rx.text.asDriver().drive { [weak self] text in
            
            guard let self = self else { return }
            self.email = text ?? ""
        }.disposed(by: disposeBag)
        
        cell.residenceTextField.rx.text.asDriver().drive { [weak self] text in
            
            guard let self = self else { return }
            self.residence = text ?? ""
        }.disposed(by: disposeBag)
        
        cell.hobbyTextField.rx.text.asDriver().drive { [weak self] text in
            
            guard let self = self else { return }
            self.hobby = text ?? ""
        }.disposed(by: disposeBag)
        
        cell.introductionTextField.rx.text.asDriver().drive { [weak self] text in
            
            guard let self = self else { return }
            self.introduction = text ?? ""
        }.disposed(by: disposeBag)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            profileImageView.image = image.withRenderingMode(.alwaysOriginal)
        }
        
        hasChangeImage = true
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = infoCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! InfoCollectionViewCell
        cell.user = self.user
        setupCellBinding(cell: cell)
        return cell
    }
}
