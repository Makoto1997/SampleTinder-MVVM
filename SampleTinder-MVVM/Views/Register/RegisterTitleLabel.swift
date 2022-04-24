//
//  RegisterTitleLabel.swift
//  SampleTinder-MVVM
//
//  Created by Makoto on 2022/04/20.
//

import UIKit

final class RegisterTitleLabel: UILabel {
    
    init(text: String) {
        super.init(frame: .zero)
        
        self.text = text
        self.font = .boldSystemFont(ofSize: 80)
        self.textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
