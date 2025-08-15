//
//  ViewController.swift
//  Weater App
//
//  Created by Eder Junior Alves Silva on 27/07/25.
//

import UIKit

class ViewController: UIViewController {
    private lazy var backgroundView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.contrastColor
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.primaryColor
        return label
    }()
    
    private lazy var tempatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 70, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = UIColor.primaryColor
        return label
    }()
    
    private lazy var weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "sunIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var humidityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Umidade"
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.contrastColor
        
        return label
    }()
    
    private lazy var humidityValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.contrastColor
        
        return label
    }()
    
    private lazy var humidityStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [humidityLabel, humidityValueLabel])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints  = false
        return stackView
    }()
    
    private lazy var windLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Vento"
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.contrastColor
        
        return label
    }()
    
    private lazy var windValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.contrastColor
        
        return label
    }()
    
    private lazy var windStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [windLabel, windValueLabel])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints  = false
        return stackView
    }()
    
    private lazy var statsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [humidityStackView, windStackView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints  = false
        stackView.spacing = 3
        stackView.backgroundColor = UIColor.appSoftGray
        stackView.layer.cornerRadius = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 12,
            leading: 24,
            bottom: 12,
            trailing: 24)
        return stackView
    }()
    
    private lazy var hourlyForecastLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.contrastColor
        label.text = "PREVISAO POR HORA"
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var hourlyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 67, height: 84)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.register(HouryForecastCollectionViewCell.self,
                                forCellWithReuseIdentifier: HouryForecastCollectionViewCell.identifier)
        return collectionView
    }()
        
    private lazy var dailyForecastLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = UIColor.contrastColor
            label.text = "PROXIMOS DIAS"
            label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
            label.textAlignment = .center
            return label
    }()
        
    private lazy var dailyForecastTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DailyForecastTableViewCell.self, forCellReuseIdentifier: DailyForecastTableViewCell.identifier)
        return tableView
    }()
    
    // Coloque esta função dentro do seu ViewController
    private func groupForecastsByDay(from list: [ForecastListItem]) -> [DailyForecast] {
        // 1. Usamos um Dicionário para agrupar as previsões.
        // A chave será a data (ex: "2025-08-15") e o valor será uma lista de previsões para aquele dia.
        var forecastsByDay = [String: [ForecastListItem]]()

        // 2. Passamos por cada item da lista que veio da API.
        for forecast in list {
            // Pegamos a data (ex: "2025-08-15 18:00:00") e pegamos só a parte da data.
            let dateKey = String(forecast.dtTxt.prefix(10))
            
            // Se ainda não temos um "montinho" para essa data, criamos um.
            if forecastsByDay[dateKey] == nil {
                forecastsByDay[dateKey] = []
            }
            
            // Adicionamos a previsão ao seu "montinho" diário correspondente.
            forecastsByDay[dateKey]?.append(forecast)
        }

        // 3. Agora que temos os montinhos, vamos processá-los para encontrar o min/max.
        var dailyForecasts: [DailyForecast] = []
        
        // Pegamos as chaves do dicionário (as datas) e as ordenamos.
        let sortedDays = forecastsByDay.keys.sorted()

        for dayKey in sortedDays {
            // Pegamos a lista de previsões para um dia específico.
            guard let dayForecasts = forecastsByDay[dayKey] else { continue }
            
            // Começamos com valores "impossíveis" para garantir que qualquer temperatura da API será menor/maior.
            var minTemp = Double.greatestFiniteMagnitude
            var maxTemp = -Double.greatestFiniteMagnitude
            
            // Passamos por cada previsão daquele dia para achar a mínima e a máxima.
            for forecast in dayForecasts {
                if forecast.main.tempMin < minTemp {
                    minTemp = forecast.main.tempMin
                }
                if forecast.main.tempMax > maxTemp {
                    maxTemp = forecast.main.tempMax
                }
            }
            
            // Criamos nosso objeto final de previsão diária.
            // Aqui, pegamos o ícone e a data da previsão do meio-dia para representar o dia.
            let  dayName = dayForecasts.first?.dt.toDayOfWeek() ?? ""
            let icon = dayForecasts.first?.weather.first?.icon ?? ""
            
            dailyForecasts.append(DailyForecast(day: dayName, minTemp: minTemp, maxTemp: maxTemp, icon: icon))
        }
        
        return dailyForecasts
    }
    
    private let service = Service()
    private var city = City(lat: "-23.5505", lon: "-46.633", name: "São Paulo")
    private var forecastResponse: CurrentWeatherData?
    private var hourlyForecasts: [ForecastListItem] = []
    private var dailyForecasts: [DailyForecast] = []


    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupView()
        fetchData()
    }
    
    private func fetchData() {
        service.fetchData(city: city) { [weak self] response in
            self?.forecastResponse = response
            DispatchQueue.main.async {
                self?.loadData()
            }
        }
        
        service.fetchForecastData(city: city) {[weak self] ForecastData in
            if let data = ForecastData {
                self?.hourlyForecasts = data.list
                
                self?.dailyForecasts = self?.groupForecastsByDay(from: data.list) ?? []
                
                DispatchQueue.main.async {
                    self?.hourlyCollectionView.reloadData()
                    
                    self?.dailyForecastTableView.reloadData()
                }
            }

        }
    }
    
    private func loadData() {
        cityLabel.text = city.name
        
        tempatureLabel.text = "\(Int(forecastResponse?.main.temp ?? 0)) °C"
        humidityValueLabel.text = "\(Int(forecastResponse?.main.humidity ?? 0)) mm"
        windValueLabel.text = "\(Int(forecastResponse?.wind.speed ?? 0)) km/h"
       
        if forecastResponse?.dt.isDayTime() ?? true {
            backgroundView.image = UIImage(named: "background-day")
        } else {
            backgroundView.image = UIImage(named: "background-night")
        }
    }
    
    private func setupView() {
        view.backgroundColor = .clear
        setHierarchy()
        setContraints()
    }
    
    private func setHierarchy() {
        view.addSubview(backgroundView)
        view.addSubview(headerView)
        view.addSubview(statsStackView)
        view.addSubview(hourlyForecastLabel)
        view.addSubview(hourlyCollectionView)
        view.addSubview(dailyForecastLabel)
        view.addSubview(dailyForecastTableView)
        
        headerView.addSubview(cityLabel)
        headerView.addSubview(tempatureLabel)
        headerView.addSubview(weatherIcon)
    }

    private func setContraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
      
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            headerView.heightAnchor.constraint(equalToConstant: 150)
        ])
      
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 15),
            cityLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            cityLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
            cityLabel.heightAnchor.constraint(equalToConstant: 20),
            tempatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 12),
            tempatureLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 18),
            tempatureLabel.heightAnchor.constraint(equalToConstant: 71),
            weatherIcon.heightAnchor.constraint(equalToConstant: 86),
            weatherIcon.widthAnchor.constraint(equalToConstant: 86),
            weatherIcon.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -18),
            weatherIcon.centerYAnchor.constraint(equalTo: tempatureLabel.centerYAnchor),
            weatherIcon.leadingAnchor.constraint(equalTo: tempatureLabel.trailingAnchor, constant: 8)
        ])
      
        NSLayoutConstraint.activate([
            statsStackView.topAnchor.constraint(equalTo:
                headerView.bottomAnchor, constant: 24),
            statsStackView.widthAnchor.constraint(equalToConstant: 206),
            statsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
      
        NSLayoutConstraint.activate([
            hourlyForecastLabel.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: 29),
            hourlyForecastLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            hourlyForecastLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            hourlyCollectionView.topAnchor.constraint(equalTo: hourlyForecastLabel.bottomAnchor, constant: 22),
            hourlyCollectionView.heightAnchor.constraint(equalToConstant: 84),
            hourlyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hourlyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dailyForecastLabel.topAnchor.constraint(equalTo:
                    hourlyCollectionView.bottomAnchor, constant: 29),
            dailyForecastLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                    constant: 35),
            dailyForecastLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                    constant: -35),
            dailyForecastTableView.topAnchor.constraint(equalTo:
                    dailyForecastLabel.bottomAnchor, constant: 16),
            dailyForecastTableView.trailingAnchor.constraint(equalTo:
                    view.trailingAnchor),
            dailyForecastTableView.leadingAnchor.constraint(equalTo:
                    view.leadingAnchor),
            dailyForecastTableView.bottomAnchor.constraint(equalTo:
                    view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyForecasts.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HouryForecastCollectionViewCell.identifier, for: indexPath) as? HouryForecastCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let forecast = hourlyForecasts[indexPath.row]
        
        cell.loadData(time: forecast.dt.toHourFormat(),
                      icon: UIImage(named: "sunIcon"),
                      temp: forecast.main.temp.toCelsius())
        return cell
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dailyForecasts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyForecastTableViewCell.identifier, for: indexPath) as? DailyForecastTableViewCell else {
            return UITableViewCell()
        }
        
        let forecast = dailyForecasts[indexPath.row]
        
        cell.loadData(weekDay: forecast.day,
                      min: forecast.minTemp.toCelsius(),
                      max: forecast.minTemp.toCelsius(),
                      icon:  UIImage(named: forecast.icon ?? ""))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) ->
        CGFloat {
            60
    }
}
