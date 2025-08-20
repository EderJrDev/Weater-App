//
//  WeatherViewModel.swift
//  Weater App
//
//  Created by Eder Junior Alves Silva on 18/08/25.
//

import Foundation
import UIKit

struct HourlyForecastViewModel {
    let hour: String
    let icon: UIImage?
    let temperature: String
}

// MARK: - Protocols
protocol WeatherViewModelProtocol {
    var cityName: String { get }
    var temperature: String { get }
    var humidity: String { get }
    var windSpeed: String { get }
    var backgroundImage: UIImage? { get }
    var weatherIcon: UIImage? { get }
    
    var hourlyForecasts: [HourlyForecastViewModel] { get }
    var dailyForecasts: [DailyForecast] { get }
    
    var onDataUpdate: (() -> Void)? { get set }
    
    func fetchData()
}


class WeatherViewModel: WeatherViewModelProtocol {
    // MARK: - Properties
    
    var cityName: String = "..."
    var temperature: String = "..."
    var humidity: String = "..."
    var windSpeed: String = "..."
    var backgroundImage: UIImage?
    var weatherIcon: UIImage?
    
    var hourlyForecasts: [HourlyForecastViewModel] = []
    var dailyForecasts: [DailyForecast] = []

    var onDataUpdate: (() -> Void)?
    
    // MARK: - Private Properties
    private let service: Service
    private var city = City(lat: "-23.5505", lon: "-46.633", name: "São Paulo")
    private var forecastResponse: CurrentWeatherData?
    
    // MARK: - Initializer
    init(service: Service = Service()) {
        self.service = service
    }
    
    // MARK: - Public Methods
    
    func fetchData() {
        service.fetchData(city: city) { [weak self] response in
            guard let self = self else { return }
            self.forecastResponse = response
            self.formatCurrentWeatherData()
            
            DispatchQueue.main.async {
                self.onDataUpdate?()
            }
        }
        
        service.fetchForecastData(city: city) { [weak self] forecastData in
            guard let self = self, let data = forecastData else { return }
            
            self.hourlyForecasts = data.list.map { forecastItem in
                          return HourlyForecastViewModel(
                              hour: forecastItem.dt.toHourFormat(),
                              icon: self.mapWeatherIcon(from: forecastItem.weather.first?.icon),
                              temperature: forecastItem.main.temp.toCelsius()
                          )
                      }
            self.dailyForecasts = self.groupForecastsByDay(from: data.list)
            
            DispatchQueue.main.async {
                self.onDataUpdate?()
            }
        }
    }
    
    // MARK: - Private Logic
    private func formatCurrentWeatherData() {
        guard let response = forecastResponse else { return }
        
        cityName = city.name
        temperature = "\(Int(response.main.temp))°C"
        humidity = "\(Int(response.main.humidity)) mm"
        windSpeed = "\(Int(response.wind.speed)) km/h"
        
        if response.dt.isDayTime() {
            backgroundImage = UIImage(named: "background-day")
            weatherIcon = UIImage(named: "sumIcon")
        } else {
            backgroundImage = UIImage(named: "background-night")
            weatherIcon = UIImage(named: "moonIcon")
        }
    }
    
    private func mapWeatherIcon(from iconCode: String?) -> UIImage? {
          guard let iconCode = iconCode else { return UIImage(named: "sunIcon") }

          switch iconCode {
              case "01d":
                  return UIImage(named: "sunIcon")
              case "01n":
                  return UIImage(named: "moonIcon")
              default:
                  return UIImage(named: "sunIcon")
          }
      }

    private func groupForecastsByDay(from list: [ForecastListItem]) -> [DailyForecast] {
        var forecastsByDay = [String: [ForecastListItem]]()
        
        for forecast in list {
            let dateKey = String(forecast.dtTxt.prefix(10))
            if forecastsByDay[dateKey] == nil {
                forecastsByDay[dateKey] = []
            }
            forecastsByDay[dateKey]?.append(forecast)
        }
        
        var dailyForecasts: [DailyForecast] = []
        let sortedDays = forecastsByDay.keys.sorted()
        
        for dayKey in sortedDays {
            guard let dayForecasts = forecastsByDay[dayKey] else { continue }
            
            var minTemp = Double.greatestFiniteMagnitude
            var maxTemp = -Double.greatestFiniteMagnitude
            
            for forecast in dayForecasts {
                minTemp = min(minTemp, forecast.main.tempMin)
                maxTemp = max(maxTemp, forecast.main.tempMax)
            }
            
            let dayName = dayForecasts.first?.dt.toDayOfWeek() ?? ""
            let icon = dayForecasts.first?.weather.first?.icon ?? ""
            
            dailyForecasts.append(DailyForecast(day: dayName, minTemp: minTemp, maxTemp: maxTemp, icon: icon))
        }
        
        return dailyForecasts
    }
}
