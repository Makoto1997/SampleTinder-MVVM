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
}
