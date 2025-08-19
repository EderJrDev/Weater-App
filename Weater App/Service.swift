//
//  Service.swift
//  Weater App
//
//  Created by Eder Junior Alves Silva on 14/08/25.
//

import Foundation

struct City {
    let lat: String
    let lon: String
    let name: String
}

class Service {
    private let baseURL: String = "https://api.openweathermap.org/data/2.5/weather"
    private let apiKey: String = "8f8b00810a0f32122a8217877d806d95"
//    private let apiKey = APIKeyManager.openWeatherMap
    private let session = URLSession.shared
    
    func fetchData(city: City, _ completion: @escaping (CurrentWeatherData?) -> Void) {
        let urlString = "\(baseURL)?lat=\(city.lat)&lon=\(city.lon)&appid=\(apiKey)&units=metric&lang=pt_br"
        
        guard let url = URL(string: urlString) else {
            print("Erro: URL inválida.")
            completion(nil)
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Erro na requisição: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Erro: Nenhum dado recebido.")
                completion(nil)
                return
            }
            
            do {
                let weatherData = try JSONDecoder().decode(CurrentWeatherData.self, from: data)
                completion(weatherData)
            } catch {
                print("Erro ao decodificar JSON: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON recebido: \(jsonString)")
                }
                completion(nil)
            }
        }
        
        task.resume()
    }
        
        let baseURLForecast = "https://api.openweathermap.org/data/2.5/forecast"
        
        func fetchForecastData(city: City, _ completion: @escaping (ForecastData?) -> Void) {
            
            let urlStringForecast = "\(baseURLForecast)?lat=\(city.lat)&lon=\(city.lon)&appid=\(apiKey)&units=metric&lang=pt_br"
            
            
            guard let url = URL(string: urlStringForecast) else {
                print("Erro: URL inválida.")
                completion(nil)
                return
            }
            
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Erro na requisição: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let data = data else {
                    print("Erro: Nenhum dado recebido.")
                    completion(nil)
                    return
                }
                
                do {
                    let weatherData = try JSONDecoder().decode(ForecastData.self, from: data)
                    completion(weatherData)
                } catch {
                    print("Erro ao decodificar JSON: \(error)")
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("JSON recebido: \(jsonString)")
                    }
                    completion(nil)
                }
                
            }
            
            task.resume()
        }
    }
    
    
    // MARK: - NOVOS MODELOS DE DADOS PARA A API
    
    struct CurrentWeatherData: Codable {
        let coord: Coord
        let weather: [Weather]
        let base: String
        let main: Main
        let visibility: Int
        let wind: Wind
        let clouds: Clouds
        let dt: Int
        let sys: Sys
        let timezone: Int
        let id: Int
        let name: String
        let cod: Int
    }
    
    struct Coord: Codable {
        let lon, lat: Double
    }
    
    struct Weather: Codable {
        let id: Int
        let main, description, icon: String
    }
    
    struct Main: Codable {
        let temp, feelsLike, tempMin, tempMax: Double
        let pressure, humidity: Int
        
        enum CodingKeys: String, CodingKey {
            case temp, pressure, humidity
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
        }
    }
    
    struct Wind: Codable {
        let speed: Double
        let deg: Int
    }
    
    struct Clouds: Codable {
        let all: Int
    }
    
    struct Sys: Codable {
        let type, id: Int?
        let country: String
        let sunrise, sunset: Int
    }
    
    struct ForecastData: Codable {
        let list: [ForecastListItem]
        let city: CityInfo
    }
    
    struct ForecastListItem: Codable {
        let dt: Int
        let main: Main
        let weather: [Weather]
        let clouds: Clouds
        let wind: Wind
        let pop: Double
        let dtTxt: String
        
        enum CodingKeys: String, CodingKey {
            case dt, main, weather, clouds, wind, pop
            case dtTxt = "dt_txt"
        }
    }
    
    struct CityInfo: Codable {
        let id: Int
        let name: String
        let coord: Coord
        let country: String
        let population, timezone, sunrise, sunset: Int
    }

struct DailyForecast {
    let day: String?
    let minTemp: Double
    let maxTemp: Double
    let icon: String
}
    
