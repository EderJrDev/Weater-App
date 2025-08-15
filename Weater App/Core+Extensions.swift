//
//  Core+Extensions.swift
//  Weater App
//
//  Created by Eder Junior Alves Silva on 14/08/25.
//

import Foundation

extension Int {
    func toWeekdayName() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE" // "EE" represents the full weekday name
        
        return dateFormatter.string(from: date)
    }
    
    func toHourFormat() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // "HH:mm" represents the 24-hour format
        
        return dateFormatter.string(from: date)
    }
    
    func isDayTime() -> Bool {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let hour = Calendar.current.component(.hour, from: date)
        
        let dayStartHour = 6
        let dayEndHour = 18
        
        return hour >= dayStartHour && hour < dayEndHour
    }
    
    func toDayOfWeek() -> String {
           let date = Date(timeIntervalSince1970: TimeInterval(self))
           let dateFormatter = DateFormatter()
           // Define o formato para o nome completo do dia da semana
           dateFormatter.dateFormat = "EE"
           // Define a localidade para português do Brasil para obter "Sexta-feira", etc.
//           dateFormatter.locale = Locale(identifier: "pt_BR")
           // Converte a data para a String formatada
        return dateFormatter.string(from: date).uppercased()
       }
}

extension Double {
    func toCelsius () -> String {
        "\(Int(self))°C"
    }
}

