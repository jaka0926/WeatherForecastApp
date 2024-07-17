//
//  BottomCollectionViewCell.swift
//  WeatherForecast
//
//  Created by Jaka on 2024-07-17.
//

import UIKit
import SnapKit

class BottomCollectionViewCell: UICollectionViewCell {
    
    static let id = "BottomCollectionViewCell"
    let icon = UIImageView()
    let title = UILabel()
    let textContent = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(icon)
        contentView.addSubview(title)
        contentView.addSubview(textContent)
        
        icon.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(10)
        }
        title.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(10)
            make.centerY.equalTo(icon)
        }
        textContent.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(10)
            make.left.equalTo(icon)
        }
        
        icon.image = UIImage(systemName: "star.fill")
        title.text = "바람 속도"
        textContent.text = "1.35m/s"
        
        icon.tintColor = .lightGray
        title.textColor = .lightGray
        title.font = .boldSystemFont(ofSize: 18)
        textContent.font = .boldSystemFont(ofSize: 35)
        textContent.numberOfLines = 0
        
        contentView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        contentView.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
