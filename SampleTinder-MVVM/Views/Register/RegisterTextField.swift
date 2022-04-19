//
//  RegisterTextField.swift
//  SampleTinder-MVVM
//
//  Created by Makoto on 2022/04/20.
//

import UIKit

final class RegisterTextField: UITextField {
    
    init(placeHolder: String) {
        super.init(frame: .zero)
        
        placeholder = placeHolder
        borderStyle = .roundedRect
        font = .systemFont(ofSize: 14)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
