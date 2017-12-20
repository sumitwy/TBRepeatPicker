//
//  TBRPHelper.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/28.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

let TBRPScreenWidth: CGFloat = UIScreen.main.bounds.size.width
let TBRPScreenHeight: CGFloat = UIScreen.main.bounds.size.height
let iPhone6PlusScreenWidth: CGFloat = 414.0

let TBRPTopSeparatorIdentifier = "TBRPTopSeparator"
let TBRPBottomSeparatorIdentifier = "TBRPBottomSeparator"
let TBRPSeparatorLineWidth: CGFloat = 0.5

class TBRPHelper {
    class func leadingMargin() -> CGFloat {
        if TBRPScreenWidth == iPhone6PlusScreenWidth {
            return 20.0
        }
        return 15.0
    }
    
	class func separatorColor() -> CGColor {
        let defaultSeparatorColor = UITableView().separatorColor
        let red = defaultSeparatorColor?.rgbComponents.red
        let green = defaultSeparatorColor?.rgbComponents.green
        let blue = defaultSeparatorColor?.rgbComponents.blue
        let bit: CGFloat = 255.0
        
		return UIColor.init(red: red! / bit, green: green! / bit, blue: blue! / bit, alpha: 0.7).cgColor
    }
    
    class func detailTextColor() -> UIColor {
		return UIColor.gray
    }
    
    class func weekdays(language: TBRPLanguage) -> [String] {
		let languageLocale = NSLocale(localeIdentifier: TBRPInternationalControl.languageKey(language: language))
        
		let dateFormatter = DateFormatter()
		dateFormatter.locale = languageLocale as Locale!
        return dateFormatter.weekdaySymbols
    }
    
    class func yearMonths(language: TBRPLanguage) -> [String] {
		let languageLocale = NSLocale(localeIdentifier: TBRPInternationalControl.languageKey(language: language))
        
		let dateFormatter = DateFormatter()
		dateFormatter.locale = languageLocale as Locale!
        return dateFormatter.shortMonthSymbols
    }
    
    class func completeYearMonths(language: TBRPLanguage) -> [String] {
		let languageLocale = NSLocale(localeIdentifier: TBRPInternationalControl.languageKey(language: language))
        
		let dateFormatter = DateFormatter()
		dateFormatter.locale = languageLocale as Locale!
        return dateFormatter.monthSymbols
    }
    
    class func englishDayString(day: Int) -> String {
        var suffix = "th"
        let ones = day % 10
        let tens = (day / 10) % 10
        
        if (tens == 1) {
            suffix = "th"
        } else if (ones == 1) {
            suffix = "st"
        } else if (ones == 2) {
            suffix = "nd"
        } else if (ones == 3) {
            suffix = "rd"
        } else {
            suffix = "th"
        }
        
        return "\(day)\(suffix)"
    }
    
    class func frequencies(language: TBRPLanguage) -> [String] {
        let internationalControl = TBRPInternationalControl(language: language)
        
		return [internationalControl.localized(key: "TBRPHelper.frequencies.daily", comment: "Daily"),
				internationalControl.localized(key: "TBRPHelper.frequencies.weekly", comment: "Weekly"),
				internationalControl.localized(key: "TBRPHelper.frequencies.monthly", comment: "Monthly"),
				internationalControl.localized(key: "TBRPHelper.frequencies.yearly", comment: "Yearly")]
    }
    
    class func units(language: TBRPLanguage) -> [String] {
        let internationalControl = TBRPInternationalControl(language: language)
        
		return [internationalControl.localized(key: "TBRPHelper.units.day", comment: "Day"),
				internationalControl.localized(key: "TBRPHelper.units.week", comment: "Week"),
				internationalControl.localized(key: "TBRPHelper.units.month", comment: "Month"),
				internationalControl.localized(key: "TBRPHelper.units.year", comment: "Year")]
    }
    
    class func pluralUnits(language: TBRPLanguage) -> [String] {
        let internationalControl = TBRPInternationalControl(language: language)
        
		return [internationalControl.localized(key: "TBRPHelper.pluralUnits.days", comment: "days"),
				internationalControl.localized(key: "TBRPHelper.pluralUnits.weeks", comment: "weeks"),
				internationalControl.localized(key: "TBRPHelper.pluralUnits.months", comment: "months"),
				internationalControl.localized(key: "TBRPHelper.pluralUnits.years", comment: "years")]
    }
    
    class func presetRepeats(language: TBRPLanguage) -> [String] {
        let internationalControl = TBRPInternationalControl(language: language)
        
