//
//  ProfileImageView.swift
//  SampleTinder-MVVM
//
//  Created by Makoto on 2022/04/28.
//

import UIKit

final class ProfileImageView: UIImageView {
    
    init() {
        super.init(frame: .zero)
        
        self.image = UIImage(named: "noImage")
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = 90
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
