//
//  CardImageView.swift
//  SampleTinder-MVVM
//
//  Created by Makoto on 2022/04/19.
//

import UIKit

final class CardImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .gray
        layer.cornerRadius = 10
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
