//
//  SearchViewController.swift
//  WeatherForecast
//
//  Created by Jaka on 2024-07-14.
//
struct CityList : Codable {
    let id: Int
    let name: String
    let state: String
    let country: String
    var coord: Coordinations
}
struct Coordinations: Codable {
    let lon: Double
    let lat: Double
}

import UIKit
import SnapKit

class SearchViewController: BaseViewController {
    
    let cityLabel = UILabel()
    let searchField = UISearchTextField()
    let tableView = UITableView()
    var cityList: [CityList] = []
    var filteredList: [CityList] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var vc = MainViewController()
    var selected: ((CityList) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.id)
        
        cityList = loadJSON("CityList")
        tableView.rowHeight = 70
        filteredList = cityList
    }
    
    override func configureHierarchy() {
        view.addSubview(cityLabel)
        view.addSubview(searchField)
        view.addSubview(tableView)
    }
    override func configureLayout() {
        cityLabel.snp.makeConstraints { make in
            make.top.left.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        searchField.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchField.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func configureUI() {
        view.backgroundColor = .black
        cityLabel.text = "City"
        cityLabel.font = .boldSystemFont(ofSize: 30)
        
        searchField.placeholder = "Search for a city."
        searchField.textColor = .white
        searchField.addTarget(self, action: #selector(performSearch), for: .editingChanged)
        tableView.backgroundColor = .clear
        
    }
    
    func loadJSON(_ fileName: String) -> [CityList] {
        // Get the file URL
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("Failed to locate \(fileName).json in bundle.")
            return []
        }
        
        do {
            // Load the data from the file
            let data = try Data(contentsOf: url)
            
            // Decode the JSON data
            let decoder = JSONDecoder()
            let locations = try decoder.decode([CityList].self, from: data)
            
            return locations
        } catch {
            print("Failed to load or decode JSON: \(error)")
            return []
        }
    }
    @objc func performSearch() {
        
        guard let inputText = searchField.text?.lowercased(), inputText != "" else {
            filteredList = cityList
            return
        }
        var data: [CityList] = []
        
        for item in cityList {
            if item.name.lowercased().contains(inputText) || item.country.lowercased().contains(inputText) {
                data.append(item)
            }
        }
        filteredList = data
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id) as! SearchTableViewCell
        let data = filteredList[indexPath.row]
        
        cell.cityName.text = data.name
        cell.country.text = data.country
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = filteredList[indexPath.row]
        print(#function, data)
        //vc.currentWeatherData = data
        selected?(data)
        navigationController?.popViewController(animated: true)
    }
}
