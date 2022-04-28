//
//  UIButton+.swift
//  SampleTinder-MVVM
//
//  Created by Makoto on 2022/04/19.
//

import UIKit

extension UIButton {
    
    func createCardButton() -> UIButton {
        
        self.setImage(UIImage(systemName: "info.circle.fill")?.resize(size: .init(width: 40, height: 40)), for: .normal)
        self.tintColor = .white
        self.imageView?.contentMode = .scaleAspectFit
        return self
    }
    
    func createAboutAccountButton(text: String) -> UIButton {
        
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 14)
        return self
    }
    
    func createProfileTopButton(title: String) -> UIButton {
        
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 15)
        return self
    }
    
    func createProfileEditButton() -> UIButton {
        
        let image = UIImage(systemName: "square.and.pencil")
        self.setImage(image, for: .normal)
        self.layer.cornerRadius = 30
        self.tintColor = .darkGray
        self.imageView?.contentMode = .scaleToFill
        self.backgroundColor = .white
        return self
    }
}
