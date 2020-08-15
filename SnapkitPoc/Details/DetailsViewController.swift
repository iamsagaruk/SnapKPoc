//
//  DetailsViewController.swift
//  SnapkitPoc
//
//  Created by Sagar on 14/08/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import UIKit
import SnapKit

class DetailsViewController: UIViewController {
    var parentView = UIView()
    var dateLabel = UILabel()
    var coverImageView = UIImageView()
    var dataLabel = UILabel()
    var details: PlanningDataResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
        view.backgroundColor = .white
        
        parentView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        configureDeteLabel()
        configureDataLabel()
        
        setConstraint()
        handleVisibility()
        setCoverImageView()
    }
    
    private func configureDeteLabel() {
        dateLabel.text = "Date: \(details?.date ?? "Not available")"
        dateLabel.textAlignment = .left
        dateLabel.backgroundColor = .clear
        dateLabel.textColor = .red
    }
    
    private func configureDataLabel() {
        dataLabel.text = details?.planningData
        dataLabel.textAlignment = .center
        dataLabel.backgroundColor = .clear
        dataLabel.textColor = .black
        dataLabel.numberOfLines = 0
        dataLabel.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
    func handleVisibility() {
        coverImageView.isHidden = !(details?.type == "image")
        dataLabel.isHidden = details?.type == "image"
    }
    
    func setCoverImageView() {
        coverImageView.layer.cornerRadius = 10
        if let localImage = loadImageFromDocumentDirectory(fileName: details?.dataId ?? ""), !InternetManager.isConnectedToInternet {
            coverImageView.image = localImage
            animateImageView(imageName: details?.dataId ?? "", isLocallyExist: true)
        } else {
            coverImageView.setImage(with: details?.planningData ?? "", placeholder: "", completion: { (image, _, _, _) in
                self.animateImageView(imageName: self.details?.dataId ?? "", isLocallyExist: !(image != nil))
            })
        }
    }
    
    func animateImageView(imageName: String, isLocallyExist: Bool) {
        coverImageView.transform = .identity
        coverImageView.contentMode = .scaleAspectFit
        UIView.animate(withDuration: 0.5, animations: {
            self.coverImageView.transform = self.coverImageView.transform.scaledBy(x: 1.05, y: 1.05)
        }, completion: { _ in
            //if !isLocallyExist {
            //self.coverImageView.image?.saveToDocuments(filename: imageName)
            //}
        })
    }
    
    func setConstraint() {
        view.addSubview(parentView)
        view.addSubview(dateLabel)
        view.addSubview(coverImageView)
        view.addSubview(dataLabel)
        
        parentView.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(10)
            make.right.equalTo(view).offset(-10)
            make.bottom.equalTo(view).offset(-10)
            make.left.equalTo(view).offset(10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(parentView.snp.top).offset(10)
            make.right.equalTo(parentView.snp.right).offset(-10)
            make.left.equalTo(parentView.snp.left).offset(10)
        }
        
        coverImageView.snp.makeConstraints { make in
            make.centerX.equalTo(parentView)
            make.centerY.equalTo(parentView)
            make.height.equalTo(parentView.snp.height).multipliedBy(0.8)
            make.width.equalTo(parentView.snp.width).multipliedBy(0.9)
        }
        
        dataLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.right.equalTo(parentView.snp.right).offset(-10)
            make.left.equalTo(parentView.snp.left).offset(10)
            make.bottom.equalTo(parentView.snp.bottom).offset(-10)
        }
    }
}
