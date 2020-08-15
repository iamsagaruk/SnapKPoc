//
//  TableViewCell.swift
//  SnapkitPoc
//
//  Created by Sagar on 14/08/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import UIKit
import SnapKit

class TableViewCell: UITableViewCell {
    
    let customImageView = UIImageView()
    let titleTextLabel = UILabel()
    let dateTextLabel = UILabel()
    let customArrowImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleTextLabel.numberOfLines = 0
        dateTextLabel.textColor = .red

        customArrowImageView.image = UIImage(named: "ico_arrow_fwd_b")
        dateTextLabel.font = UIFont.systemFont(ofSize: 11)
        customImageView.layer.cornerRadius = 10
        customImageView.contentMode = .scaleAspectFit
        
        contentView.addSubview(customArrowImageView)
        contentView.addSubview(customImageView)
        contentView.addSubview(titleTextLabel)
        contentView.addSubview(dateTextLabel)
        contentView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)

        dateTextLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(contentView.snp.top).offset(10)
            make.right.equalTo(contentView.snp.right)
            make.left.equalTo(contentView.snp.left).offset(10)
        }
        
        customImageView.snp.makeConstraints { make in
            make.top.equalTo(dateTextLabel.snp.bottom).offset(10)
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
        
        customArrowImageView.snp.makeConstraints { make in
            make.width.equalTo(15)
            make.height.equalTo(10)
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
        
        titleTextLabel.snp.makeConstraints { make in
            make.top.equalTo(dateTextLabel.snp.bottom).offset(10)
            make.right.equalTo(customArrowImageView.snp.right).offset(-20)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
            make.left.equalTo(contentView.snp.left).offset(10)
        }
    }
    
    func setData(details: PlanningDataResponse) {
        switch SortType(rawValue: details.type ?? "") {
        case .image:
            customImageView.isHidden = false
            titleTextLabel.isHidden = true
            setCoverImageView(dataImage: details.planningData ?? "", imageName: details.dataId ?? "")
            dateTextLabel.textAlignment = .center
        default:
            customImageView.isHidden = true
            titleTextLabel.isHidden = false
            titleTextLabel.text = isDataAvailable(details) ? "Not available" : details.planningData
            dateTextLabel.textAlignment = .left
        }
        customArrowImageView.isHidden = isDataAvailable(details)
        dateTextLabel.text = "Date: \(details.date ?? "Not available")"
    }
    
    func isDataAvailable(_ details: PlanningDataResponse) -> Bool {
        return details.planningData?.isEmpty ?? true
    }
    
    func setCoverImageView(dataImage: String, imageName: String) {
        if let localImage = loadImageFromDocumentDirectory(fileName: imageName), !InternetManager.isConnectedToInternet {
            customImageView.image = localImage
            animateImageView(imageName: imageName, isImageDownloaded: true)
        } else {
            customImageView.setImage(with: dataImage, placeholder: "", completion: { (image, _, _, _) in
                if image != nil {
                    self.animateImageView(imageName: imageName, isImageDownloaded: image != nil)
                } else {
                    self.customImageView.image = UIImage(named: "placeholder")
                }
            })
        }
    }
    
    func animateImageView(imageName: String, isImageDownloaded: Bool) {
        customImageView.transform = .identity
        UIView.animate(withDuration: 0.5, animations: {
            self.customImageView.transform = self.customImageView.transform.scaledBy(x: 1.05, y: 1.05)
        }, completion: { _ in
            if !isImageDownloaded {
                self.customImageView.image?.saveToDocuments(filename: imageName)
            }
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
