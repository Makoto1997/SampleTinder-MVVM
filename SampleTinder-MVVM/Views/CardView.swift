//
//  CardView.swift
//  SampleTinder-MVVM
//
//  Created by Makoto on 2022/04/17.
//

import UIKit

final class CardView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    // MARK: UIViews
    private let cardImageView = CardImageView(frame: .zero)
    private let infoButton = UIButton(type: .system).createCardButton()
    private let nameLabel = CardInfoLabel(frame: .zero, labelText: "Taro, 22", labelFont: .systemFont(ofSize: 40, weight: .heavy), labelColor: .white)
    private let residenceLabel = CardInfoLabel(frame: .zero, labelText: "日本、大阪", labelFont: .systemFont(ofSize: 20, weight: .regular), labelColor: .white)
    private let hobbyLabel = CardInfoLabel(frame: .zero, labelText: "ランニング", labelFont: .systemFont(ofSize: 25, weight: .regular), labelColor: .white)
    private let introductionLabel = CardInfoLabel(frame: .zero, labelText: "走り回るのが大好きです", labelFont: .systemFont(ofSize: 25, weight: .regular), labelColor: .white)
    private let goodLabel = CardInfoLabel(frame: .zero, labelText: "GOOD", labelColor: .rgb(red: 137, green: 223, blue: 86))
    private let nopeLabel = CardInfoLabel(frame: .zero, labelText: "NOPE", labelColor: .rgb(red: 222, green: 110, blue: 110))
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        setupLayout()
        setupCAGradientLayer()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panCardView))
        self.addGestureRecognizer(panGesture)
    }
    
    @objc private func panCardView(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self)
        if gesture.state == .changed {
            self.handlePanChange(translation: translation)
        } else if gesture.state == .ended {
            self.handlePanEnded()
        }
    }
    
    private func handlePanChange(translation: CGPoint) {
        // Cardをただ動かすだけでなく斜め方向に動かす。
        let degree: CGFloat = translation.x / 20
        let angle = degree * .pi / 100
        let rotateTranslation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotateTranslation.translatedBy(x: translation.x, y: translation.y)
        // alpha値の計算
        let ratio: CGFloat = 1 / 100
        let ratioValue = ratio * translation.x
        if translation.x > 0 {
            self.goodLabel.alpha = ratioValue
        } else if translation.x < 0 {
            self.nopeLabel.alpha = -ratioValue
        }
    }
    // 離した時の処理
    private func handlePanEnded() {
        // 離した時にバウンドさせる。
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: []) {
            self.transform = .identity
            self.layoutIfNeeded()
            self.goodLabel.alpha = 0
            self.nopeLabel.alpha = 0
        }
    }
    
    private func setupLayout() {
        
        let infoVerticalStackView = UIStackView(arrangedSubviews: [residenceLabel, hobbyLabel, introductionLabel])
        infoVerticalStackView.axis = .vertical
        let baseStackView = UIStackView(arrangedSubviews: [infoVerticalStackView, infoButton])
        baseStackView.axis = .horizontal
        
        addSubview(cardImageView)
        addSubview(baseStackView)
        addSubview(nameLabel)
        addSubview(goodLabel)
        addSubview(nopeLabel)
        cardImageView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, leftPadding: 10, rightPadding: 10)
        infoButton.anchor(width: 40)
        baseStackView.anchor(bottom: cardImageView.bottomAnchor, left: cardImageView.leftAnchor, right: cardImageView.rightAnchor, bottomPadding: 10, leftPadding: 20, rightPadding: 20)
        nameLabel.anchor(bottom: baseStackView.topAnchor, left: cardImageView.leftAnchor, bottomPadding: 40, leftPadding: 20)
        goodLabel.anchor(top: cardImageView.topAnchor, left: cardImageView.leftAnchor, width: 140, height: 55, topPadding: 25, leftPadding: 20)
        nopeLabel.anchor(top: cardImageView.topAnchor, right: cardImageView.rightAnchor, width: 140, height: 55, topPadding: 25, rightPadding: 20)
    }
    
    private func setupCAGradientLayer() {
        // カード下部を暗くする。
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.3, 1.1]
        cardImageView.layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        
        gradientLayer.frame = self.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
