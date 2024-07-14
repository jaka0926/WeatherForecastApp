//
//  SearchTableViewCell.swift
//  WeatherForecast
//
//  Created by Jaka on 2024-07-15.
//

import UIKit
import SnapKit

class SearchTableViewCell: UITableViewCell {

    static let id = "SearchTableViewCell"
    let hashtag = UIImageView(image: UIImage(systemName: "number"))
    let cityName = UILabel()
    let country = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(hashtag)
        contentView.addSubview(cityName)
        contentView.addSubview(country)
        
        hashtag.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalTo(cityName)
            make.size.equalTo(20)
        }
        cityName.snp.makeConstraints { make in
            make.left.equalTo(hashtag.snp.right).offset(10)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview().offset(-12)
        }
        country.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(cityName)
            make.centerY.equalToSuperview().offset(12)
        }
        contentView.backgroundColor = .black
        hashtag.tintColor = .white
        cityName.font = .boldSystemFont(ofSize: 18)
        country.textColor = .gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
