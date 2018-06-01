//
//  Date+Extensions.swift
//  motem-ios
//
//  Created by Mobexs on 12/26/16.
//  Copyright © 2016 Mobexs.com. All rights reserved.
//

import Foundation

extension Date {

    var components:DateComponents {

        let calendar = Calendar.init(identifier: .iso8601)
        return calendar.dateComponents(Set([.year, .month, .day, .hour, .minute, .second, .weekday, .weekOfYear, .yearForWeekOfYear]), from: self)
    }

    static func firstDayOfWeek(from sourceDate:Date) -> Date? {
        
        let calendar = Calendar.init(identifier: .iso8601)

        var components = calendar.dateComponents(Set([.yearForWeekOfYear, .weekOfYear ,.weekday]), from: sourceDate)
        components.weekday = 2//monday
        
        return calendar.date(from: components)
    }

    static func lastDayOfWeek(from sourceDate:Date) -> Date? {

        guard let firstDayOfWeek = Date.firstDayOfWeek(from: sourceDate) else {

            return nil
        }

        return Date.nextDay(from: firstDayOfWeek, numberOfDays: 6)
    }

    static func nextDay(from sourceDate:Date, numberOfDays: Int) -> Date? {

        let calendar = Calendar.init(identifier: .iso8601)
        return calendar.date(byAdding: .day, value: numberOfDays, to: sourceDate)
    }

    static func weekOfYear(fromDate date: Date) -> Int? {

        let calendar = Calendar.init(identifier: .iso8601)
        return calendar.dateComponents(Set([.weekOfYear]), from: date).weekOfYear
    }

    static func firstDayOfMonth(from sourceDate:Date) -> Date? {

        let calendar = Calendar.init(identifier: .iso8601)
        let components = calendar.dateComponents(Set([.year, .month]), from: sourceDate)
        return calendar.date(from: components)
    }

    static func lastDayOfMonth(from sourceDate:Date) -> Date? {

        let calendar = Calendar.init(identifier: .iso8601)
        guard let firstDayOfMonth = Date.firstDayOfMonth(from: sourceDate) else {

            return nil
        }

        var components = DateComponents()
        components.month = 1
        components.day = -1
        
        return calendar.date(byAdding: components, to: firstDayOfMonth)
    }
    
    func startOfTheDay() -> Date? {
     
        return Calendar.init(identifier: .iso8601).startOfDay(for: self)
    }
    
    static func endOfTheDay(fromDate date: Date) -> Date? {
    
        var components = date.components
        components.setValue(23, for: .hour)
        components.setValue(59, for: .minute)
        components.setValue(59, for: .second)
        
        return Calendar.init(identifier: .iso8601).date(from: components)
    }
    
    func endOfTheDay() -> Date? {
        
        var components = self.components
        components.setValue(23, for: .hour)
        components.setValue(59, for: .minute)
        components.setValue(59, for: .second)
        
        return Calendar.init(identifier: .iso8601).date(from: components)
    }
    
    func isBetweeen(date date1: Date, andDate date2: Date) -> Bool {
        return date1.compare(self) == self.compare(date2)
    }
    
    func isBetweeenOrEqual(date date1: Date, andDate date2: Date) -> Bool {
        return date1.compare(self) == self.compare(date2) || date1 == self || date2 == self
    }
    
    static func duration(fromBeginDate beginDate: Date,toEndDate endDate: Date) -> (days: Int, hours: Int, minutes: Int, seconds: Int, timeInterval: Double) {
        
        let intervalFromStartDate = endDate.timeIntervalSince(beginDate)
        
        let days = Int(intervalFromStartDate / 60 / 60 / 24) % 60
        let hours = Int(intervalFromStartDate / 60 / 60) % 60
        let minutes =  Int(intervalFromStartDate / 60) % 60
        let seconds =  Int(intervalFromStartDate ) % 60
        let interval = Double(intervalFromStartDate)
        
        return (days, hours, minutes, seconds, interval)
    }
    
    func isToday() -> Bool {
        
        let componentsSelf = self.components
        let componentsToday = Date().components
        
        return (componentsSelf.year == componentsToday.year &&
                componentsSelf.month == componentsToday.month &&
                componentsSelf.day == componentsToday.day)
    }
    
    func isOnCurrentWeek() -> Bool {
        
        let componentsSelf = self.components
        let componentsToday = Date().components
        
        return componentsSelf.weekOfYear == componentsToday.weekOfYear
    }
    
    func dateString(withFormat format: String) -> String {
        
        let df = DateFormatter()
        df.dateFormat = format
        
        return df.string(from: self)
    }
    
    func dateStringUTC(withFormat format: String) -> String {
        
        let df = DateFormatter()
        df.dateFormat = format
        df.timeZone = TimeZone(abbreviation: "UTC")!
        
        return df.string(from: self)
    }
    
    func clearUTCDate() -> Date {
        
        let df = DateFormatter()
        df.dateFormat = "YY-MM-dd"
        df.timeZone = TimeZone(abbreviation: "UTC")
        
        let dateString = df.string(from: self)
        
        let df2 = DateFormatter()
        df2.dateFormat = "YY-MM-dd"
        
        
        return df2.date(from: dateString)!
    }
}


