//
//  ViewController.swift
//  SampleTinder-MVVM
//
//  Created by Makoto on 2022/04/10.
//

import UIKit

final class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        let view1 = UIView()
        view1.backgroundColor = .red
        let view2 = UIView()
        view2.backgroundColor = .blue
        let view3 = BottomControlView()
        let stackView = UIStackView(arrangedSubviews: [view1, view2, view3])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        self.view.addSubview(stackView)
        
        [
            view1.heightAnchor.constraint(equalToConstant: 100),
            view3.heightAnchor.constraint(equalToConstant: 100),
            
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ].forEach { $0.isActive = true }
    }
}

