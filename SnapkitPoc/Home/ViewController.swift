//
//  ViewController.swift
//  SnapkitPoc
//
//  Created by Sagar on 14/08/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    let parentView = UIView()
    let welcomeLabel = UILabel()
    let logo = UIImageView()
    let goButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupParentView()
        configureWelcomLabel()
        configureImageView()
        configureButton()
        setConstraint()
    }
    
    @objc func onButtonClick(button: UIButton) {
        navigationController?.pushViewController(TableViewController(), animated: true)
    }
    
    private func setupParentView() {
        title = StringConstant.kDataPlanning
        view.backgroundColor = .white
        parentView.backgroundColor = .cyan
    }
    
    private func setConstraint() {
        view.addSubview(parentView)
        view.addSubview(welcomeLabel)
        view.addSubview(logo)
        view.addSubview(goButton)
        
        parentView.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(10)
            make.right.equalTo(view).offset(-10)
            make.bottom.equalTo(view).offset(-10)
            make.left.equalTo(view).offset(10)
        }
        
        logo.snp.makeConstraints { make in
            make.height.equalTo(parentView.snp.height).dividedBy(4)
            make.center.equalTo(parentView.snp.center)
            make.right.equalTo(parentView.snp.right)
            make.left.equalTo(parentView.snp.left)
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.bottom.equalTo(logo.snp.top).offset(10)
            make.right.equalTo(parentView.snp.right)
            make.left.equalTo(parentView.snp.left)
        }
        
        goButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(logo.snp.bottom).offset(10)
            make.right.equalTo(parentView.snp.right).offset(-10)
            make.left.equalTo(parentView.snp.left).offset(10)
        }
    }
    
    private func configureWelcomLabel() {
        welcomeLabel.text = StringConstant.kWelcomeText
        welcomeLabel.textColor = .red
        welcomeLabel.font = UIFont.boldSystemFont(ofSize: 22 )
        welcomeLabel.backgroundColor = .clear
        welcomeLabel.textAlignment = .center
    }
    
    private func configureImageView() {
        logo.image = UIImage(named: "cavista-cover")
        logo.contentMode = .scaleAspectFit
    }
    
    private func configureButton() {
        goButton.setTitle(StringConstant.kOpeningList, for: .normal)
        goButton.backgroundColor = .red
        goButton.layer.cornerRadius = 10.0
        goButton.addTarget(self, action: #selector(onButtonClick(button:)), for: .touchUpInside)
    }
}



