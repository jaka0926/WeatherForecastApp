//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Jaka on 2024-07-10.
//

import UIKit
import SnapKit

class MainViewController: BaseViewController {

    let regionName = UILabel()
    let currentTemp = UILabel()
    let todayView = UIView()
    let weekView = UIView()
    let todayViewTitle = UILabel()
    let weekViewTitle = UILabel()
    let todayTableView = UITableView()
    let weekTableView = UITableView()
    let mapButton = UIButton()
    let searchButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func configureHierarchy() {
        view.addSubview(regionName)
        view.addSubview(currentTemp)
        view.addSubview(todayView)
        view.addSubview(weekView)
        todayView.addSubview(todayViewTitle)
        todayView.addSubview(todayTableView)
        weekView.addSubview(weekViewTitle)
        weekView.addSubview(weekTableView)
        view.addSubview(mapButton)
        view.addSubview(searchButton)
    }
    override func configureLayout() {
        regionName.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
        }
        currentTemp.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(regionName.snp.bottom).offset(10)
        }
        todayView.snp.makeConstraints { make in
            make.top.equalTo(currentTemp.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(200)
        }
        weekView.snp.makeConstraints { make in
            make.top.equalTo(todayView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(250)
        }
        todayViewTitle.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(10)
        }
        todayTableView.snp.makeConstraints { make in
            make.top.equalTo(todayViewTitle.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        weekViewTitle.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(10)
        }
        weekTableView.snp.makeConstraints { make in
            make.top.equalTo(weekViewTitle.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        mapButton.snp.makeConstraints { make in
            make.left.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        searchButton.snp.makeConstraints { make in
            make.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    override func configureUI() {
        view.backgroundColor = .darkGray
        regionName.textColor = .white
        regionName.text = "Seoul"
        regionName.font = .boldSystemFont(ofSize: 40)
        
        currentTemp.textColor = .white
        currentTemp.text = "23.4°"
        currentTemp.font = .boldSystemFont(ofSize: 80)
        
        todayView.backgroundColor = .brown
        todayViewTitle.backgroundColor = .systemTeal
        todayViewTitle.textColor = .white
        todayViewTitle.text = "3시간 간격의 일기예보"
        todayTableView.backgroundColor = .lightGray
        
        weekView.backgroundColor = .brown
        weekViewTitle.backgroundColor = .systemTeal
        weekViewTitle.textColor = .white
        weekViewTitle.text = "5일 간의 일기예보"
        weekTableView.backgroundColor = .lightGray
        
        mapButton.setImage(UIImage(systemName: "map"), for: .normal)
        mapButton.tintColor = .white
        searchButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        searchButton.tintColor = .white
    }
}

