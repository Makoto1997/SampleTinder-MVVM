//
//  CardInfoLabel.swift
//  SampleTinder-MVVM
//
//  Created by Makoto on 2022/04/19.
//

import UIKit

final class CardInfoLabel: UILabel {
    // good, nope
    init(frame: CGRect, labelText: String, labelColor: UIColor) {
        super.init(frame: frame)
        
        font = .boldSystemFont(ofSize: 45)
        text = labelText
        textColor = labelColor
        layer.borderWidth = 3
        layer.borderColor = labelColor.cgColor
        layer.cornerRadius = 10
        textAlignment = .center
        alpha = 0
    }
    // その他Label
    init(frame: CGRect, labelText: String, labelFont: UIFont,labelColor: UIColor) {
        super.init(frame: frame)
        
        text = labelText
        font = labelFont
        textColor = labelColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
