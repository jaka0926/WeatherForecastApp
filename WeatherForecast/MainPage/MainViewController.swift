//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Jaka on 2024-07-10.
//

import UIKit
import SnapKit

class MainViewController: BaseViewController {

    let scrollView = UIScrollView()
    let contentView = UIView()
    let regionName = UILabel()
    let currentTemp = UILabel()
    let todayView = UIView()
    let todayScrollView = UIScrollView()
    let todayContentView = UIView()
    let weekView = UIView()
    let weekScrollView = UIScrollView()
    let tabBarView = UIView()
    let todayViewTitle = UILabel()
    let weekViewTitle = UILabel()
    //let todayTableView = UITableView()
    let weekTableView = UITableView()
    let mapButton = UIButton()
    let searchButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func configureHierarchy() {
        view.addSubview(scrollView)
            scrollView.addSubview(contentView)
                contentView.addSubview(regionName)
                contentView.addSubview(currentTemp)
                contentView.addSubview(todayView)
                    todayView.addSubview(todayViewTitle)
                    todayView.addSubview(todayScrollView)
                    todayScrollView.addSubview(todayContentView)
                contentView.addSubview(weekView)
                    weekView.addSubview(weekViewTitle)
                    weekView.addSubview(weekTableView)
        view.addSubview(tabBarView)
            tabBarView.addSubview(mapButton)
            tabBarView.addSubview(searchButton)
    }
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view).offset(-60)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        regionName.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(50)
        }
        currentTemp.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(regionName.snp.bottom).offset(10)
        }
        todayView.snp.makeConstraints { make in
            make.top.equalTo(currentTemp.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(200)
        }
        weekView.snp.makeConstraints { make in
            make.top.equalTo(todayView.snp.bottom).offset(20)
            make.height.equalTo(550)
            make.horizontalEdges.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
        todayViewTitle.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(10)
        }
        todayScrollView.snp.makeConstraints { make in
            make.top.equalTo(todayViewTitle.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        todayContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.size.equalToSuperview()
        }
        weekViewTitle.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(10)
        }
        weekTableView.snp.makeConstraints { make in
            make.top.equalTo(weekViewTitle.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        tabBarView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        mapButton.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(20)
        }
        searchButton.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(20)
        }
    }
    override func configureUI() {
        contentView.backgroundColor = .systemTeal
        tabBarView.backgroundColor = .systemOrange
        
        regionName.textColor = .white
        regionName.text = "Seoul"
        regionName.font = .boldSystemFont(ofSize: 40)
        
        currentTemp.text = "23.4°"
        currentTemp.font = .boldSystemFont(ofSize: 80)
        
        todayView.backgroundColor = .brown
        todayViewTitle.backgroundColor = .systemTeal
        todayViewTitle.text = "3시간 간격의 일기예보"
        todayScrollView.backgroundColor = .systemRed
        todayContentView.backgroundColor = .systemGreen
        
        weekView.backgroundColor = .brown
        weekViewTitle.backgroundColor = .systemTeal
        weekViewTitle.text = "5일 간의 일기예보"
        weekTableView.backgroundColor = .lightGray
        
        mapButton.setImage(UIImage(systemName: "map"), for: .normal)
        searchButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
    }
}