		return [
			internationalControl.localized(key: "TBRPHelper.presetRepeat.never", comment: "Never"),
			internationalControl.localized(key: "TBRPHelper.presetRepeat.everyDay", comment: "Every Day"),
			internationalControl.localized(key: "TBRPHelper.presetRepeat.everyWeek", comment: "Every Week"),
			internationalControl.localized(key: "TBRPHelper.presetRepeat.everyTwoWeeks", comment: "Every 2 Weeks"),
			internationalControl.localized(key: "TBRPHelper.presetRepeat.everyMonth", comment: "Every Month"),
			internationalControl.localized(key: "TBRPHelper.presetRepeat.everyYear", comment: "Every Year")]
    }
    
    class func daysInWeekPicker(language: TBRPLanguage) -> [String] {
        let internationalControl = TBRPInternationalControl(language: language)
		let commonWeekdays = weekdays(language: language)
		let additionDays = [internationalControl.localized(key: "TBRPHelper.daysInWeekPicker.day", comment: "day"),
							internationalControl.localized(key: "TBRPHelper.daysInWeekPicker.weekday", comment: "weekday"),
							internationalControl.localized(key: "TBRPHelper.daysInWeekPicker.weekendDay", comment: "weekend day")]
        
        return commonWeekdays + additionDays
    }
    
    class func numbersInWeekPicker(language: TBRPLanguage) -> [String] {
        let internationalControl = TBRPInternationalControl(language: language)
        
		return [internationalControl.localized(key: "TBRPHelper.numbersInWeekPicker.first", comment: "first"),
				internationalControl.localized(key: "TBRPHelper.numbersInWeekPicker.second", comment: "second"),
				internationalControl.localized(key: "TBRPHelper.numbersInWeekPicker.third", comment: "third"),
				internationalControl.localized(key: "TBRPHelper.numbersInWeekPicker.fourth", comment: "fourth"),
				internationalControl.localized(key: "TBRPHelper.numbersInWeekPicker.fifth", comment: "fifth"),
				internationalControl.localized(key: "TBRPHelper.numbersInWeekPicker.last", comment: "last")]
    }
    
    class func recurrenceString(recurrence: TBRecurrence, occurrenceDate: NSDate, language: TBRPLanguage) -> String? {
        let internationalControl = TBRPInternationalControl(language: language)
        
        var unitString: String?
        if language == .Korean || language == .Japanese {
			unitString = "\(recurrence.interval)" + pluralUnits(language: language)[recurrence.frequency.rawValue]
        } else {
            if recurrence.interval == 1 {
				unitString = units(language: language)[recurrence.frequency.rawValue]
            } else if recurrence.interval > 1 {
                if language == .English {
					unitString = "\(recurrence.interval)" + " " + pluralUnits(language: language)[recurrence.frequency.rawValue]
                } else {
					unitString = "\(recurrence.interval)" + pluralUnits(language: language)[recurrence.frequency.rawValue]
                }
            }
        }
        
		unitString = unitString?.lowercased()
        
        if unitString == nil {
            return nil
        }
        
