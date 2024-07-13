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
    let todayContentView = UIStackView()
    let weekView = UIView()
    let weekScrollView = UIScrollView()
    let tabBarView = UIView()
    let todayViewTitle = UILabel()
    let weekViewTitle = UILabel()
    //let todayTableView = UITableView()
    let weekTableView = UITableView()
    let mapButton = UIButton()
    let searchButton = UIButton()
    
    var list: [List] = []
    
    let calendar = Calendar.current
    var today: [List] = []
    var day2: [List] = []
    var day3: [List] = []
    var day4: [List] = []
    var day5: [List] = []
    lazy var dayList = [today, day2, day3, day4, day5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weekTableView.rowHeight = 50
        
        let group = DispatchGroup() //+1
        
        group.enter() //+1
        DispatchQueue.global().async(group: group) {
            OpenWeatherAPI.shared.weatherRequest(api: .weatherForecast) { json, error in
                if let error = error {
                    print(error) //사용자에게 상황 고지
                }
                else {
                    guard let data = json else {return}
                    self.list = data
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [self] in
            print("List====", self.list.count)
            self.weekTableView.reloadData()
            
            self.weekTableView.delegate = self
            self.weekTableView.dataSource = self
            self.weekTableView.register(WeekTableViewCell.self, forCellReuseIdentifier: WeekTableViewCell.id)
        
            today = self.list.filter { $0.dt_txt.contains(getDate.today) }
            day2 = self.list.filter { $0.dt_txt.contains(getDate.day2) }
            day3 = self.list.filter { $0.dt_txt.contains(getDate.day3) }
            day4 = self.list.filter { $0.dt_txt.contains(getDate.day4) }
            day5 = self.list.filter { $0.dt_txt.contains(getDate.day5) }
            
            self.addToStack()
            self.addToStack()
            self.addToStack()
            self.addToStack()
            self.addToStack()
            self.addToStack()
        }
    }
    func addToStack() {
        let label = UILabel()
        todayContentView.addArrangedSubview(label)
        label.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(100)
        }
        label.backgroundColor = .gray
        label.text = "TEST"
        
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
            make.top.equalToSuperview().offset(30)
            make.horizontalEdges.bottom.equalToSuperview()
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
            make.height.equalTo(300)
            make.horizontalEdges.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
        todayViewTitle.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(10)
            make.height.equalTo(20)
        }
        todayScrollView.snp.makeConstraints { make in
            make.top.equalTo(todayViewTitle.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        todayContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
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
        scrollView.backgroundColor = .systemTeal
        tabBarView.backgroundColor = .systemOrange
        
        regionName.textColor = .white
        regionName.text = "Seoul"
        regionName.font = .boldSystemFont(ofSize: 40)
        
        currentTemp.text = "23.4°"
        currentTemp.font = .boldSystemFont(ofSize: 80)
        
        todayView.backgroundColor = .brown
        todayViewTitle.text = "3시간 간격의 일기예보"
        todayScrollView.backgroundColor = .systemRed
        todayContentView.backgroundColor = .systemGreen
        
        weekView.backgroundColor = .brown
        weekViewTitle.text = "5일 간의 일기예보"
        weekTableView.backgroundColor = .lightGray
        
        mapButton.setImage(UIImage(systemName: "map"), for: .normal)
        searchButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        
        todayContentView.axis = .horizontal
        todayContentView.spacing = 10
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeekTableViewCell.id) as! WeekTableViewCell
        let data = dayList[indexPath.row]
        let dateString = data.first?.dt_txt
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: dateString!) else {
            print("Invalid date format")
            fatalError()
        }
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "EEEE"
        
        let day = dateFormatter.string(from: date)
        cell.dayLabel.text = day
        
        let tempData = data.map { Int($0.main.temp.rounded()) }
        print(indexPath.row, tempData)
        cell.minTemp.text = "최저 \(tempData.min()!)°"
        cell.maxTemp.text = "최고 \(tempData.max()!)°"
        
        return cell
    }
}
