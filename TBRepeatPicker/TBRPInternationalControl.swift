//
//  TBRPInternationalControl.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/30.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import Foundation

class TBRPInternationalControl: NSObject {
    var language: TBRPLanguage = .English
    
    convenience init(language: TBRPLanguage!) {
        self.init()
        
        self.language = language
    }
    
    private func localizedForKey(key: String!) -> String? {
		let path = Bundle.main.path(forResource: TBRPInternationalControl.languageKey(language: language), ofType: "lproj")
        if let _ = path {
			let bundle = Bundle(path: path!)
			return bundle!.localizedString(forKey: key, value: nil, table: "TBRPLocalizable")
        } else {
            return nil
        }
    }
    
    func localized(key: String!, comment: String!) -> String {
		if let localizedString = localizedForKey(key: key) as String? {
            if localizedString == key {
                return comment
            }
            return localizedString
        }
        return comment
    }
    
    class func languageKey(language: TBRPLanguage) -> String {
        let languageKeys = ["en", "zh-Hans", "zh-Hant", "ko", "ja"]
        
        return languageKeys[language.rawValue]
    }
}