        if recurrence.frequency == .Daily {
            // Daily
			return String(format: internationalControl.localized(key: "RecurrenceString.presetRepeat", comment: "Event will occur every %@."), unitString!)
        } else if recurrence.frequency == .Weekly {
            // Weekly
			let occurrenceDateDayIndexInWeek = NSCalendar.dayIndexInWeek(date: occurrenceDate)
            
            if recurrence.selectedWeekdays == [occurrenceDateDayIndexInWeek - 1] {
				return String(format: internationalControl.localized(key: "RecurrenceString.presetRepeat", comment: "Event will occur every %@."), unitString!)
            } else if recurrence.isWeekdayRecurrence() {
				return internationalControl.localized(key: "RecurrenceString.weekdayRecurrence", comment: "Event will occur every weekday.")
            } else if recurrence.selectedWeekdays == [0, 1, 2, 3, 4, 5, 6] && recurrence.interval == 1 {
				return recurrenceString(recurrence: TBRecurrence.dailyRecurrence(occurrenceDate: occurrenceDate), occurrenceDate: occurrenceDate, language: language)
            } else {
                var weekdaysString: String
                if language == .Korean {
					weekdaysString = weekdays(language: language)[recurrence.selectedWeekdays.first!]
                } else {
					weekdaysString = internationalControl.localized(key: "RecurrenceString.element.on.weekly", comment: "on") + " " + weekdays(language: language)[recurrence.selectedWeekdays.first!]
                }
                
                for i in 1..<recurrence.selectedWeekdays.count {
                    var prefixStr: String?
                    if i == recurrence.selectedWeekdays.count - 1 {
						prefixStr = " " + internationalControl.localized(key: "RecurrenceString.element.and", comment: "and")
                    } else {
						prefixStr = internationalControl.localized(key: "RecurrenceString.element.comma", comment: ",")
                    }
                    
					weekdaysString += prefixStr! + " " + weekdays(language: language)[recurrence.selectedWeekdays[i]]
                }
                
                if language != .English && language != .Korean {
					weekdaysString.removeSubstring(substring: " ")
                }
                
                if language == .Korean {
					weekdaysString += internationalControl.localized(key: "RecurrenceString.element.on.weekly", comment: "on")
                }
                
				return String(format: internationalControl.localized(key: "RecurrenceString.specifiedDaysOrMonths", comment: "Event will occur every %@ %@"), unitString!, weekdaysString)
            }
            
        } else if recurrence.frequency == .Monthly {
            // Monthly
            if recurrence.byWeekNumber == true {
                var weekNumberString: String
                
                if language == .Korean {
					weekNumberString = "\(numbersInWeekPicker(language: language)[recurrence.pickedWeekNumber.rawValue])" + " " + "\(daysInWeekPicker(language: language)[recurrence.pickedWeekday.rawValue])" + internationalControl.localized(key: "RecurrenceString.element.on.monthly", comment: "on the")
                } else {
					weekNumberString = internationalControl.localized(key: "RecurrenceString.element.on.monthly", comment: "on the") + " " + "\(numbersInWeekPicker(language: language)[recurrence.pickedWeekNumber.rawValue])" + " " + "\(daysInWeekPicker(language: language)[recurrence.pickedWeekday.rawValue])"
                }
                
                if language != .English && language != .Korean {
					weekNumberString.removeSubstring(substring: " ")
                }
                
				return String(format: internationalControl.localized(key: "RecurrenceString.specifiedDaysOrMonths", comment: "Event will occur every %@ %@"), unitString!, weekNumberString)
            } else {
				let occurrenceDateDayIndexInMonth = NSCalendar.dayIndexInMonth(date: occurrenceDate)
                
                if recurrence.selectedMonthdays == [occurrenceDateDayIndexInMonth] {
					return String(format: internationalControl.localized(key: "RecurrenceString.presetRepeat", comment: "Event will occur every %@."), unitString!)
                } else {
                    var monthdaysString: String
                    if language == .English {
						monthdaysString = internationalControl.localized(key: "RecurrenceString.element.on.monthly", comment: "on the") + " " + englishDayString(day: recurrence.selectedMonthdays.first!)
                    } else if language == .Korean {
						monthdaysString = String(format: internationalControl.localized(key: "RecurrenceString.element.day", comment: ""), recurrence.selectedMonthdays.first!)
                    } else {
						monthdaysString = internationalControl.localized(key: "RecurrenceString.element.on.monthly", comment: "on the") + String(format: internationalControl.localized(key: "RecurrenceString.element.day", comment: ""), recurrence.selectedMonthdays.first!)
                    }
                    
                    for i in 1..<recurrence.selectedMonthdays.count {
                        var prefixStr: String?
                        if i == recurrence.selectedMonthdays.count - 1 {
							prefixStr = " " + internationalControl.localized(key: "RecurrenceString.element.and", comment: "and")
                        } else {
							prefixStr = internationalControl.localized(key: "RecurrenceString.element.comma", comment: ",")
                        }
                        
                        if language == .English {
							monthdaysString += prefixStr! + " " + englishDayString(day: recurrence.selectedMonthdays[i])
                        } else {
							monthdaysString += prefixStr! + " " + String(format: internationalControl.localized(key: "RecurrenceString.element.day", comment: ""), recurrence.selectedMonthdays[i])
                        }
                    }
                    
                    if language != .English && language != .Korean {
						monthdaysString.removeSubstring(substring: " ")
                    } else if language == .Korean {
						monthdaysString += internationalControl.localized(key: "RecurrenceString.element.on.monthly", comment: "")
                    }
                    
					return String(format: internationalControl.localized(key: "RecurrenceString.specifiedDaysOrMonths", comment: "Event will occur every %@ %@"), unitString!, monthdaysString)
                }
            }
        } else if recurrence.frequency == .Yearly {
            // Yearly
            if recurrence.byWeekNumber == true {
				var pickedWeekdayString = internationalControl.localized(key: "RecurrenceString.element.on.yearlyWeekString", comment: "on the") + " " + "\(numbersInWeekPicker(language: language)[recurrence.pickedWeekNumber.rawValue])" + " " + "\(daysInWeekPicker(language: language)[recurrence.pickedWeekday.rawValue])"
                
                var monthsString: String
                if language == .English {
					monthsString = internationalControl.localized(key: "RecurrenceString.element.on.yearlyMonths.byWeekNo", comment: "of") + " " + completeYearMonths(language: language)[recurrence.selectedMonths.first! - 1]
                } else if language == .Korean {
					monthsString = yearMonths(language: language)[recurrence.selectedMonths.first! - 1]
                } else {
					monthsString = internationalControl.localized(key: "RecurrenceString.element.on.yearlyMonths.byWeekNo", comment: "of") + yearMonths(language: language)[recurrence.selectedMonths.first! - 1]
                }
                
                for i in 1..<recurrence.selectedMonths.count {
                    var prefixStr: String?
                    if i == recurrence.selectedMonths.count - 1 {
						prefixStr = " " + internationalControl.localized(key: "RecurrenceString.element.and", comment: "and")
                    } else {
						prefixStr = internationalControl.localized(key: "RecurrenceString.element.comma", comment: ",")
                    }
                    
                    if language == .English {
						monthsString += prefixStr! + " " + completeYearMonths(language: language)[recurrence.selectedMonths[i] - 1]
                    } else {
						monthsString += prefixStr! + " " + yearMonths(language: language)[recurrence.selectedMonths[i] - 1]
                    }
                }
                
                if language != .English && language != .Korean {
					pickedWeekdayString.removeSubstring(substring: " ")
					monthsString.removeSubstring(substring: " ")
                }
                
                if language == .Korean {
					pickedWeekdayString += internationalControl.localized(key: "RecurrenceString.element.on.yearlyMonths.byWeekNo", comment: "of")
                }
                
                if language == .English {
					return String(format: internationalControl.localized(key: "RecurrenceString.yearlyByWeekNoString", comment: "Event will occur every %@ %@ %@"), unitString!, pickedWeekdayString, monthsString)
                } else {
					return String(format: internationalControl.localized(key: "RecurrenceString.yearlyByWeekNoString", comment: "Event will occur every %@ %@ %@"), unitString!, monthsString, pickedWeekdayString)
                }
                
            } else {
				let occurrenceDateMonthIndexInYear = NSCalendar.monthIndexInYear(date: occurrenceDate)
                
                if recurrence.selectedMonths == [occurrenceDateMonthIndexInYear] {
					return String(format: internationalControl.localized(key: "RecurrenceString.presetRepeat", comment: "Event will occur every %@."), unitString!)
                } else {
                    var monthsString: String
                    if language == .English {
						monthsString = internationalControl.localized(key: "RecurrenceString.element.on.yearlyMonths", comment: "in") + " " + completeYearMonths(language: language)[recurrence.selectedMonths.first! - 1]
                    } else if language == .Korean {
						monthsString = completeYearMonths(language: language)[recurrence.selectedMonths.first! - 1]
                    } else {
						monthsString = internationalControl.localized(key: "RecurrenceString.element.on.yearlyMonths", comment: "in") + yearMonths(language: language)[recurrence.selectedMonths.first! - 1]
                    }
                    
                    for i in 1..<recurrence.selectedMonths.count {
                        var prefixStr: String?
                        if i == recurrence.selectedMonths.count - 1 {
							prefixStr = " " + internationalControl.localized(key: "RecurrenceString.element.and", comment: "and")
                        } else {
							prefixStr = internationalControl.localized(key: "RecurrenceString.element.comma", comment: ",")
                        }
                        
                        if language == .English {
							monthsString += prefixStr! + " " + completeYearMonths(language: language)[recurrence.selectedMonths[i] - 1]
                        } else {
							monthsString += prefixStr! + " " + yearMonths(language: language)[recurrence.selectedMonths[i] - 1]
                        }
                    }
                    
                    if language != .English && language != .Korean {
						monthsString.removeSubstring(substring: " ")
                    }
                    
                    if language == .Korean {
						monthsString += internationalControl.localized(key: "RecurrenceString.element.on.yearlyMonths", comment: "in")
                    }
                    
					return String(format: internationalControl.localized(key: "RecurrenceString.specifiedDaysOrMonths", comment: "Event will occur every %@ %@"), unitString!, monthsString)
                }
            }
            
        } else {
            return nil
        }
    }
    
}
