//
//  NSCalendar+TBRPAddition.swift
//  TBRepeatPicker
//
//  Created by 洪鑫 on 15/9/27.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import Foundation

extension NSCalendar {
    class func dayIndexInWeek(date: NSDate) -> Int {
		return components(date: date).weekday
    }
    
    class func dayIndexInMonth(date: NSDate) -> Int {
		return components(date: date).day
    }
    
    class func monthIndexInYear(date: NSDate) -> Int {
		return components(date: date).month
    }
    
    private class func components(date: NSDate) -> NSDateComponents {
		var calendar = NSCalendar.current
		calendar.locale = NSLocale.current
		let components = calendar.dateComponents([.month, .weekday, .day], from: date as Date)
		return components as NSDateComponents
    }
}
