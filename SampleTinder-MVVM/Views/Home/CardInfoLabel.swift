//
//  CardInfoLabel.swift
//  SampleTinder-MVVM
//
//  Created by Makoto on 2022/04/19.
//

import UIKit

final class CardInfoLabel: UILabel {
    // good, nope
    init(text: String, textColor: UIColor) {
        super.init(frame: .zero)
        
        font = .boldSystemFont(ofSize: 45)
        self.text = text
        self.textColor = textColor
        layer.borderWidth = 3
        layer.borderColor = textColor.cgColor
        layer.cornerRadius = 10
        textAlignment = .center
        alpha = 0
    }
    // その他Label
    init(text: String, font: UIFont) {
        super.init(frame: .zero)
        
        self.text = text
        self.textColor = .white
        self.font = font
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
