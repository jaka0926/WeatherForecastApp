//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Jaka on 2024-07-10.
//

import UIKit
import SnapKit
import MapKit

class MainViewController: BaseViewController {

    let scrollView = UIScrollView()
    let contentView = UIView()
    let regionName = UILabel()
    let currentTemp = UILabel()
    let currentState = UILabel()
    let todayView = UIView()
    let todayScrollView = UIScrollView()
    let todayContentView = UIStackView()
    let weekView = UIView()
    let weekScrollView = UIScrollView()
    let tabBarView = UIView()
    let todayViewTitle = UILabel()
    let weekViewTitle = UILabel()
    let weekTableView = UITableView()
    let mapButton = UIButton()
    let searchButton = UIButton()
    var mapView = MKMapView()
    
    var currentWeatherData: CityList = CityList(id: 0, name: "Seoul", state: "", country: "", coord: Coordinations(lon: 127.0, lat: 37.583328))
    var list: [List] = []
    var currentList: WeatherCurrent = WeatherCurrent(weather: [], main: MainClass(temp: 0))
    
    let calendar = Calendar.current
    var today: [List] = []
    var day2: [List] = []
    var day3: [List] = []
    var day4: [List] = []
    var day5: [List] = []
    lazy var dayList = [today, day2, day3, day4, day5]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentLat = currentWeatherData.coord.lat
        let currentLon = currentWeatherData.coord.lon
        
