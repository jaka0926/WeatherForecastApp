//
//  WeekTableViewCell.swift
//  WeatherForecast
//
//  Created by Jaka on 2024-07-12.
//

import UIKit
import SnapKit

class WeekTableViewCell: UITableViewCell {
    
    static let id = "WeekTableViewCell"
    let dayLabel = UILabel()
    let minTemp = UILabel()
    let maxTemp = UILabel()
    let weatherImage = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(minTemp)
        contentView.addSubview(maxTemp)
        contentView.addSubview(weatherImage)
        
        dayLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView.safeAreaLayoutGuide).offset(10)
            make.verticalEdges.equalToSuperview()
        }
        weatherImage.snp.makeConstraints { make in
            make.right.equalTo(minTemp.snp.left).offset(-20)
            make.size.equalTo(25)
            make.centerY.equalToSuperview()
        }
        minTemp.snp.makeConstraints { make in
            make.center.equalToSuperview()
            //make.verticalEdges.equalToSuperview()
        }
        maxTemp.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.verticalEdges.equalToSuperview()
        }
        
        contentView.backgroundColor = .systemIndigo
        dayLabel.font = .systemFont(ofSize: 20)
        minTemp.font = .systemFont(ofSize: 20)
        maxTemp.font = .systemFont(ofSize: 20)
        weatherImage.image = UIImage(systemName: "cloud.rain.fill")
        weatherImage.tintColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
