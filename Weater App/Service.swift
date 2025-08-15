//
//  Service.swift
//  Weater App
//
//  Created by Eder Junior Alves Silva on 14/08/25.
//

import Foundation

// Estrutura para representar uma cidade com suas coordenadas.
struct City {
    let lat: String
    let lon: String
    let name: String
}

// Classe responsável por buscar os dados da API OpenWeatherMap.
class Service {
    // ATUALIZADO: URL base para a API gratuita de tempo atual.
    private let baseURL: String = "https://api.openweathermap.org/data/2.5/weather"
    // Lembre-se de proteger sua chave de API em um aplicativo real.
    private let apiKey: String = "8f8b00810a0f32122a8217877d806d95"
    private let session = URLSession.shared
    
    // ATUALIZADO: A função agora busca e retorna o novo modelo 'CurrentWeatherData'.
    func fetchData(city: City, _ completion: @escaping (CurrentWeatherData?) -> Void) {
        // Adicionando 'units=metric' para receber temperaturas em Celsius e 'lang=pt_br' para português.
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
            
            // Tenta decodificar os dados JSON usando o novo modelo CurrentWeatherData
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
                
                // Tenta decodificar os dados JSON usando o novo modelo CurrentWeatherData
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
    
    
    // MARK: - NOVOS MODELOS DE DADOS PARA A API GRATUITA
    
    // Estrutura principal para a resposta da API /weather
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
    
    // Estruturas aninhadas que compõem a resposta principal.
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
    
    
    // Cada item na lista de previsão
    struct ForecastListItem: Codable {
        let dt: Int
        let main: Main
        let weather: [Weather]
        let clouds: Clouds
        let wind: Wind
        let pop: Double // Probabilidade de precipitação
        let dtTxt: String
        
        enum CodingKeys: String, CodingKey {
            case dt, main, weather, clouds, wind, pop
            case dtTxt = "dt_txt"
        }
    }
    
    // Informações da cidade na resposta da previsão
    struct CityInfo: Codable {
        let id: Int
        let name: String
        let coord: Coord
        let country: String
        let population, timezone, sunrise, sunset: Int
    }

// Adicione esta struct no seu arquivo de modelos
struct DailyForecast {
    let day: String? // Ex: "Sexta"
    let minTemp: Double
    let maxTemp: Double
    let icon: String // Ícone para representar o dia
}
    