        DispatchQueue.global().async {
            OpenWeatherAPI.shared.weatherCurrentRequest(api: .weatherCurrent(lat: currentLat, lon: currentLon)) { [self] json, error in
                if let error = error {
                    print(error) //사용자에게 상황 고지
                }
                else {
                    guard let data = json else {return}
                    currentList = data
                }
                regionName.text = self.currentWeatherData.name
                currentTemp.text = String(format: "%.0f", self.currentList.main.temp.rounded()) + "°"
                currentState.text = currentList.weather.first?.description
            }
            
            OpenWeatherAPI.shared.weatherForecastRequest(api: .weatherForecast(lat: currentLat, lon: currentLon)) { [self] json, error in
                
                if let error = error {
                    print(error) //사용자에게 상황 고지
                }
                else {
                    guard let data = json else {return}
                    list = data
                }
                for data in list {
                    dump(data)
                    
                    self.addToStack(data)
                }
                
                today = list.filter { $0.dt_txt.contains(getDate.today) }
                day2 = list.filter { $0.dt_txt.contains(getDate.day2) }
                day3 = list.filter { $0.dt_txt.contains(getDate.day3) }
                day4 = list.filter { $0.dt_txt.contains(getDate.day4) }
                day5 = list.filter { $0.dt_txt.contains(getDate.day5) }
                dayList = [today, day2, day3, day4, day5]
                weekTableView.reloadData()
                
                configureMapView()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        weekTableView.rowHeight = 50
    
        DispatchQueue.global().async {
            OpenWeatherAPI.shared.weatherForecastRequest(api: .weatherForecast(lat: 37.583328, lon: 127.0)) { json, error in
                if let error = error {
                    print(error) //사용자에게 상황 고지
                }
                else {
                    guard let data = json else {return}
                    self.list = data
                }
                self.weekTableView.delegate = self
                self.weekTableView.dataSource = self
                self.weekTableView.register(WeekTableViewCell.self, forCellReuseIdentifier: WeekTableViewCell.id)
            }
        }
    }
    func addToStack(_ listItem: List) {
        let singleView = UIView()
        let time = UILabel()
        let weatherIcon = UIImageView()
        let temp = UILabel()
        singleView.addSubview(time)
        singleView.addSubview(weatherIcon)
        singleView.addSubview(temp)
        todayContentView.addArrangedSubview(singleView)
        
        singleView.snp.makeConstraints { make in
            make.width.equalTo(70)
        }
        time.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.horizontalEdges.equalToSuperview()
        }
        weatherIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(40)
        }
        temp.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        let rawDate = listItem.dt_txt
        let startIndex = rawDate.index(rawDate.startIndex, offsetBy: 11)
        let endIndex = rawDate.index(rawDate.startIndex, offsetBy: 13)
        let hourSubstring = rawDate[startIndex..<endIndex]
        time.text = "\(hourSubstring)시"
        time.textAlignment = .center
        weatherIcon.image = UIImage(systemName: "sun.max.fill")
        weatherIcon.tintColor = .white
        temp.text = "\(Int(listItem.main.temp.rounded()))°"
        temp.font = .boldSystemFont(ofSize: 18)
        
    }
    override func configureHierarchy() {
        view.addSubview(scrollView)
            scrollView.addSubview(contentView)
                contentView.addSubview(regionName)
                contentView.addSubview(currentTemp)
                contentView.addSubview(currentState)
                contentView.addSubview(todayView)
                    todayView.addSubview(todayViewTitle)
                    todayView.addSubview(todayScrollView)
                    todayScrollView.addSubview(todayContentView)
                contentView.addSubview(weekView)
                    weekView.addSubview(weekViewTitle)
                    weekView.addSubview(weekTableView)
                contentView.addSubview(mapView)
        view.addSubview(tabBarView)
            tabBarView.addSubview(mapButton)
            tabBarView.addSubview(searchButton)
    }
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-60)
        }
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView).offset(10)
            make.horizontalEdges.bottom.equalTo(scrollView)
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
        currentState.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(currentTemp.snp.bottom).offset(5)
        }
        todayView.snp.makeConstraints { make in
            make.top.equalTo(currentState.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(200)
        }
        weekView.snp.makeConstraints { make in
            make.top.equalTo(todayView.snp.bottom).offset(20)
            make.height.equalTo(290)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
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
            make.height.equalTo(20)
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
        mapView.snp.makeConstraints { make in
            make.top.equalTo(weekView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(300)
            make.bottom.equalTo(contentView).offset(-10)
        }
    }
    override func configureUI() {
        scrollView.backgroundColor = .systemIndigo
        tabBarView.backgroundColor = .systemOrange
        
        regionName.textColor = .white
        //regionName.text = "Seoul"
        regionName.font = .boldSystemFont(ofSize: 40)
        
        currentTemp.text = ""
        currentTemp.font = .boldSystemFont(ofSize: 80)
        
        currentState.text = ""
        currentState.font = .boldSystemFont(ofSize: 20)
        
        todayView.layer.cornerRadius = 10
        todayView.layer.borderColor = UIColor.white.cgColor
        todayView.layer.borderWidth = 1
        todayView.clipsToBounds = true
        todayContentView.backgroundColor = .systemTeal
        todayViewTitle.text = "3시간 간격의 일기예보"
        
        weekViewTitle.text = "5일 간의 일기예보"
        weekView.layer.cornerRadius = 10
        weekView.layer.borderWidth = 1
        weekView.layer.borderColor = UIColor.white.cgColor
        weekView.clipsToBounds = true
        
        mapButton.setImage(UIImage(systemName: "map"), for: .normal)
        searchButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        
        todayContentView.axis = .horizontal
        todayContentView.spacing = 10
        
        searchButton.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
    }
    func configureMapView() {
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: currentWeatherData.coord.lat, longitude: currentWeatherData.coord.lon)
        annotation.coordinate = coordinate
        annotation.title = currentWeatherData.name
        mapView.addAnnotation(annotation)
        mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)), animated: true)
    }
    @objc func searchButtonClicked() {
        let vc = SearchViewController()
        vc.selected = { data in
            self.currentWeatherData = data
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeekTableViewCell.id) as! WeekTableViewCell
        let data = dayList[indexPath.row]
        let dateString = data.first?.dt_txt ?? ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: dateString) else {
            print("Invalid date format")
            //fatalError()
            return cell
        }
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "E"
        
        let day = dateFormatter.string(from: date)
        cell.dayLabel.text = indexPath.row == 0 ? "오늘" : day
        
        let tempData = data.map { Int($0.main.temp.rounded()) }
        cell.minTemp.text = "최저 \(tempData.min()!)°"
        cell.maxTemp.text = "최고 \(tempData.max()!)°"
        
        return cell
    }
}
