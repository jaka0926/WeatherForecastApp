//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Jaka on 2024-07-10.
//

import UIKit
import SnapKit
import Kingfisher
import MapKit
//MARK: MainViewController Class
class MainViewController: BaseViewController {

    let bgImage = UIImageView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    let regionName = UILabel()
    let currentTemp = UILabel()
    let currentState = UILabel()
    let todayView = UIView()
    lazy var threeHourColView = UICollectionView(frame: .zero, collectionViewLayout: colViewLayout())
    
    func colViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let height = UIScreen.main.bounds.height
        layout.itemSize = CGSize(width: 80, height: height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = .zero
        return layout
    }
    let weekView = UIView()
    let weekScrollView = UIScrollView()
    let tabBarView = UIView()
    let todayViewTitle = UILabel()
    let weekViewTitle = UILabel()
    let weekTableView = UITableView()
    let mapButton = UIButton()
    let searchButton = UIButton()
    
    var currentWeatherData: CityList = CityList(id: 0, name: "Seoul", state: "", country: "", coord: Coordinations(lon: 127.0, lat: 37.583328))
    var list: [List] = []
    var currentList: WeatherCurrent = WeatherCurrent(weather: [], base: "", main: MainClass(temp: 0, pressure: 0, humidity: 0), wind: Wind.init(speed: 0), clouds: Clouds(all: 0), name: "")
    
    let calendar = Calendar.current
    var today: [List] = []
    var day2: [List] = []
    var day3: [List] = []
    var day4: [List] = []
    var day5: [List] = []
    lazy var dayList = [today, day2, day3, day4, day5]
    
    let locationView = UIView()
    let locationLabel = UILabel()
    var mapView = MKMapView()
    lazy var bottomColView = UICollectionView(frame: .zero, collectionViewLayout: bottomColViewLayout())
    
    func bottomColViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let width = UIScreen.main.bounds.width - 30
        print("height = ", UIScreen.main.bounds.height)
        print("width = ", UIScreen.main.bounds.width)
        layout.itemSize = CGSize(width: width/2, height: width/2)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        return layout
    }
    
//MARK: ViewWillAppear
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

                threeHourColView.reloadData()
                today = list.filter { $0.dt_txt.contains(getDate.today) }
                day2 = list.filter { $0.dt_txt.contains(getDate.day2) }
                day3 = list.filter { $0.dt_txt.contains(getDate.day3) }
                day4 = list.filter { $0.dt_txt.contains(getDate.day4) }
                day5 = list.filter { $0.dt_txt.contains(getDate.day5) }
                dayList = [today, day2, day3, day4, day5]
                weekTableView.reloadData()
                bottomColView.reloadData()
                configureMapView()
            }
        }
        
    }
