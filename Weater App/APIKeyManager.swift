//
//  APIKeyManager.swift
//  Weater App
//
//  Created by Eder Junior Alves Silva on 15/08/25.
//

import Foundation

enum APIKeyManager {
    static var openWeatherMap: String {
        // 1. Tenta acessar o Info.plist do seu app
        guard let infoDictionary = Bundle.main.infoDictionary else {
            fatalError("Info.plist file not found")
        }

        // 2. Tenta ler a chave que você configurou no Passo 4
        // APIKeyManager.swift
        guard let apiKey = infoDictionary["OpenWeatherApiKey"] as? String else {
            fatalError("OpenWeatherApiKey not set in Info.plist")
        }
        
        // 3. Verifica se a chave não está vazia
        if apiKey.isEmpty {
            fatalError("API Key is empty. Please set it in Secrets.xcconfig")
        }

        // 4. Retorna a chave
        return apiKey
    }
}
