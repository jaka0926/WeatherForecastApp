//
//  threeHourCollectionViewCell.swift
//  WeatherForecast
//
//  Created by Jaka on 2024-07-16.
//

import UIKit
import SnapKit

class CollectionViewCell: UICollectionViewCell {
    
    static let id = "threeHourCollectionViewCell"
    let colCelltime = UILabel()
    let colCellweatherIcon = UIImageView()
    let colCelltemp = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(colCelltime)
        contentView.addSubview(colCellweatherIcon)
        contentView.addSubview(colCelltemp)
        
        colCelltime.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
        colCellweatherIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(70)
        }
        colCelltemp.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(50)
        }
        
        contentView.backgroundColor = .clear
        colCelltemp.font = .systemFont(ofSize: 16)
        colCelltemp.font = .boldSystemFont(ofSize: 18)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