//MARK: ViewDidLoad
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
                self.threeHourColView.delegate = self
                self.threeHourColView.dataSource = self
                self.threeHourColView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.id)
                
                self.weekTableView.delegate = self
                self.weekTableView.dataSource = self
                self.weekTableView.register(WeekTableViewCell.self, forCellReuseIdentifier: WeekTableViewCell.id)
                
                self.bottomColView.delegate = self
                self.bottomColView.dataSource = self
                self.bottomColView.register(BottomCollectionViewCell.self, forCellWithReuseIdentifier: BottomCollectionViewCell.id)
            }
        }
        
        navigationController?.isToolbarHidden = false
        let toolBar = UIToolbarAppearance()
        toolBar.backgroundColor = .darkGray.withAlphaComponent(0.5)
        navigationController?.toolbar.scrollEdgeAppearance = toolBar
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let mapButton = UIBarButtonItem(image: UIImage(systemName: "map"), style: .plain, target: self, action: #selector(mapButtonTapped))
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(searchButtonTapped))
        toolbarItems = [mapButton, flexibleSpace, searchButton]
    }
    @objc private func mapButtonTapped(){
//        let vc = MapViewController()
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func searchButtonTapped(){
        let vc = SearchViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
//MARK: configureHierarchy
    override func configureHierarchy() {
        view.addSubview(bgImage)
        view.addSubview(scrollView)
            scrollView.addSubview(contentView)
                contentView.addSubview(regionName)
                contentView.addSubview(currentTemp)
                contentView.addSubview(currentState)
                contentView.addSubview(todayView)
                    todayView.addSubview(todayViewTitle)
                    todayView.addSubview(threeHourColView)
                contentView.addSubview(weekView)
                    weekView.addSubview(weekViewTitle)
                    weekView.addSubview(weekTableView)
                contentView.addSubview(locationView)
                    locationView.addSubview(mapView)
                    locationView.addSubview(locationLabel)
                contentView.addSubview(bottomColView)
    }
//MARK: configureLayout
    override func configureLayout() {
        bgImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-80)
        }
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView).offset(10)
            make.horizontalEdges.bottom.equalTo(scrollView)
            make.width.equalToSuperview()
        }
        regionName.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
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
        threeHourColView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        weekViewTitle.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(10)
            make.height.equalTo(20)
        }
        weekTableView.snp.makeConstraints { make in
            make.top.equalTo(weekViewTitle.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        locationView.snp.makeConstraints { make in
            make.top.equalTo(weekView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(300)
        }
        locationLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(10)
        }
        mapView.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalToSuperview().inset(10)
        }
        bottomColView.snp.makeConstraints { make in
            make.top.equalTo(locationView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(locationView)
            make.height.equalTo(bottomColView.snp.width)
            make.bottom.equalToSuperview().inset(10)
        }
    }
//MARK: configureUI
    override func configureUI() {
        
        bgImage.image = UIImage(named: "bgImage")
        bgImage.contentMode = .scaleAspectFill
        scrollView.backgroundColor = .black.withAlphaComponent(0.5)
        tabBarView.backgroundColor = .systemOrange
        
        regionName.textColor = .white
        regionName.font = .boldSystemFont(ofSize: 40)
        
        currentTemp.text = ""
        currentTemp.font = .boldSystemFont(ofSize: 80)
        
        currentState.text = ""
        currentState.font = .boldSystemFont(ofSize: 20)
        
        todayView.layer.cornerRadius = 10
        todayView.layer.borderColor = UIColor.white.cgColor
        todayView.layer.borderWidth = 1
        todayView.clipsToBounds = true
        todayView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        todayViewTitle.text = "3시간 간격의 일기예보"
        threeHourColView.backgroundColor = .clear
        
        weekViewTitle.text = "5일 간의 일기예보"
        weekView.layer.cornerRadius = 10
        weekView.layer.borderWidth = 1
        weekView.layer.borderColor = UIColor.white.cgColor
        weekView.clipsToBounds = true
        weekView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        weekTableView.backgroundColor = .clear
        
        mapButton.setImage(UIImage(systemName: "map"), for: .normal)
        searchButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        
        locationView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        locationView.layer.cornerRadius = 10
        locationView.layer.borderWidth = 1
        locationView.layer.borderColor = UIColor.white.cgColor
        locationView.clipsToBounds = true
        locationLabel.text = "위치"
        
        bottomColView.backgroundColor = .clear
        
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
//MARK: TableView
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
            return cell
        }
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "E"
        
        let day = dateFormatter.string(from: date)
        cell.dayLabel.text = indexPath.row == 0 ? "오늘" : day
        
        let tempData = data.map { Int($0.main.temp.rounded()) }
        cell.minTemp.text = "최저 \(tempData.min()!)°"
        cell.maxTemp.text = "최고 \(tempData.max()!)°"
        
        let icon = data.first?.weather.first?.icon
        let url = URL(string: "https://openweathermap.org/img/wn/\(icon!)@2x.png")
        cell.weatherImage.kf.setImage(with: url)
        
        return cell
    }
}
//MARK: CollectionView
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionView == threeHourColView ? list.count : 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == bottomColView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCollectionViewCell.id, for: indexPath) as! BottomCollectionViewCell
            lazy var data: [String] = ["", "", ""]
            
            switch indexPath.row {
            case 0: data = ["wind", "바람 속도", "\(currentList.wind.speed)m/s"]
            case 1: data = ["drop.fill", "구름", "\(currentList.clouds.all)%"]
            case 2: data = ["thermometer.medium", "기압", "\(currentList.main.pressure)\nhpa"]
            case 3: data = ["humidity.fill", "습도", "\(currentList.main.humidity)%"]
            default: print("Bottom ColView Error")
            }
            cell.icon.image = UIImage(systemName: data[0])
            cell.title.text = data[1]
            cell.textContent.text = data[2]
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.id, for: indexPath) as! CollectionViewCell
        let data = list[indexPath.row]
        
        let rawDate = data.dt_txt
        let startIndex = rawDate.index(rawDate.startIndex, offsetBy: 11)
        let endIndex = rawDate.index(rawDate.startIndex, offsetBy: 13)
        let hourSubstring = rawDate[startIndex..<endIndex]
        

        cell.colCelltime.text = "\(hourSubstring)시"
        let icon = data.weather.first?.icon
        let url = URL(string: "https://openweathermap.org/img/wn/\(icon!)@2x.png")
        
        cell.colCellweatherIcon.kf.setImage(with: url)
        cell.colCelltemp.text = "\(Int(data.main.temp.rounded()))°"
        
        return cell
    }
    
}
