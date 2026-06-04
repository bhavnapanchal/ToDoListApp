//
//  Date+Formatting.swift
//  ToDoListApp
//
//  Created by Ami Panchal on 27/04/26.
//

import Foundation
enum DateFormatType{
    case dateTime
    case date
    case time
    
    var value:String {
        switch self{
        case .dateTime:
            return "yyyy-MM-dd hh:mm a"
        case .date:
            return "yyyy-MM-dd"
        case .time:
            return "hh:mm a"
        }
    }
}

class DateFormatterManager{
    static let shared = DateFormatterManager()
    
    func formatter(formateType: DateFormatType) -> DateFormatter{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = formateType.value
        formatter.timeZone = TimeZone.current
        
        return formatter
    }
}

extension Date {
    static func combineDateAndTime(date: Date, time: Date) -> Date{
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        var finalComponents = DateComponents()
        
        finalComponents.year = dateComponents.year
        finalComponents.month = dateComponents.month
        finalComponents.day = dateComponents.day
        finalComponents.hour = timeComponents.hour
        finalComponents.minute = timeComponents.minute
        
        let combined = calendar.date(from: finalComponents)

        return combined!
    }
    func convertToString(formatType: DateFormatType) -> String{
        let formatter = DateFormatterManager.shared.formatter(formateType: formatType)
        return formatter.string(from: self)
    }
}

extension String {
    func convertToDate(formatType: DateFormatType) -> Date{
        let formatter = DateFormatterManager.shared.formatter(formateType: formatType)
        print(self)
        return formatter.date(from: self) ?? Date()
    }
}

